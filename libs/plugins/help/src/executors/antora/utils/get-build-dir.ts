import * as path from 'path';

const tmpDir = 'tmp/antora/';

export function getBuildDir(projectName: string, executor: string) {
  const buildDir = path.join(tmpDir, projectName, executor);

  return buildDir;
}
