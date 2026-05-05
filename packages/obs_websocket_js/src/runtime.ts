/**
 * Loads the dart2js-compiled runtime and returns the `ObsWebSocketJs`
 * namespace installed on `globalThis`. Dispatch is platform-specific — see
 * `browser.ts` and `node.ts` for the actual loader implementations.
 */

import type { ObsJsNamespace } from './types.js';

let cached: ObsJsNamespace | undefined;

export type DartRuntimeLoader = () => Promise<void>;

export async function getRuntime(
  loader: DartRuntimeLoader,
): Promise<ObsJsNamespace> {
  if (cached) return cached;
  await loader();
  const ns = (globalThis as any).ObsWebSocketJs as ObsJsNamespace | undefined;
  if (!ns) {
    throw new Error(
      'obs_websocket_js runtime failed to initialise: ' +
        'globalThis.ObsWebSocketJs was not installed.',
    );
  }
  cached = ns;
  return ns;
}
