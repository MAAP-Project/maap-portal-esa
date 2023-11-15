import { ExecutorContext } from '@nrwl/devkit';
import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as yaml from 'yaml';
import { getBuildDir, parsePlaybookConfigFile } from '../utils';
import { AntoraPdfExecutorSchema } from './schema';
import { isNavTree, NavTree, parseNavConfig } from './src/parse-nav-config';

const docsPdfHeader = `
= MAAP doc
:toc:
:doctype: book

<<<

`;

interface Doc {
  components: Component[];
}

interface Component {
  name: string;
  pages: (Page | PageTree)[];
}

type PageTree = { page?: Page; pages: (Page | PageTree)[] };

function isPageTree(page: Page | PageTree): page is PageTree {
  return Object.keys(page).includes('pages');
}

interface Page {
  path: string;
}

interface AntoraBuildContext {
  playbookPath: string;
  playbookConfigPath: string;
  playbookConfig: object;
  buildDir: string;
  pagesBuildDir: string;
  outputPath: string;
}

function computePage(context: AntoraBuildContext, pagePath?: string) {
  if (!pagePath) {
    return null;
  }

  const asciidocPagePath = pagePath + '.adoc';

  // Compute asciidoc file to pdf
  const page: Page = {
    path: asciidocPagePath,
  };

  return page;
}

function parsePages(
  context: AntoraBuildContext,
  pagesPaths: (string | NavTree)[]
) {
  const pages = pagesPaths
    .map((pagePath) => {
      if (isNavTree(pagePath)) {
        const page = computePage(context, pagePath.page);
        const subpages = parsePages(context, pagePath.pages);
        const pageTree: PageTree = {
          page,
          pages: subpages,
        };
        return pageTree;
      } else {
        const page = computePage(context, pagePath);
        return page;
      }
    })
    .filter((page) => page);

  return pages;
}

function parseNav(
  context: AntoraBuildContext,
  navConfigPath: string,
  navPath: string
) {
  const navConfig = parseNavConfig(navConfigPath, navPath);

  const pages = parsePages(context, navConfig.pages);

  return pages;
}

function parseNavs(
  context: AntoraBuildContext,
  componentConfig: object,
  componentPath: string
) {
  const navPaths = componentConfig['nav'];

  if (!navPaths) {
    return [];
  }

  let pages: (Page | PageTree)[] = [];

  for (const navRelPath of navPaths) {
    const navConfigPath = path.join(componentPath, navRelPath);

    const navAbsPath = path.dirname(navConfigPath);

    const navPages = parseNav(context, navConfigPath, navAbsPath);

    pages = pages.concat(navPages);
  }

  return pages;
}

function parseComponent(context: AntoraBuildContext, componentPath: string) {
  const componentConfigPath = path.join(componentPath, 'antora.yml');

  const componentConfigRaw = fs.readFileSync(componentConfigPath, 'utf-8');
  const componentConfig: object = yaml.parse(componentConfigRaw);

  const componentTitle: string = componentConfig['title'];

  const componentPages = parseNavs(context, componentConfig, componentPath);

  const component: Component = {
    name: componentTitle,
    pages: componentPages,
  };

  return component;
}

function parseComponents(context: AntoraBuildContext) {
  const playbookConfig = context.playbookConfig;
  const sources = playbookConfig['content']?.sources;

  if (!sources) {
    return [];
  }

  const components: Component[] = [];

  for (const source of sources) {
    const sourcePath = path.join(context.playbookPath, source.url);

    const component = parseComponent(context, sourcePath);

    components.push(component);
  }

  return components;
}

function parseAntoraDocs(context: AntoraBuildContext) {
  const components: Component[] = parseComponents(context);

  const docs: Doc = {
    components,
  };

  return docs;
}

function addDocPageToDocPdf(
  context: AntoraBuildContext,
  docsPdf: string,
  page?: Page
) {
  if (!page) {
    return docsPdf;
  }

  const relPath = path.relative(context.buildDir, page.path);

  docsPdf = docsPdf.concat(`
<<<

include::${relPath}[leveloffset=2]
`);

  return docsPdf;
}

