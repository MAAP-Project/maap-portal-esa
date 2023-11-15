import { execSync } from 'child_process';
import * as fs from 'fs';
import * as fse from 'fs-extra';
import * as path from 'path';
import { stringify } from 'yaml';

let sourceId = 0;

export function mockGitRepositoryForLocalSources(
  mockedRepositoriesPath: string,
  playbookConfigFileDirectory: string,
  playbookConfig: object,
  buildDir: string
) {
  if (!playbookConfig) {
    return;
  }

  const content = playbookConfig['content'];

  if (!content) {
    return;
  }

  const sources = content.sources;

  if (!sources || sources.length < 0) {
    return;
  }

  const buildDirMockedRepositoriesPath = path.join(
    buildDir,
    mockedRepositoriesPath
  );

  const mockedSources = sources.map((source) => {
    const url = source.url;

    if (!url || !url.startsWith('./')) {
      return source;
    }

    const repositoryPath = path.join(playbookConfigFileDirectory, url);

    const buildDirMockedRepositoryPath = path.join(
      buildDirMockedRepositoriesPath,
      String(sourceId++)
    );

    fse.copySync(repositoryPath, buildDirMockedRepositoryPath);

    var osvar = process.platform;

    // init git repository
    if(osvar == 'win32'){
      console.log("you are on a windows os")
      const { spawn } = require('child_process');
      spawn(`chdir ${buildDirMockedRepositoryPath} && git init && echo.> .gitignore && git add .gitignore && git config user.email 'build@build.com' && git config user.name 'Build Build' && git commit -m "init repo"`, [], { shell: true, stdio: 'inherit' });
    }else{
    execSync(`
      cd ${buildDirMockedRepositoryPath} \
      && git init \
      && touch .gitignore \
      && git add .gitignore \
      && git config user.email "build@build.com" \
      && git config user.name "Build Build" \
      && git commit -m 'initialize repository' \
    `);
    }


    const mockedSourcePath = path.relative(
      buildDir,
      buildDirMockedRepositoryPath
    );

    return {
      ...source,
      url: './' + mockedSourcePath,
      branch: 'HEAD',
    };
  });

  const mockedPlaybookConfigFile = Object.assign({}, playbookConfig, {
    content: {
      sources: mockedSources,
    },
  });
  const stringMockedPlaybookConfigFile = stringify(mockedPlaybookConfigFile);

  const mockedPlaybookConfigFilePath = path.join(
    buildDir,
    'antora-playbook.yml'
  );

  fs.writeFileSync(
    mockedPlaybookConfigFilePath,
    stringMockedPlaybookConfigFile
  );

  return mockedPlaybookConfigFilePath;
}
