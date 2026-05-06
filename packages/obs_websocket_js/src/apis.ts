/**
 * Typed sub-API classes covering 100% of OBS WebSocket v5.7.0 requests.
 * Each class mirrors the Dart `request.*` classes.
 */

import type { ObsJsHandle, RequestResponse } from './types.js';

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

// ── Canvases ──────────────────────────────────────────────────────────────

export class CanvasesApi extends BaseApi {
  async getCanvasList(): Promise<{ canvases: any[] }> {
    return this.call('GetCanvasList');
  }
}

// ── Config ────────────────────────────────────────────────────────────────

export class ConfigApi extends BaseApi {
  async getPersistentData(realm: string, slotName: string): Promise<any> {
    const res = await this.call('GetPersistentData', { realm, slotName });
    return res.slotValue;
  }

  async setPersistentData(
    realm: string,
    slotName: string,
    slotValue: any,
  ): Promise<void> {
    await this.call('SetPersistentData', { realm, slotName, slotValue });
  }

  async getSceneCollectionList(): Promise<{
    currentSceneCollectionName: string;
    sceneCollections: string[];
  }> {
    return this.call('GetSceneCollectionList');
  }

  async setCurrentSceneCollection(name: string): Promise<void> {
    await this.call('SetCurrentSceneCollection', { sceneCollectionName: name });
  }

  async createSceneCollection(name: string): Promise<void> {
    await this.call('CreateSceneCollection', { sceneCollectionName: name });
  }

  async getProfileList(): Promise<{
    currentProfileName: string;
    profiles: string[];
  }> {
    return this.call('GetProfileList');
  }

  async setCurrentProfile(name: string): Promise<void> {
    await this.call('SetCurrentProfile', { profileName: name });
  }

  async createProfile(name: string): Promise<void> {
    await this.call('CreateProfile', { profileName: name });
  }

  async removeProfile(name: string): Promise<void> {
    await this.call('RemoveProfile', { profileName: name });
  }

  async getProfileParameter(
    parameterCategory: string,
    parameterName: string,
  ): Promise<{ parameterValue: string; fieldIsEditable?: boolean }> {
    return this.call('GetProfileParameter', {
      parameterCategory,
      parameterName,
    });
  }

  async setProfileParameter(
    parameterCategory: string,
    parameterName: string,
    parameterValue: string,
  ): Promise<void> {
    await this.call('SetProfileParameter', {
      parameterCategory,
      parameterName,
      parameterValue,
    });
  }

  async getVideoSettings(): Promise<{
    baseWidth: number;
    baseHeight: number;
    outputWidth: number;
    outputHeight: number;
    fpsNumerator: number;
    fpsDenominator: number;
  }> {
    return this.call('GetVideoSettings');
  }

  async setVideoSettings(settings: {
    baseWidth?: number;
    baseHeight?: number;
    outputWidth?: number;
    outputHeight?: number;
    fpsNumerator?: number;
    fpsDenominator?: number;
  }): Promise<void> {
    await this.call('SetVideoSettings', settings);
  }

  async getStreamServiceSettings(): Promise<{
    streamServiceType: string;
    streamServiceSettings: Record<string, any>;
  }> {
    return this.call('GetStreamServiceSettings');
  }

  async setStreamServiceSettings(type: string, settings: Record<string, any>): Promise<void> {
    await this.call('SetStreamServiceSettings', {
      streamServiceType: type,
      streamServiceSettings: settings,
    });
  }

  async getRecordDirectory(): Promise<{ recordDirectory: string }> {
    return this.call('GetRecordDirectory');
  }

  async setRecordDirectory(directory: string): Promise<void> {
    await this.call('SetRecordDirectory', { recordDirectory: directory });
  }
}

// ── Filters ───────────────────────────────────────────────────────────────

export class FiltersApi extends BaseApi {
  async getSourceFilterList(sourceName: string): Promise<{ filters: any[] }> {
    return this.call('GetSourceFilterList', { sourceName });
  }