function addDocPagesToDocPdf(
  context: AntoraBuildContext,
  docsPdf: string,
  pages: (Page | PageTree)[]
) {
  pages.forEach((page) => {
    if (isPageTree(page)) {
      docsPdf = addDocPageToDocPdf(context, docsPdf, page.page);
      docsPdf = addDocPagesToDocPdf(context, docsPdf, page.pages);
    } else {
      docsPdf = addDocPageToDocPdf(context, docsPdf, page);
    }
  });
  return docsPdf;
}

function addDocComponentToDocPdf(
  context: AntoraBuildContext,
  docsPdf: string,
  component: Component
) {
  docsPdf = docsPdf.concat(`
== ${component.name}
`);

  docsPdf = addDocPagesToDocPdf(context, docsPdf, component.pages);

  return docsPdf;
}

function generateDocsPdf(context: AntoraBuildContext, doc: Doc) {
  let docsPdf: string = docsPdfHeader;

  doc.components.forEach((component) => {
    docsPdf = addDocComponentToDocPdf(context, docsPdf, component);
  });

  return docsPdf;
}

function convertAntoraDocsToPdf(context: AntoraBuildContext) {
  const doc = parseAntoraDocs(context);

  const docsPdf = generateDocsPdf(context, doc);

  const docsPdfFilePath = path.join(context.buildDir, 'output.adoc');
  fs.writeFileSync(docsPdfFilePath, docsPdf);

  const outputPdfFilePath = path.join(context.outputPath, 'output.pdf');

  execSync(
    `asciidoctor-pdf ${docsPdfFilePath} -o ${outputPdfFilePath} -a allow-uri-read=true`
  );
}

function getAntoraBuildContext(
  projectName: string,
  playbookConfigFilePath: string,
  outputPath: string
): AntoraBuildContext {
  const playbookConfigFileDirectory = path.dirname(playbookConfigFilePath);
  const playbookConfig = parsePlaybookConfigFile(playbookConfigFilePath);

  const buildDir = getBuildDir(projectName, 'pdf');
  const pagesBuildDir = path.join(buildDir, 'pages');

  const context: AntoraBuildContext = {
    playbookPath: playbookConfigFileDirectory,
    playbookConfigPath: playbookConfigFilePath,
    playbookConfig,
    buildDir,
    pagesBuildDir,
    outputPath,
  };

  return context;
}

/**
 * Generate default output path from the project path and put it in the dist folder, e.g:
 * For a project with path 'apps/myproject' the resulting output path will be 'dist/apps/myproject'
 * @param  {ExecutorContext} context     Context given by nx on an executor function run
 * @return {string}                      Generated output path
 */
function getDefaultOutputPath(context: ExecutorContext) {
  const projectName = context.projectName;
  const projects = context.workspace.projects;
  const project = projects[projectName];
  const projectRoot = project.root;
  const defaultOutputPath = path.join('dist', projectRoot);

  return defaultOutputPath;
}

export default async function runExecutor(
  options: AntoraPdfExecutorSchema,
  executorContext: ExecutorContext
) {
  const projectName = executorContext.projectName;
  const playbookConfigFilePath = options.playbookConfigFile;
  const outputPath = getDefaultOutputPath(executorContext);

  const context = getAntoraBuildContext(
    projectName,
    playbookConfigFilePath,
    outputPath
  );

  fs.rmSync(context.buildDir, { recursive: true, force: true });
  fs.mkdirSync(context.buildDir, { recursive: true });
  fs.mkdirSync(context.pagesBuildDir, { recursive: true });

  convertAntoraDocsToPdf(context);
  // const mockedPlaybookConfigFile = mockGitRepositoryForLocalSources(
  //   mockedRepositoriesPath,
  //   playbookConfigFileDirectory,
  //   playbookConfig,
  //   buildDir
  // );

  // copyPlaybookUIFiles(playbookConfigFileDirectory, playbookConfig, buildDir);

  // process.env.portalURL = options.portalURL;

  // await cli([
  //   '',
  //   '',
  //   mockedPlaybookConfigFile,
  //   '--fetch',
  //   '--to-dir',
  //   options.outputPath,
  //   '--stacktrace',
  //   '--url',
  //   options.url,
  // ]);
  return {
    success: true,
  };
}
