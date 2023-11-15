import { ExecutorContext } from '@nrwl/devkit';
import Processor from 'asciidoctor';
import * as fs from 'fs';
import * as path from 'path';
import { FaqBuildExecutorSchema } from './schema';

const asciidoctor = Processor();

let id = 0;

interface FAQMetaData {
  id: number;
  path: string;
  title: string;
}

/**
 * Find all ASCIIdoc files only at root of the srcDirectory, e.g:
 * findASCIIDocSrcFiles('./project/src') ==> ['./project/src/a.adoc','./project/src/b.adoc']
 * @param  {String} srcDirectory              Path were files are stored
 * @param  {Boolean} [verbose = false]        Print warning and extra logs
 * @return {string[]}                         Result files with path string in an array
 */
function findASCIIDocSrcFiles(srcDirectory: string, verbose = false): string[] {
  if (fs.existsSync(srcDirectory) === false) {
    if (verbose) {
      console.warn('srcDirectory path is does not exist');
    }
    return [];
  }

  const srcDirectoryStat = fs.statSync(srcDirectory);

  if (srcDirectoryStat.isDirectory() === false) {
    if (verbose) {
      console.warn('srcDirectory is not a directory');
    }
    return [];
  }

  const filesName = fs.readdirSync(srcDirectory);

  const filteredFilesName = filesName.filter((file) => file.endsWith('.adoc'));

  const filesPath = filteredFilesName.map((file) =>
    path.join(srcDirectory, file)
  );

  return filesPath;
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

function writeToJSONFile(
  object: object,
  fileName: string,
  directoryPath: string
) {
  const objectString = JSON.stringify(object);
  const filePath = path.join(directoryPath, fileName);

  fs.writeFileSync(filePath, objectString);
}

/**
 * Build an ASCIIdoc file to an HTML file and extract the metadata
 * @param  {string} filePath       Path to the file that should be build
 * @param  {string} outputPath     Output directory Path for the resulting html file
 * @param  {boolean} [verbose = false]       Print warning and extra logs
 * @return {FAQMetaData}       Metadata of the article
 */
async function buildASCIIDocFile(
  filePath: string,
  outputPath: string,
  verbose = false
) {
  const file = asciidoctor.convertFile(filePath, {
    to_file: true,
    standalone: false,
    doctype: 'article',
    to_dir: outputPath,
    mkdirs: true,
  });

  try {
    if (typeof file !== 'string') {
      const htmlFileName = file.getAttribute('docname');
      const title = file.getTitle();

      const metadata: FAQMetaData = {
        id: id++,
        path: htmlFileName,
        title,
      };

      return metadata;
    } else {
      throw 'Internal Error while converting ASCIIdoc file';
    }
  } catch (e) {
    if (verbose) {
      console.log(e);
    }
    return null;
  }
}

export default async function runExecutor(
  options: FaqBuildExecutorSchema,
  context: ExecutorContext
) {
  const srcDirectory = options.srcDirectory;

  const asciiDocSrcFilesArray = findASCIIDocSrcFiles(
    srcDirectory,
    context.isVerbose
  );

  const outputPath = options.outputPath || getDefaultOutputPath(context);

  const buildResults = await Promise.all(
    asciiDocSrcFilesArray.map((file) => buildASCIIDocFile(file, outputPath))
  );

  const buildResultsFiltered = buildResults.filter(
    (res) => res != null && res != undefined
  );

  const buildResultsFileName = 'faq.json';

  writeToJSONFile(buildResultsFiltered, buildResultsFileName, outputPath);

  return {
    success: true,
  };
}
