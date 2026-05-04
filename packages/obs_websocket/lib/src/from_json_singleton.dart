import 'package:obs_websocket/event.dart';

class FromJsonSingleton {
  static final _singleton = FromJsonSingleton._internal();

  final factories = <String, Function>{
    // config
    'CurrentProfileChanged': (Map<String, dynamic> json) =>
        CurrentProfileChanged.fromJson(json),
    'CurrentProfileChanging': (Map<String, dynamic> json) =>
        CurrentProfileChanging.fromJson(json),
    'CurrentSceneCollectionChanged': (Map<String, dynamic> json) =>
        CurrentSceneCollectionChanged.fromJson(json),
    'CurrentSceneCollectionChanging': (Map<String, dynamic> json) =>
        CurrentSceneCollectionChanging.fromJson(json),
    'ProfileListChanged': (Map<String, dynamic> json) =>
        ProfileListChanged.fromJson(json),
    'SceneCollectionListChanged': (Map<String, dynamic> json) =>
        SceneCollectionListChanged.fromJson(json),

    // general
    'CustomEvent': (Map<String, dynamic> json) => CustomEvent.fromJson(json),
    'ExitStarted': (Map<String, dynamic> json) => ExitStarted.fromJson(json),
    'VendorEvent': (Map<String, dynamic> json) => VendorEvent.fromJson(json),

    // inputs
    'InputActiveStateChanged': (Map<String, dynamic> json) =>
        InputActiveStateChanged.fromJson(json),
    'InputAudioBalanceChanged': (Map<String, dynamic> json) =>
        InputAudioBalanceChanged.fromJson(json),
    'InputAudioMonitorTypeChanged': (Map<String, dynamic> json) =>
        InputAudioMonitorTypeChanged.fromJson(json),
    'InputAudioSyncOffsetChanged': (Map<String, dynamic> json) =>
        InputAudioSyncOffsetChanged.fromJson(json),
    'InputAudioTracksChanged': (Map<String, dynamic> json) =>
        InputAudioTracksChanged.fromJson(json),
    'InputCreated': (Map<String, dynamic> json) => InputCreated.fromJson(json),
    'InputMuteStateChanged': (Map<String, dynamic> json) =>
        InputMuteStateChanged.fromJson(json),
    'InputNameChanged': (Map<String, dynamic> json) =>
        InputNameChanged.fromJson(json),
    'InputRemoved': (Map<String, dynamic> json) => InputRemoved.fromJson(json),
    'InputSettingsChanged': (Map<String, dynamic> json) =>
        InputSettingsChanged.fromJson(json),
    'InputShowStateChanged': (Map<String, dynamic> json) =>
        InputShowStateChanged.fromJson(json),
    'InputVolumeChanged': (Map<String, dynamic> json) =>
        InputVolumeChanged.fromJson(json),
    'InputVolumeMeters': (Map<String, dynamic> json) =>
        InputVolumeMeters.fromJson(json),

    // outputs
    'RecordStateChanged': (Map<String, dynamic> json) =>
        RecordStateChanged.fromJson(json),
    'ReplayBufferSaved': (Map<String, dynamic> json) =>
        ReplayBufferSaved.fromJson(json),
    'ReplayBufferStateChanged': (Map<String, dynamic> json) =>
        ReplayBufferStateChanged.fromJson(json),
    'StreamStateChanged': (Map<String, dynamic> json) =>
        StreamStateChanged.fromJson(json),
    'VirtualcamStateChanged': (Map<String, dynamic> json) =>
        VirtualcamStateChanged.fromJson(json),

    // scenes
    'CurrentPreviewSceneChanged': (Map<String, dynamic> json) =>
        CurrentPreviewSceneChanged.fromJson(json),
    'CurrentProgramSceneChanged': (Map<String, dynamic> json) =>
        CurrentProgramSceneChanged.fromJson(json),
    'SceneListChanged': (Map<String, dynamic> json) =>
        SceneListChanged.fromJson(json),
    'SceneNameChanged': (Map<String, dynamic> json) =>
        SceneNameChanged.fromJson(json),
    'SceneRemoved': (Map<String, dynamic> json) => SceneRemoved.fromJson(json),
    // scene items
    'SceneItemCreated': (Map<String, dynamic> json) =>
        SceneItemCreated.fromJson(json),
    'SceneItemEnableStateChanged': (Map<String, dynamic> json) =>
        SceneItemEnableStateChanged.fromJson(json),
    'SceneItemRemoved': (Map<String, dynamic> json) =>
        SceneItemRemoved.fromJson(json),
    'SceneItemSelected': (Map<String, dynamic> json) =>
        SceneItemSelected.fromJson(json),

    // ui
    'ScreenshotSaved': (Map<String, dynamic> json) =>
        ScreenshotSaved.fromJson(json),
    'StudioModeStateChanged': (Map<String, dynamic> json) =>
        StudioModeStateChanged.fromJson(json),
  };

  factory FromJsonSingleton() {
    return _singleton;
  }

  FromJsonSingleton._internal();
}