  async getSourceFilter(
    sourceName: string,
    filterName: string,
  ): Promise<{ filterEnabled: boolean; filterIndex: number; filterKind: string; filterSettings: Record<string, any> }> {
    return this.call('GetSourceFilter', { sourceName, filterName });
  }

  async getSourceFilterKindList(): Promise<{ sourceFilterKinds: string[] }> {
    return this.call('GetSourceFilterKindList');
  }

  async getSourceFilterDefaultSettings(filterKind: string): Promise<{ defaultFilterSettings: Record<string, any> }> {
    return this.call('GetSourceFilterDefaultSettings', { filterKind });
  }

  async createSourceFilter(params: {
    sourceName: string;
    filterName: string;
    filterKind: string;
    filterSettings?: Record<string, any>;
  }): Promise<void> {
    await this.call('CreateSourceFilter', params);
  }

  async removeSourceFilter(sourceName: string, filterName: string): Promise<void> {
    await this.call('RemoveSourceFilter', { sourceName, filterName });
  }

  async setSourceFilterName(
    sourceName: string,
    filterName: string,
    newFilterName: string,
  ): Promise<void> {
    await this.call('SetSourceFilterName', { sourceName, filterName, newFilterName });
  }

  async setSourceFilterIndex(
    sourceName: string,
    filterName: string,
    filterIndex: number,
  ): Promise<void> {
    await this.call('SetSourceFilterIndex', { sourceName, filterName, filterIndex });
  }

  async setSourceFilterEnabled(
    sourceName: string,
    filterName: string,
    filterEnabled: boolean,
  ): Promise<void> {
    await this.call('SetSourceFilterEnabled', { sourceName, filterName, filterEnabled });
  }

  async setSourceFilterSettings(
    sourceName: string,
    filterName: string,
    filterSettings: Record<string, any>,
    overlay?: boolean,
  ): Promise<void> {
    await this.call('SetSourceFilterSettings', {
      sourceName,
      filterName,
      filterSettings,
      overlay,
    });
  }
}

// ── General ───────────────────────────────────────────────────────────────

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

  async callVendorRequest(params: {
    vendorName: string;
    requestType: string;
    requestData?: Record<string, any>;
  }): Promise<{ vendorName: string; requestType: string; responseData: Record<string, any> }> {
    return this.call('CallVendorRequest', params);
  }

  async getHotkeyList(): Promise<{ hotkeys: string[] }> {
    return this.call('GetHotkeyList');
  }

  async triggerHotkeyByName(hotkeyName: string): Promise<void> {
    await this.call('TriggerHotkeyByName', { hotkeyName });
  }

  async triggerHotkeyByKeySequence(params: {
    keyId?: string;
    keyModifiers?: Record<string, boolean>;
  }): Promise<void> {
    await this.call('TriggerHotkeyByKeySequence', params);
  }

  async sleep(params?: { sleepMillis?: number; sleepFrames?: number }): Promise<void> {
    await this.call('Sleep', params);
  }
}

// ── Inputs ────────────────────────────────────────────────────────────────

export class InputsApi extends BaseApi {
  async getInputList(inputKind?: string): Promise<{ inputs: { inputName: string; inputKind: string; unversionedInputKind: string }[] }> {
    return this.call('GetInputList', inputKind ? { inputKind } : undefined);
  }

  async getInputKindList(unversioned = false): Promise<{ inputKinds: string[] }> {
    return this.call('GetInputKindList', { unversioned });
  }

  async getSpecialInputs(): Promise<{
    desktopAudioDevice1?: string;
    desktopAudioDevice2?: string;
    aux1AudioDevice?: string;
    aux2AudioDevice?: string;
    monitorAudioDevice?: string;
  }> {
    return this.call('GetSpecialInputs');
  }

  async createInput(params: {
    sceneName?: string;
    sceneUuid?: string;
    inputName: string;
    inputKind: string;
    inputSettings?: Record<string, any>;
    sceneItemEnabled?: boolean;
  }): Promise<{ sceneItemId: number }> {
    return this.call('CreateInput', params);
  }

