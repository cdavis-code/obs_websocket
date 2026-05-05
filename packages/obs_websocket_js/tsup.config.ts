import { defineConfig } from 'tsup';

export default defineConfig([
  // Browser bundle — ESM only.
  {
    entry: { browser: 'src/browser.ts' },
    format: ['esm'],
    dts: true,
    sourcemap: true,
    clean: false,
    platform: 'browser',
    target: 'es2022',
    external: ['ws'], // never bundled into the browser output
  },
  // Node bundle — ESM + CJS, with `ws` as a peer.
  {
    entry: { node: 'src/node.ts' },
    format: ['esm', 'cjs'],
    dts: true,
    sourcemap: true,
    clean: false,
    platform: 'node',
    target: 'node18',
    external: ['ws', 'eventemitter3'],
  },
  // Shared type surface — re-exports types for `import {Type} from 'obs_websocket_js'`.
  {
    entry: { index: 'src/index.ts' },
    format: ['esm'],
    dts: true,
    sourcemap: true,
    clean: false,
    platform: 'neutral',
    target: 'es2022',
    external: ['ws', 'eventemitter3'],
  },
]);
