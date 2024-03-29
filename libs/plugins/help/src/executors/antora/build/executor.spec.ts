import { BuildAntoraExecutorSchema } from './schema';
import executor from './executor';

const options: BuildAntoraExecutorSchema = {};

describe('BuildAntora Executor', () => {
  it('can run', async () => {
    const output = await executor(options);
    expect(output.success).toBe(true);
  });
});