  async removeInput(inputName?: string, inputUuid?: string): Promise<void> {
    await this.call('RemoveInput', { inputName, inputUuid });
  }

  async setInputName(
    inputName: string | undefined,
    newInputName: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputName', { inputName, inputUuid, newInputName });
  }

  async getInputDefaultSettings(inputKind: string): Promise<{ defaultInputSettings: Record<string, any> }> {
    return this.call('GetInputDefaultSettings', { inputKind });
  }

  async getInputSettings(inputName?: string, inputUuid?: string): Promise<{ inputSettings: Record<string, any>; inputKind: string }> {
    return this.call('GetInputSettings', { inputName, inputUuid });
  }

  async setInputSettings(
    inputSettings: Record<string, any>,
    inputName?: string,
    inputUuid?: string,
    overlay?: boolean,
  ): Promise<void> {
    await this.call('SetInputSettings', { inputName, inputUuid, inputSettings, overlay });
  }

  async getInputMute(inputName: string): Promise<{ inputMuted: boolean }> {
    return this.call('GetInputMute', { inputName });
  }

  async setInputMute(
    inputMuted: boolean,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputMute', { inputName, inputUuid, inputMuted });
  }

  async toggleInputMute(inputName?: string, inputUuid?: string): Promise<{ inputMuted: boolean }> {
    return this.call('ToggleInputMute', { inputName, inputUuid });
  }

  async getInputVolume(inputName?: string, inputUuid?: string): Promise<{ inputVolumeMul: number; inputVolumeDb: number }> {
    return this.call('GetInputVolume', { inputName, inputUuid });
  }

  async setInputVolume(
    inputVolume: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputVolume', { inputName, inputUuid, inputVolume });
  }

  async getInputDeinterlaceMode(inputName?: string, inputUuid?: string): Promise<{ deinterlaceMode: string }> {
    return this.call('GetInputDeinterlaceMode', { inputName, inputUuid });
  }

  async setInputDeinterlaceMode(
    deinterlaceMode: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputDeinterlaceMode', { inputName, inputUuid, deinterlaceMode });
  }

  async getInputDeinterlaceFieldOrder(inputName?: string, inputUuid?: string): Promise<{ deinterlaceFieldOrder: string }> {
    return this.call('GetInputDeinterlaceFieldOrder', { inputName, inputUuid });
  }

  async setInputDeinterlaceFieldOrder(
    deinterlaceFieldOrder: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputDeinterlaceFieldOrder', { inputName, inputUuid, deinterlaceFieldOrder });
  }

  async getInputAudioBalance(inputName?: string, inputUuid?: string): Promise<{ inputAudioBalance: number }> {
    return this.call('GetInputAudioBalance', { inputName, inputUuid });
  }

  async setInputAudioBalance(
    inputAudioBalance: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputAudioBalance', { inputName, inputUuid, inputAudioBalance });
  }

  async getInputAudioSyncOffset(inputName?: string, inputUuid?: string): Promise<{ inputAudioSyncOffset: number }> {
    return this.call('GetInputAudioSyncOffset', { inputName, inputUuid });
  }

  async setInputAudioSyncOffset(
    inputAudioSyncOffset: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputAudioSyncOffset', { inputName, inputUuid, inputAudioSyncOffset });
  }

  async getInputAudioMonitorType(inputName?: string, inputUuid?: string): Promise<{ monitorType: string }> {
    return this.call('GetInputAudioMonitorType', { inputName, inputUuid });
  }

  async setInputAudioMonitorType(
    monitorType: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputAudioMonitorType', { inputName, inputUuid, monitorType });
  }

  async getInputAudioTracks(inputName?: string, inputUuid?: string): Promise<{ inputAudioTracks: number }> {
    return this.call('GetInputAudioTracks', { inputName, inputUuid });
  }

  async setInputAudioTracks(
    inputAudioTracks: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetInputAudioTracks', { inputName, inputUuid, inputAudioTracks });
  }

