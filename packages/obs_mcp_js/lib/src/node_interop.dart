/// Node.js API bindings via dart:js_interop for use in dart2js-compiled code.
///
/// Provides typed access to `process.stdin`, `process.stdout`, `process.env`,
/// and `process.on()`.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// ---------------------------------------------------------------------------
// Process
// ---------------------------------------------------------------------------

@JS('process')
external NodeProcess get process;

extension type NodeProcess(JSObject _) implements JSObject {
  external NodeReadableStream get stdin;
  external NodeWritableStream get stdout;
  external NodeWritableStream get stderr;
  external JSObject get env;
  external void on(String event, JSFunction callback);
  external void exit(int code);
}

// ---------------------------------------------------------------------------
// Streams
// ---------------------------------------------------------------------------

extension type NodeReadableStream(JSObject _) implements JSObject {
  external void on(String event, JSFunction callback);
  external void setEncoding(String? encoding);
  external void resume();
}

extension type NodeWritableStream(JSObject _) implements JSObject {
  external bool write(JSAny data);
}

// ---------------------------------------------------------------------------
// Buffer
// ---------------------------------------------------------------------------

@JS('Buffer')
extension type NodeBuffer(JSObject _) implements JSObject {
  external int get length;
  external String toString2([String encoding, int start, int end]);
  external static NodeBuffer from(JSAny data, [String encoding]);
  external static NodeBuffer alloc(int size);
  external int copy(
    NodeBuffer target, [
    int targetStart,
    int sourceStart,
    int sourceEnd,
  ]);
  external static NodeBuffer concat(
    JSArray<NodeBuffer> list, [
    int totalLength,
  ]);
}

// ---------------------------------------------------------------------------
// Console
// ---------------------------------------------------------------------------

@JS('console')
external NodeConsole get console;

extension type NodeConsole(JSObject _) implements JSObject {
  external void error(JSAny? message);
  external void log(JSAny? message);
}

// ---------------------------------------------------------------------------
// Environment variable access
// ---------------------------------------------------------------------------

/// Reads an environment variable from `process.env`.
/// Returns null if the variable is not set.
String? getEnvVar(String key) {
  final env = process.env;
  final value = _getProperty(env, key.toJS);
  if (value == null || value.isUndefined) return null;
  final str = (value as JSString).toDart;
  return str.isEmpty ? null : str;
}

/// Gets a property from a JSObject by string key.
JSAny? _getProperty(JSObject obj, JSString key) {
  return obj[key.toDart];
}

// ---------------------------------------------------------------------------
// Logging
// ---------------------------------------------------------------------------

/// Logs a message to stderr (equivalent to console.error).
void logError(String message) {
  console.error(message.toJS);
}

// ---------------------------------------------------------------------------
// Helpers for JSObject property access
// ---------------------------------------------------------------------------

extension JSObjectPropertyAccess on JSObject {
  JSAny? getProperty(JSString key) => this[key.toDart];
  void setProperty(JSString key, JSAny? value) {
    this[key.toDart] = value;
  }
}
