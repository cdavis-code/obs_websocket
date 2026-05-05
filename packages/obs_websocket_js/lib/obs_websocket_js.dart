/// dart2js entry point for the obs_websocket_js npm package.
///
/// When this module is loaded in a JavaScript environment, `main()` installs
/// a `globalThis.ObsWebSocketJs` namespace with a minimal, interop-friendly
/// surface (connect, send, sendBatch, on, off, close). The rich, typed API
/// is layered on top in TypeScript (see `src/index.ts`).
library;

import 'package:obs_websocket_js/src/js_bindings.dart' as bindings;

void main() {
  bindings.install();
}