  async getInputPropertiesListPropertyItems(
    propertyName: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<{ propertyItems: any[] }> {
    return this.call('GetInputPropertiesListPropertyItems', { inputName, inputUuid, propertyName });
  }

  async pressInputPropertiesButton(
    propertyName: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('PressInputPropertiesButton', { inputName, inputUuid, propertyName });
  }
}

// ── Media Inputs ──────────────────────────────────────────────────────────

export class MediaInputsApi extends BaseApi {
  async getMediaInputStatus(inputName?: string, inputUuid?: string): Promise<{
    mediaState: string;
    mediaDuration: number;
    mediaCursor: number;
    loopMode: boolean;
  }> {
    return this.call('GetMediaInputStatus', { inputName, inputUuid });
  }

  async setMediaInputCursor(
    mediaCursor: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('SetMediaInputCursor', { inputName, inputUuid, mediaCursor });
  }

  async offsetMediaInputCursor(
    mediaCursorOffset: number,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('OffsetMediaInputCursor', { inputName, inputUuid, mediaCursorOffset });
  }

  async triggerMediaInputAction(
    mediaAction: string,
    inputName?: string,
    inputUuid?: string,
  ): Promise<void> {
    await this.call('TriggerMediaInputAction', { inputName, inputUuid, mediaAction });
  }
}

// ── Outputs ───────────────────────────────────────────────────────────────

export class OutputsApi extends BaseApi {
  async getVirtualCamStatus(): Promise<{ outputActive: boolean }> {
    return this.call('GetVirtualCamStatus');
  }

  async toggleVirtualCam(): Promise<{ outputActive: boolean }> {
    return this.call('ToggleVirtualCam');
  }

  async startVirtualCam(): Promise<void> {
    await this.call('StartVirtualCam');
  }

  async stopVirtualCam(): Promise<void> {
    await this.call('StopVirtualCam');
  }

  async getReplayBufferStatus(): Promise<{ outputActive: boolean }> {
    return this.call('GetReplayBufferStatus');
  }

  async toggleReplayBuffer(): Promise<{ outputActive: boolean }> {
    return this.call('ToggleReplayBuffer');
  }

  async startReplayBuffer(): Promise<void> {
    await this.call('StartReplayBuffer');
  }

  async stopReplayBuffer(): Promise<void> {
    await this.call('StopReplayBuffer');
  }

  async saveReplayBuffer(): Promise<void> {
    await this.call('SaveReplayBuffer');
  }

  async getOutputList(): Promise<{ outputs: any[] }> {
    return this.call('GetOutputList');
  }

  async getOutputStatus(outputName: string): Promise<Record<string, any>> {
    return this.call('GetOutputStatus', { outputName });
  }

  async toggleOutput(outputName: string): Promise<{ outputActive: boolean }> {
    return this.call('ToggleOutput', { outputName });
  }

  async startOutput(outputName: string): Promise<void> {
    await this.call('StartOutput', { outputName });
  }

  async stopOutput(outputName: string): Promise<void> {
    await this.call('StopOutput', { outputName });
  }

  async getOutputSettings(outputName: string): Promise<{ outputSettings: Record<string, any> }> {
    return this.call('GetOutputSettings', { outputName });
  }

  async setOutputSettings(
    outputName: string,
    outputSettings: Record<string, any>,
  ): Promise<void> {
    await this.call('SetOutputSettings', { outputName, outputSettings });
  }
}

// ── Record ────────────────────────────────────────────────────────────────

export class RecordApi extends BaseApi {
  async getRecordStatus(): Promise<{
    outputActive: boolean;
    outputPaused: boolean;
    outputTimecode: string;
    outputDuration: number;
    outputBytes: number;
  }> {
    return this.call('GetRecordStatus');
  }

  async toggleRecord(): Promise<void> {
    await this.call('ToggleRecord');
  }

  async startRecord(): Promise<void> {
    await this.call('StartRecord');
  }

