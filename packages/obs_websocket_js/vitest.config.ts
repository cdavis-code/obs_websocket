/// <reference types="vitest" />
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['test/**/*.test.ts'],
    environmentMatchGlobs: [
      ['test/browser.test.ts', 'happy-dom'],
      ['test/node.test.ts', 'node'],
    ],
    testTimeout: 20_000,
  },
});
