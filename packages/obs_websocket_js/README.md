# obs_websocket_js

JavaScript / TypeScript bindings for the [`obs_websocket`](https://pub.dev/packages/obs_websocket) Dart package, compiled via `dart2js`. A universal (browser + Node.js) client for the [OBS Studio obs-websocket v5 plugin](https://github.com/obsproject/obs-websocket).

- Typed `.d.ts` surface (Promise-based API, EventEmitter events)
- Dual entrypoints via `package.json` `exports` conditions: browser uses native `WebSocket`, Node.js polyfills via [`ws`](https://www.npmjs.com/package/ws) (falls back to Node 22+ native `WebSocket` when available)
- Protocol core is shared with the Dart, CLI, and MCP packages — every request parsed and validated by the same codebase

## Install

```bash
npm install obs_websocket_js
```

## Usage (Node.js / TypeScript)

```ts
import { ObsWebSocket, EventSubscription } from 'obs_websocket_js/node';

const obs = await ObsWebSocket.connect('ws://localhost:4455', {
  password: 'your_password',
  logLevel: 'info',
});

const { scenes, currentProgramSceneName } = await obs.scenes.list();
console.log('current scene:', currentProgramSceneName);
console.log('all scenes:', scenes.map((s) => s.sceneName));

await obs.subscribe(EventSubscription.All);

obs.on('SceneCreated', (event) => {
  console.log('new scene:', event.eventData.sceneName);
});

await obs.inputs.setMute('Mic', true);
await obs.disconnect();
```

### Environment-variable convenience (Node only)

```ts
import { ObsWebSocket } from 'obs_websocket_js/node';

// Reads OBS_WEBSOCKET_URL / OBS_WEBSOCKET_PASSWORD / OBS_WEBSOCKET_TIMEOUT.
const obs = await ObsWebSocket.connectFromEnv();
if (!obs) throw new Error('OBS_WEBSOCKET_URL not set');
```

## Usage (Browser)

```ts
import { ObsWebSocket } from 'obs_websocket_js/browser';

const obs = await ObsWebSocket.connect('ws://localhost:4455', {
  password: 'your_password',
});

await obs.scenes.setCurrentProgramScene('Gameplay');
```

## Public API

| Namespace        | Example                                                         |
| ---------------- | --------------------------------------------------------------- |
| `obs.scenes`     | `list()`, `getCurrentProgramScene()`, `setCurrentProgramScene(name)`, `create(name)`, `remove(name)` |
| `obs.sceneItems` | `list(scene)`, `getEnabled(...)`, `setEnabled(...)`, `setTransform(...)` |
| `obs.inputs`     | `list()`, `getMute(n)`, `setMute(n, v)`, `getVolume(n)`, `setVolume(n, v)`, `getSettings(n)`, `setSettings(n, s)` |
| `obs.stream`     | `getStatus()`, `start()`, `stop()`, `toggle()`                   |
| `obs.record`     | `getStatus()`, `start()`, `stop()`, `pause()`, `resume()`        |
| `obs.general`    | `getVersion()`, `getStats()`, `broadcastCustomEvent(data)`       |
| `obs.send(...)`  | Raw request escape hatch: `obs.send('GetVideoSettings')`        |
| `obs.sendBatch(...)` | Batched requests                                             |

Events are forwarded via `EventEmitter3`:

```ts
obs.on('InputMuteStateChanged', (e) => { /* e.eventData */ });
obs.on('*', (e) => console.log(e.eventType));  // catch-all
```

## Building from source

```bash
npm install
npm run build        # runs dart2js + tsup
npm test
```

- `npm run build:dart` invokes `dart compile js -O4` (requires Dart SDK ^3.8.0).
- `npm run build:ts` invokes `tsup`, producing `dist/browser.js`, `dist/node.js`, `dist/node.cjs`, and `.d.ts` files.

## Caveats

1. **Bundle size.** The dart2js runtime ships as a single ES module alongside the TS bundle; expect roughly 150–300 KB gzipped. Tree-shaking is limited — dart2js emits a self-contained runtime.
2. **Logging.** The underlying `loggy` package writes to `console.log`; adjust `logLevel` to silence.
3. **Browser environment variables.** `connectFromEnv()` is Node-only. In the browser, always pass credentials to `connect()`.
4. **Node versions.** Tested on Node 18+. On 22+, the native `globalThis.WebSocket` is used; on 18–21, the `ws` package is loaded dynamically.

## Relation to the Dart package

All protocol logic lives in [`packages/obs_websocket/`](../obs_websocket/). This package is a thin JS/TS shim over the exact same code. Feature parity is guaranteed — if a request exists in the Dart package, it works here via `obs.send(name, args)`, and the typed helpers in the sub-API classes cover the commonly-used requests.

## License

MIT. See [LICENSE](./LICENSE).