  async stopRecord(): Promise<{ outputPath: string }> {
    return this.call('StopRecord');
  }

  async pauseRecord(): Promise<void> {
    await this.call('PauseRecord');
  }

  async resumeRecord(): Promise<void> {
    await this.call('ResumeRecord');
  }

  async toggleRecordPause(): Promise<void> {
    await this.call('ToggleRecordPause');
  }

  async splitRecordFile(): Promise<void> {
    await this.call('SplitRecordFile');
  }

  async createRecordChapter(chapterName?: string): Promise<void> {
    await this.call('CreateRecordChapter', chapterName ? { chapterName } : undefined);
  }
}

// ── Scenes ────────────────────────────────────────────────────────────────

export class ScenesApi extends BaseApi {
  async getSceneList(): Promise<{
    currentProgramSceneName: string;
    scenes: { sceneName: string; sceneIndex: number }[];
  }> {
    return this.call('GetSceneList');
  }

  async getGroupList(): Promise<{ groups: string[] }> {
    return this.call('GetGroupList');
  }

  async getCurrentProgramScene(): Promise<{ currentProgramSceneName: string }> {
    return this.call('GetCurrentProgramScene');
  }

  async setCurrentProgramScene(sceneName: string): Promise<void> {
    await this.call('SetCurrentProgramScene', { sceneName });
  }

  async getCurrentPreviewScene(): Promise<{ currentPreviewSceneName: string }> {
    return this.call('GetCurrentPreviewScene');
  }

  async setCurrentPreviewScene(sceneName: string): Promise<void> {
    await this.call('SetCurrentPreviewScene', { sceneName });
  }

  async createScene(sceneName: string): Promise<void> {
    await this.call('CreateScene', { sceneName });
  }

  async removeScene(sceneName: string): Promise<void> {
    await this.call('RemoveScene', { sceneName });
  }

  async setSceneName(sceneName: string, newSceneName: string): Promise<void> {
    await this.call('SetSceneName', { sceneName, newSceneName });
  }

  async getSceneSceneTransitionOverride(sceneName: string): Promise<{
    transitionName?: string;
    transitionDuration?: number;
  }> {
    return this.call('GetSceneSceneTransitionOverride', { sceneName });
  }

  async setSceneSceneTransitionOverride(
    sceneName: string,
    params?: { transitionName?: string; transitionDuration?: number },
  ): Promise<void> {
    await this.call('SetSceneSceneTransitionOverride', { sceneName, ...params });
  }
}

// ── Scene Items ───────────────────────────────────────────────────────────

export class SceneItemsApi extends BaseApi {
  async getSceneItemList(sceneName: string): Promise<{ sceneItems: any[] }> {
    return this.call('GetSceneItemList', { sceneName });
  }

  async getGroupSceneItemList(sceneName: string): Promise<{ sceneItems: any[] }> {
    return this.call('GetGroupSceneItemList', { sceneName });
  }

  async getSceneItemId(params: {
    sceneName: string;
    sourceName: string;
    searchOffset?: number;
  }): Promise<{ sceneItemId: number }> {
    return this.call('GetSceneItemId', params);
  }

  async getSceneItemEnabled(
    sceneName: string,
    sceneItemId: number,
  ): Promise<{ sceneItemEnabled: boolean }> {
    return this.call('GetSceneItemEnabled', { sceneName, sceneItemId });
  }

  async setSceneItemEnabled(
    sceneName: string,
    sceneItemId: number,
    sceneItemEnabled: boolean,
  ): Promise<void> {
    await this.call('SetSceneItemEnabled', { sceneName, sceneItemId, sceneItemEnabled });
  }

  async getSceneItemLocked(
    sceneName: string,
    sceneItemId: number,
  ): Promise<{ sceneItemLocked: boolean }> {
    return this.call('GetSceneItemLocked', { sceneName, sceneItemId });
  }

