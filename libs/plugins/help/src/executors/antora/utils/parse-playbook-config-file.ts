import * as fs from 'fs';
import { parse } from 'yaml';

export function parsePlaybookConfigFile(
  playbookConfigFilePath: string
): object {
  const playbookConfigFile = fs.readFileSync(playbookConfigFilePath, 'utf-8');
  const parsedPlaybookConfigFile = parse(playbookConfigFile);

  return parsedPlaybookConfigFile;
}
