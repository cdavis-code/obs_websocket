/**
 * Browser entrypoint for obs_websocket_js.
 *
 * Loads the dart2js runtime (which references `self.WebSocket`, already
 * present in browsers) and re-exports the public API.
 */

import { ObsWebSocket as Base } from './index.js';
import type { ConnectOptions } from './types.js';

export * from './index.js';

/**
 * In production builds, `../build/dart/obs_websocket.js` is emitted by
 * dart2js and bundled alongside the TS output by tsup. The dynamic import
 * lets bundlers (vite/webpack/rollup) split it into a separate chunk.
 */
const loadDart = async () => {
  // @ts-expect-error -- resolved at build time; present in dist/.
  await import('../build/dart/obs_websocket.js');
};

export class ObsWebSocket extends Base {
  static override async connect(
    url: string,
    opts: ConnectOptions = {},
  ): Promise<ObsWebSocket> {
    return (await Base.connect(url, opts, loadDart)) as ObsWebSocket;
  }
}
