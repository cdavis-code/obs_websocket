/**
 * obs_websocket_js — public TypeScript API.
 *
 * This facade wraps the dart2js-compiled `obs_websocket` core, exposing an
 * idiomatic JavaScript API: Promise-based methods, EventEmitter-style event
 * subscription, and typed sub-APIs (scenes, sceneItems, inputs, stream, ...).
 */

import { EventEmitter } from 'eventemitter3';
import type { DartRuntimeLoader } from './runtime.js';
import { getRuntime } from './runtime.js';
import {
  ScenesApi,
  SceneItemsApi,
  InputsApi,
  StreamApi,
  RecordApi,
  GeneralApi,
} from './apis.js';
import type {
  BatchRequest,
  ConnectOptions,
  ObsEvent,
  ObsJsHandle,
  RequestBatchResponse,
  RequestResponse,
} from './types.js';

export * from './types.js';
export { ScenesApi, SceneItemsApi, InputsApi, StreamApi, RecordApi, GeneralApi };

export class ObsWebSocket extends EventEmitter {
  readonly scenes: ScenesApi;
  readonly sceneItems: SceneItemsApi;
  readonly inputs: InputsApi;
  readonly stream: StreamApi;
  readonly record: RecordApi;
  readonly general: GeneralApi;

  protected constructor(private readonly handle: ObsJsHandle) {
    super();
    this.scenes = new ScenesApi(handle);
    this.sceneItems = new SceneItemsApi(handle);
    this.inputs = new InputsApi(handle);
    this.stream = new StreamApi(handle);
    this.record = new RecordApi(handle);
    this.general = new GeneralApi(handle);

    // Forward every Dart event through the EventEmitter.
    handle.onAny((event: ObsEvent) => {
      this.emit(event.eventType, event);
      this.emit('*', event);
    });
  }

  static async connect(
    url: string,
    opts: ConnectOptions = {},
    loader?: DartRuntimeLoader,
  ): Promise<ObsWebSocket> {
    if (!loader) {
      throw new Error(
        'No Dart runtime loader provided. Import from ' +
          "'obs_websocket_js/browser' or 'obs_websocket_js/node' instead.",
      );
    }
    const ns = await getRuntime(loader);
    const handle = await ns.connect(
      url,
      opts.password,
      opts.timeout ?? 120,
      opts.logLevel,
    );
    return new ObsWebSocket(handle);
  }

  /** Raw OBS request. Prefer the typed sub-APIs for common operations. */
  send<T = Record<string, any>>(
    command: string,
    args?: Record<string, any>,
  ): Promise<RequestResponse<T> | null> {
    return this.handle.send(command, args) as Promise<
      RequestResponse<T> | null
    >;
  }

  /** Batched request group. */
  sendBatch(requests: BatchRequest[]): Promise<RequestBatchResponse> {
    return this.handle.sendBatch(requests);
  }

  /** Subscribe to an additional OBS event category bitmask. */
  subscribe(mask: number): Promise<void> {
    return this.handle.subscribe(mask);
  }

  /** Negotiated RPC version as returned by OBS during identify. */
  get negotiatedRpcVersion(): number {
    return this.handle.negotiatedRpcVersion;
  }

  /** Close the underlying WebSocket. */
  async disconnect(): Promise<void> {
    await this.handle.close();
    this.removeAllListeners();
  }
}
