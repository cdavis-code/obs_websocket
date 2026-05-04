import 'dart:convert';

import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  test('GetVersion', () async {
    final response = json.decode(
      '{"d":{"requestId":"0802f387-6212-468e-be5f-5b3ae2675cfd","requestStatus":{"code":100,"result":true},"requestType":"GetVersion","responseData":{"availableRequests":["GetMonitorList","OpenInputInteractDialog","SetMediaInputCursor","ToggleRecordPause","StopRecord","ToggleRecord","GetRecordStatus","SendStreamCaption","TriggerMediaInputAction","StopStream","StartStream","SetOutputSettings","GetOutputSettings","StartOutput","ToggleOutput","SaveReplayBuffer","StopReplayBuffer","StartReplayBuffer","StopVirtualCam","StartVirtualCam","SetSceneItemPrivateSettings","GetStudioModeEnabled","GetSceneItemPrivateSettings","SetSceneItemBlendMode","GetSourceFilterDefaultSettings","SetSceneItemLocked","GetLastReplayBufferReplay","GetSceneItemBlendMode","GetSceneItemTransform","GetGroupSceneItemList","GetSceneItemId","ToggleVirtualCam","GetSceneItemList","GetInputList","GetVideoSettings","DuplicateSceneItem","GetSourcePrivateSettings","GetSourceScreenshot","SetSourceFilterIndex","RemoveScene","GetSceneItemIndex","SetTBarPosition","GetSourceFilter","OpenInputFiltersDialog","SetSourceFilterName","RemoveSourceFilter","GetSourceFilterList","GetMediaInputStatus","TriggerStudioModeTransition","GetCurrentSceneTransitionCursor","SetCurrentSceneTransitionDuration","OffsetMediaInputCursor","GetVirtualCamStatus","CreateSourceFilter","SetCurrentSceneTransition","GetTransitionKindList","SetSceneItemEnabled","SetSceneItemIndex","SetInputAudioTracks","GetInputVolume","GetInputAudioTracks","SetCurrentProgramScene","SetInputAudioMonitorType","SetInputAudioSyncOffset","SetInputAudioBalance","GetCurrentSceneTransition","SetInputSettings","SetSourceFilterEnabled","GetInputSettings","OpenSourceProjector","SetSceneItemTransform","GetInputAudioBalance","BroadcastCustomEvent","GetPersistentData","SetInputName","GetInputKindList","CreateSceneCollection","GetOutputStatus","GetSceneSceneTransitionOverride","SetInputMute","SetCurrentSceneTransitionSettings","GetSceneTransitionList","PauseRecord","SetSceneSceneTransitionOverride","OpenVideoMixProjector","SetCurrentPreviewScene","SetSceneName","CreateScene","GetInputAudioSyncOffset","GetStreamStatus","GetGroupList","GetOutputList","GetSceneList","CreateSceneItem","GetInputMute","GetCurrentProgramScene","SetSourceFilterSettings","CallVendorRequest","SetStreamServiceSettings","SaveSourceScreenshot","GetRecordDirectory","GetInputDefaultSettings","GetStreamServiceSettings","CreateProfile","RemoveProfile","ResumeRecord","GetInputAudioMonitorType","RemoveInput","OpenInputPropertiesDialog","ToggleReplayBuffer","GetHotkeyList","SetCurrentSceneCollection","GetSceneItemLocked","GetSceneCollectionList","GetProfileList","ToggleInputMute","TriggerHotkeyByKeySequence","CreateInput","GetCurrentPreviewScene","TriggerHotkeyByName","SetStudioModeEnabled","GetSourceActive","SetVideoSettings","PressInputPropertiesButton","SetProfileParameter","SetInputVolume","ToggleStream","SetSourcePrivateSettings","Sleep","StartRecord","GetReplayBufferStatus","SetPersistentData","GetProfileParameter","GetInputPropertiesListPropertyItems","GetSpecialInputs","GetStats","RemoveSceneItem","StopOutput","SetCurrentProfile","GetVersion","GetSceneItemEnabled"],"obsVersion":"27.2.4","obsWebSocketVersion":"5.0.1","platform":"osx","platformDescription":"macOS 12.5","rpcVersion":1,"supportedImageFormats":["bmp","cur","heic","heif","icns","ico","jp2","jpeg","jpg","pbm","pgm","png","ppm","tif","tiff","wbmp","webp","xbm","xpm"]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final result = requestResponse.responseData!;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetVersion');
    expect(requestResponse.requestStatus.code, 100);
    expect(result['obsVersion'], '27.2.4');
  });

  test('GetStats', () async {
    final response = json.decode(
      '{"d":{"requestId":"5c536f30-f800-4b72-bf05-d88f003c4697","requestStatus":{"code":100,"result":true},"requestType":"GetStats","responseData":{"activeFps":23.976024167640556,"availableDiskSpace":19014.4609375,"averageFrameRenderTime":0.495866,"cpuUsage":-0.027235297172177826,"memoryUsage":495.81640625,"outputSkippedFrames":0,"outputTotalFrames":1324,"renderSkippedFrames":1351,"renderTotalFrames":5383930,"webSocketSessionIncomingMessages":4,"webSocketSessionOutgoingMessages":4}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final statsResponse = StatsResponse.fromJson(requestResponse.responseData!);

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetStats');
    expect(requestResponse.requestStatus.code, 100);
    expect(statsResponse.runtimeType, StatsResponse);
  });

  test('CallVendorRequest', () async {
    final response = json.decode(
      '{"d":{"requestId":"e10b6d8c-bc51-4d20-8073-028b51cca459","requestStatus":{"code":100,"result":true},"requestType":"CallVendorRequest","responseData":{"requestType":"emit_event","responseData":{},"vendorName":"obs-browser"}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final callVendorRequestResponse = CallVendorRequestResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'CallVendorRequest');
    expect(requestResponse.requestStatus.code, 100);
    expect(callVendorRequestResponse.vendorName, 'obs-browser');
  });

  test('ObsBrowserEvent', () async {
    final response = json.decode(
      '{"d":{"requestId":"728101a8-cdfd-4960-93ae-638835a55979","requestStatus":{"code":100,"result":true},"requestType":"CallVendorRequest","responseData":{"requestType":"emit_event","responseData":{},"vendorName":"obs-browser"}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final callVendorRequestResponse = CallVendorRequestResponse.fromJson(
      requestResponse.responseData!,
    );

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'CallVendorRequest');
    expect(requestResponse.requestStatus.code, 100);
    expect(callVendorRequestResponse.vendorName, 'obs-browser');
  });

  test('GetHotkeyList', () async {
    final response = json.decode(
      '{"d":{"requestId":"c40e1d11-e8f8-4c70-8c76-2ae6b7ea2cea","requestStatus":{"code":100,"result":true},"requestType":"GetHotkeyList","responseData":{"hotkeys":["RtspOutput.Start","RtspOutput.Stop","PTZ.PanTiltUpLeft","PTZ.PanTiltLeft","PTZ.PanTiltDownLeft","PTZ.PanTiltUpRight","PTZ.PanTiltRight","PTZ.PanTiltDownRight","PTZ.PanTiltUp","PTZ.PanTiltDown","PTZ.ZoomWide","PTZ.ZoomTele","PTZ.FocusAutoFocus","PTZ.FocusNear","PTZ.FocusFar","PTZ.FocusOneTouch","PTZ.Recall1","PTZ.Recall2","PTZ.Recall3","PTZ.Recall4","PTZ.Recall5","PTZ.Recall6","PTZ.Recall7","PTZ.Recall8","PTZ.Recall9","PTZ.Recall10","PTZ.Recall11","PTZ.Recall12","PTZ.Recall13","PTZ.Recall14","PTZ.Recall15","PTZ.Recall16","OBSBasic.StartStreaming","OBSBasic.StopStreaming","OBSBasic.ForceStopStreaming","OBSBasic.StartRecording","OBSBasic.StopRecording","OBSBasic.PauseRecording","OBSBasic.UnpauseRecording","OBSBasic.StartReplayBuffer","OBSBasic.StopReplayBuffer","OBSBasic.StartVirtualCam","OBSBasic.StopVirtualCam","OBSBasic.EnablePreview","OBSBasic.DisablePreview","OBSBasic.ShowContextBar","OBSBasic.HideContextBar","OBSBasic.TogglePreviewProgram","OBSBasic.Transition","OBSBasic.ResetStats","OBSBasic.Screenshot","OBSBasic.SelectedSourceScreenshot","libobs.mute","libobs.unmute","libobs.push-to-mute","libobs.push-to-talk","ObsBrowser.Refresh","OBSBasic.SelectScene","OBSBasic.SelectScene","libobs.show_scene_item.Group","libobs.hide_scene_item.Group","libobs.show_scene_item.Text (FreeType 2) 2","libobs.hide_scene_item.Text (FreeType 2) 2","libobs.show_scene_item.my face","libobs.hide_scene_item.my face","libobs.show_scene_item.obs-browser","libobs.hide_scene_item.obs-browser","libobs.show_scene_item.Text (FreeType 2)","libobs.hide_scene_item.Text (FreeType 2)","OBSBasic.QuickTransition.3","OBSBasic.QuickTransition.4","OBSBasic.QuickTransition.5"]}},"op":7}',
    );

    final opcode = Opcode.fromJson(response);

    final requestResponse = RequestResponse.fromJson(opcode.d);

    final hotkeys = StringListResponse.fromJson(
      requestResponse.responseData!,
    ).items;

    expect(opcode.op, 7);
    expect(requestResponse.requestType, 'GetHotkeyList');
    expect(requestResponse.requestStatus.code, 100);
    expect(hotkeys.contains('OBSBasic.Screenshot'), true);
  });
}
