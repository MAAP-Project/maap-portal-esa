import executor from './executor';
import { FaqBuildExecutorSchema } from './schema';

const options: FaqBuildExecutorSchema = {};

describe('FaqBuild Executor', () => {
  it('can run', async () => {
    const output = await executor(options);
    expect(output.success).toBe(true);
  });
});
