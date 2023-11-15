import * as fse from 'fs-extra';
import * as path from 'path';

function copyPlaybookUISupplementalFiles(
  playbookConfigFileDirectory: string,
  playbookUIConfig: object,
  buildDir: string
) {
  const supplemental_files = playbookUIConfig['supplemental_files'];

  if (!supplemental_files) {
    return;
  }

  const supplementalFilesPath = path.join(
    playbookConfigFileDirectory,
    supplemental_files
  );

  const buildDirSupplementalFiles = path.join(buildDir, supplemental_files);

  fse.copySync(supplementalFilesPath, buildDirSupplementalFiles);
}

export function copyPlaybookUIFiles(
  playbookConfigFileDirectory: string,
  playbookConfig: object,
  buildDir: string
) {
  if (!playbookConfig) {
    return;
  }

  const ui = playbookConfig['ui'];

  if (!ui) {
    return;
  }

  copyPlaybookUISupplementalFiles(playbookConfigFileDirectory, ui, buildDir);
}