  async setSceneItemLocked(
    sceneName: string,
    sceneItemId: number,
    sceneItemLocked: boolean,
  ): Promise<void> {
    await this.call('SetSceneItemLocked', { sceneName, sceneItemId, sceneItemLocked });
  }

  async getSceneItemIndex(
    sceneName: string,
    sceneItemId: number,
  ): Promise<{ sceneItemIndex: number }> {
    return this.call('GetSceneItemIndex', { sceneName, sceneItemId });
  }

  async setSceneItemIndex(
    sceneName: string,
    sceneItemId: number,
    sceneItemIndex: number,
  ): Promise<void> {
    await this.call('SetSceneItemIndex', { sceneName, sceneItemId, sceneItemIndex });
  }

  async getSceneItemTransform(
    sceneName: string,
    sceneItemId: number,
  ): Promise<{ sceneItemTransform: Record<string, any> }> {
    return this.call('GetSceneItemTransform', { sceneName, sceneItemId });
  }

  async setSceneItemTransform(
    sceneName: string,
    sceneItemId: number,
    sceneItemTransform: Record<string, any>,
  ): Promise<void> {
    await this.call('SetSceneItemTransform', { sceneName, sceneItemId, sceneItemTransform });
  }

  async createSceneItem(params: {
    sceneName: string;
    sourceName: string;
    sceneItemEnabled?: boolean;
  }): Promise<{ sceneItemId: number }> {
    return this.call('CreateSceneItem', params);
  }

  async removeSceneItem(sceneName: string, sceneItemId: number): Promise<void> {
    await this.call('RemoveSceneItem', { sceneName, sceneItemId });
  }

  async duplicateSceneItem(params: {
    sceneName: string;
    sceneItemId: number;
    destinationSceneName?: string;
  }): Promise<{ sceneItemId: number }> {
    return this.call('DuplicateSceneItem', params);
  }

  async getSceneItemBlendMode(
    sceneName: string,
    sceneItemId: number,
  ): Promise<{ sceneItemBlendMode: string }> {
    return this.call('GetSceneItemBlendMode', { sceneName, sceneItemId });
  }

  async setSceneItemBlendMode(
    sceneName: string,
    sceneItemId: number,
    sceneItemBlendMode: string,
  ): Promise<void> {
    await this.call('SetSceneItemBlendMode', { sceneName, sceneItemId, sceneItemBlendMode });
  }

  async getSceneItemSource(params: {
    sceneName?: string;
    sceneUuid?: string;
    sceneItemId: number;
  }): Promise<Record<string, any>> {
    return this.call('GetSceneItemSource', params);
  }

  async getSceneItemPrivateSettings(params: {
    sceneName?: string;
    sceneUuid?: string;
    sceneItemId: number;
  }): Promise<Record<string, any>> {
    return this.call('GetSceneItemPrivateSettings', params);
  }

  async setSceneItemPrivateSettings(params: {
    sceneName?: string;
    sceneUuid?: string;
    sceneItemId: number;
    sceneItemSettings: Record<string, any>;
  }): Promise<void> {
    await this.call('SetSceneItemPrivateSettings', params);
  }
}

// ── Sources ───────────────────────────────────────────────────────────────

export class SourcesApi extends BaseApi {
  async getSourceActive(sourceName: string): Promise<{
    videoShowing: boolean;
  }> {
    return this.call('GetSourceActive', { sourceName });
  }

  async getSourceScreenshot(params: {
    sourceName: string;
    imageFormat: string;
    imageWidth?: number;
    imageHeight?: number;
    imageCompressionQuality?: number;
  }): Promise<{ imageData: string }> {
    return this.call('GetSourceScreenshot', params);
  }

  async saveSourceScreenshot(params: {
    sourceName: string;
    imageFormat: string;
    imageFilePath: string;
    imageWidth?: number;
    imageHeight?: number;
    imageCompressionQuality?: number;
  }): Promise<void> {
    await this.call('SaveSourceScreenshot', params);
  }

