/**
 * Node.js entrypoint for obs_websocket_js.
 *
 * dart2js output targets the browser runtime — it expects `self`, `window`,
 * and `WebSocket` globals. We polyfill these before loading the compiled
 * module. Node 22+ has a native global `WebSocket`, so `ws` is only used as
 * a fallback on Node 18–21.
 */

import { ObsWebSocket as Base } from './index.js';
import type { ConnectOptions } from './types.js';

export * from './index.js';

const ensurePolyfills = async () => {
  const g = globalThis as any;
  if (!g.self) g.self = g;
  if (!g.window) g.window = g;
  if (!g.WebSocket) {
    const mod = await import('ws');
    g.WebSocket = (mod as any).WebSocket ?? (mod as any).default;
  }
};

const loadDart = async () => {
  await ensurePolyfills();
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

  /**
   * Convenience: connect using `process.env.OBS_WEBSOCKET_URL` /
   * `OBS_WEBSOCKET_PASSWORD` / `OBS_WEBSOCKET_TIMEOUT`. Returns `null` if
   * `OBS_WEBSOCKET_URL` is not set. Node-only (browsers have no `process`).
   */
  static async connectFromEnv(
    opts: Omit<ConnectOptions, 'password' | 'timeout'> = {},
  ): Promise<ObsWebSocket | null> {
    const url = process.env.OBS_WEBSOCKET_URL;
    if (!url) return null;
    return ObsWebSocket.connect(url, {
      password: process.env.OBS_WEBSOCKET_PASSWORD,
      timeout: process.env.OBS_WEBSOCKET_TIMEOUT
        ? Number(process.env.OBS_WEBSOCKET_TIMEOUT)
        : undefined,
      ...opts,
    });
  }
}
