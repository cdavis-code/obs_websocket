/**
 * Typed sub-API classes. Each wraps the low-level `send(command, args)` path,
 * mirroring the Dart `request.*` classes so that JS/TS users get the same
 * high-level ergonomics (obs.scenes.list(), obs.inputs.setMute(...), etc.).
 */

import type {
  ObsJsHandle,
  RequestResponse,
  Scene,
  SceneItem,
  Input,
} from './types.js';

abstract class BaseApi {
  constructor(protected readonly handle: ObsJsHandle) {}

  protected async call<T = Record<string, any>>(
    command: string,
    args?: Record<string, any>,
  ): Promise<T> {
    const response = (await this.handle.send(
      command,
      args,
    )) as RequestResponse<T> | null;
    return (response?.responseData ?? {}) as T;
  }
}

export class ScenesApi extends BaseApi {
  async list(): Promise<{ currentProgramSceneName: string; scenes: Scene[] }> {
    return this.call('GetSceneList');
  }

  async getCurrentProgramScene(): Promise<string> {
    const res = await this.call<{ currentProgramSceneName: string }>(
      'GetCurrentProgramScene',
    );
    return res.currentProgramSceneName;
  }

  async setCurrentProgramScene(sceneName: string): Promise<void> {
    await this.call('SetCurrentProgramScene', { sceneName });
  }

  async getCurrentPreviewScene(): Promise<string> {
    const res = await this.call<{ currentPreviewSceneName: string }>(
      'GetCurrentPreviewScene',
    );
    return res.currentPreviewSceneName;
  }

  async setCurrentPreviewScene(sceneName: string): Promise<void> {
    await this.call('SetCurrentPreviewScene', { sceneName });
  }

  async create(sceneName: string): Promise<void> {
    await this.call('CreateScene', { sceneName });
  }

  async remove(sceneName: string): Promise<void> {
    await this.call('RemoveScene', { sceneName });
  }

  async setName(sceneName: string, newSceneName: string): Promise<void> {
    await this.call('SetSceneName', { sceneName, newSceneName });
  }
}

export class SceneItemsApi extends BaseApi {
  async list(sceneName: string): Promise<{ sceneItems: SceneItem[] }> {
    return this.call('GetSceneItemList', { sceneName });
  }

  async getEnabled(
    sceneName: string,
    sceneItemId: number,
  ): Promise<boolean> {
    const res = await this.call<{ sceneItemEnabled: boolean }>(
      'GetSceneItemEnabled',
      { sceneName, sceneItemId },
    );
    return res.sceneItemEnabled;
  }

  async setEnabled(
    sceneName: string,
    sceneItemId: number,
    enabled: boolean,
  ): Promise<void> {
    await this.call('SetSceneItemEnabled', {
      sceneName,
      sceneItemId,
      sceneItemEnabled: enabled,
    });
  }

  async setTransform(
    sceneName: string,
    sceneItemId: number,
    transform: Record<string, any>,
  ): Promise<void> {
    await this.call('SetSceneItemTransform', {
      sceneName,
      sceneItemId,
      sceneItemTransform: transform,
    });
  }
}

export class InputsApi extends BaseApi {
  async list(inputKind?: string): Promise<{ inputs: Input[] }> {
    return this.call('GetInputList', inputKind ? { inputKind } : undefined);
  }

  async getMute(inputName: string): Promise<boolean> {
    const res = await this.call<{ inputMuted: boolean }>('GetInputMute', {
      inputName,
    });
    return res.inputMuted;
  }

  async setMute(inputName: string, muted: boolean): Promise<void> {
    await this.call('SetInputMute', { inputName, inputMuted: muted });
  }

  async getVolume(
    inputName: string,
  ): Promise<{ inputVolumeMul: number; inputVolumeDb: number }> {
    return this.call('GetInputVolume', { inputName });
  }

  async setVolume(
    inputName: string,
    volume: { mul?: number; db?: number },
  ): Promise<void> {
    const args: Record<string, any> = { inputName };
    if (volume.mul !== undefined) args.inputVolumeMul = volume.mul;
    if (volume.db !== undefined) args.inputVolumeDb = volume.db;
    await this.call('SetInputVolume', args);
  }

  async getSettings(
    inputName: string,
  ): Promise<{ inputSettings: Record<string, any>; inputKind: string }> {
    return this.call('GetInputSettings', { inputName });
  }

  async setSettings(
    inputName: string,
    settings: Record<string, any>,
    overlay = true,
  ): Promise<void> {
    await this.call('SetInputSettings', {
      inputName,
      inputSettings: settings,
      overlay,
    });
  }
}

export class StreamApi extends BaseApi {
  async getStatus(): Promise<{
    outputActive: boolean;
    outputReconnecting: boolean;
    outputTimecode: string;
    outputDuration: number;
    outputBytes: number;
  }> {
    return this.call('GetStreamStatus');
  }

  async start(): Promise<void> {
    await this.call('StartStream');
  }

  async stop(): Promise<void> {
    await this.call('StopStream');
  }

  async toggle(): Promise<{ outputActive: boolean }> {
    return this.call('ToggleStream');
  }
}

export class RecordApi extends BaseApi {
  async getStatus(): Promise<{
    outputActive: boolean;
    outputPaused: boolean;
    outputTimecode: string;
    outputDuration: number;
    outputBytes: number;
  }> {
    return this.call('GetRecordStatus');
  }

  async start(): Promise<void> {
    await this.call('StartRecord');
  }

  async stop(): Promise<{ outputPath: string }> {
    return this.call('StopRecord');
  }

  async pause(): Promise<void> {
    await this.call('PauseRecord');
  }

  async resume(): Promise<void> {
    await this.call('ResumeRecord');
  }
}

export class GeneralApi extends BaseApi {
  async getVersion(): Promise<{
    obsVersion: string;
    obsWebSocketVersion: string;
    rpcVersion: number;
    availableRequests: string[];
    supportedImageFormats: string[];
    platform: string;
    platformDescription: string;
  }> {
    return this.call('GetVersion');
  }

  async getStats(): Promise<Record<string, number>> {
    return this.call('GetStats');
  }

  async broadcastCustomEvent(eventData: Record<string, any>): Promise<void> {
    await this.call('BroadcastCustomEvent', { eventData });
  }
}
