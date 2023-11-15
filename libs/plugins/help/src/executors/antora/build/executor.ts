import * as cli from '@antora/cli';
import { ExecutorContext } from '@nrwl/devkit';
import * as fs from 'fs';
import * as path from 'path';
import {
  copyPlaybookUIFiles,
  getBuildDir,
  mockGitRepositoryForLocalSources,
  parsePlaybookConfigFile,
} from '../utils';
import { BuildAntoraExecutorSchema } from './schema';

const mockedRepositoriesPath = 'repository/';

export default async function runExecutor(
  options: BuildAntoraExecutorSchema,
  context: ExecutorContext
) {
  const projectName = context.projectName;
  const playbookConfigFilePath = options.playbookConfigFile;

  const playbookConfigFileDirectory = path.dirname(playbookConfigFilePath);
  const playbookConfig = parsePlaybookConfigFile(playbookConfigFilePath);

  const buildDir = getBuildDir(projectName, 'build');

  fs.rmSync(buildDir, { recursive: true, force: true });
  fs.mkdirSync(buildDir, { recursive: true });

  const mockedPlaybookConfigFile = mockGitRepositoryForLocalSources(
    mockedRepositoriesPath,
    playbookConfigFileDirectory,
    playbookConfig,
    buildDir
  );

  copyPlaybookUIFiles(playbookConfigFileDirectory, playbookConfig, buildDir);

  process.env.portalURL = options.portalURL;

  await cli([
    '',
    '',
    mockedPlaybookConfigFile,
    '--fetch',
    '--to-dir',
    options.outputPath,
    '--stacktrace',
    '--url',
    options.url,
  ]);
  return {
    success: true,
  };
}