  async getSourcePrivateSettings(params: {
    sourceName?: string;
    sourceUuid?: string;
  }): Promise<Record<string, any>> {
    return this.call('GetSourcePrivateSettings', params);
  }

  async setSourcePrivateSettings(params: {
    sourceName?: string;
    sourceUuid?: string;
    sourceSettings: Record<string, any>;
  }): Promise<void> {
    await this.call('SetSourcePrivateSettings', params);
  }
}

// ── Stream ────────────────────────────────────────────────────────────────

export class StreamApi extends BaseApi {
  async getStreamStatus(): Promise<{
    outputActive: boolean;
    outputReconnecting: boolean;
    outputTimecode: string;
    outputDuration: number;
    outputBytes: number;
  }> {
    return this.call('GetStreamStatus');
  }

  async toggleStream(): Promise<{ outputActive: boolean }> {
    return this.call('ToggleStream');
  }

  async startStream(): Promise<void> {
    await this.call('StartStream');
  }

  async stopStream(): Promise<void> {
    await this.call('StopStream');
  }

  async sendStreamCaption(captionText: string): Promise<void> {
    await this.call('SendStreamCaption', { captionText });
  }
}

// ── Transitions ───────────────────────────────────────────────────────────

export class TransitionsApi extends BaseApi {
  async setCurrentSceneTransition(transitionName: string): Promise<void> {
    await this.call('SetCurrentSceneTransition', { transitionName });
  }

  async setCurrentSceneTransitionDuration(transitionDuration: number): Promise<void> {
    await this.call('SetCurrentSceneTransitionDuration', { transitionDuration });
  }

  async triggerStudioModeTransition(): Promise<void> {
    await this.call('TriggerStudioModeTransition');
  }

  async getTransitionKindList(): Promise<{ transitionKinds: string[] }> {
    return this.call('GetTransitionKindList');
  }

  async getSceneTransitionList(): Promise<{
    currentSceneTransitionName: string;
    transitions: any[];
  }> {
    return this.call('GetSceneTransitionList');
  }

  async getCurrentSceneTransition(): Promise<Record<string, any>> {
    return this.call('GetCurrentSceneTransition');
  }

  async setCurrentSceneTransitionSettings(
    transitionSettings: Record<string, any>,
    overlay?: boolean,
  ): Promise<void> {
    await this.call('SetCurrentSceneTransitionSettings', { transitionSettings, overlay });
  }

  async getCurrentSceneTransitionCursor(): Promise<{ transitionCursor: number }> {
    return this.call('GetCurrentSceneTransitionCursor');
  }

  async setTBarPosition(position: number, release?: boolean): Promise<void> {
    await this.call('SetTBarPosition', { position, release });
  }
}

// ── Ui ────────────────────────────────────────────────────────────────────

export class UiApi extends BaseApi {
  async getStudioModeEnabled(): Promise<{ studioModeEnabled: boolean }> {
    return this.call('GetStudioModeEnabled');
  }

  async setStudioModeEnabled(studioModeEnabled: boolean): Promise<void> {
    await this.call('SetStudioModeEnabled', { studioModeEnabled });
  }

  async openInputPropertiesDialog(inputName: string): Promise<void> {
    await this.call('OpenInputPropertiesDialog', { inputName });
  }

  async openInputFiltersDialog(inputName: string): Promise<void> {
    await this.call('OpenInputFiltersDialog', { inputName });
  }

  async openInputInteractDialog(inputName: string): Promise<void> {
    await this.call('OpenInputInteractDialog', { inputName });
  }

  async getMonitorList(): Promise<{ monitors: any[] }> {
    return this.call('GetMonitorList');
  }

  async openVideoMixProjector(params: {
    videoMixType: string;
    monitorIndex?: number;
    projectorGeometry?: string;
  }): Promise<void> {
    await this.call('OpenVideoMixProjector', params);
  }

  async openSourceProjector(params: {
    sourceName: string;
    monitorIndex?: number;
    projectorGeometry?: string;
  }): Promise<void> {
    await this.call('OpenSourceProjector', params);
  }
}
