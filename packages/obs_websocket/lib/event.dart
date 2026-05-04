/// Event models for OBS WebSocket protocol notifications.
///
/// This library exports all event classes that OBS Studio can broadcast
/// to connected WebSocket clients. Events cover canvases, configuration
/// changes, general system events, inputs, filters, media, outputs,
/// scenes, scene items, transitions, and UI state changes.
library;

export 'src/model/event/canvases/base_canvas_event.dart';
export 'src/model/event/canvases/canvas_created.dart';
export 'src/model/event/canvases/canvas_name_changed.dart';
export 'src/model/event/canvases/canvas_removed.dart';

export 'src/model/event/config/current_profile_changed.dart';
export 'src/model/event/config/current_profile_changing.dart';
export 'src/model/event/config/current_scene_collection_changed.dart';
export 'src/model/event/config/current_scene_collection_changing.dart';
export 'src/model/event/config/profile_list_changed.dart';
export 'src/model/event/config/scene_collection_list_changed.dart';

export 'src/model/event/general/custom_event.dart';
export 'src/model/event/general/exit_started.dart';
export 'src/model/event/general/vendor_event.dart';

export 'src/model/event/inputs/input_active_state_changed.dart';
export 'src/model/event/inputs/input_audio_balance_changed.dart';
export 'src/model/event/inputs/input_audio_monitor_type_changed.dart';
export 'src/model/event/inputs/input_audio_sync_offset_changed.dart';
export 'src/model/event/inputs/input_audio_tracks_changed.dart';
export 'src/model/event/inputs/input_created.dart';
export 'src/model/event/inputs/input_mute_state_changed.dart';
export 'src/model/event/inputs/input_name_changed.dart';
export 'src/model/event/inputs/input_removed.dart';
export 'src/model/event/inputs/input_settings_changed.dart';
export 'src/model/event/inputs/input_show_state_changed.dart';
export 'src/model/event/inputs/input_volume_changed.dart';
export 'src/model/event/inputs/input_volume_meters.dart';

export 'src/model/event/filters/source_filter_created.dart';
export 'src/model/event/filters/source_filter_enable_state_changed.dart';
export 'src/model/event/filters/source_filter_list_reindexed.dart';
export 'src/model/event/filters/source_filter_name_changed.dart';
export 'src/model/event/filters/source_filter_removed.dart';
export 'src/model/event/filters/source_filter_settings_changed.dart';

export 'src/model/event/media_inputs/media_input_action_triggered.dart';
export 'src/model/event/media_inputs/media_input_playback_ended.dart';
export 'src/model/event/media_inputs/media_input_playback_started.dart';

export 'src/model/event/outputs/record_file_changed.dart';
export 'src/model/event/outputs/record_state_changed.dart';
export 'src/model/event/outputs/replay_buffer_saved.dart';
export 'src/model/event/outputs/replay_buffer_state_changed.dart';
export 'src/model/event/outputs/stream_state_changed.dart';
export 'src/model/event/outputs/virtualcam_state_changed.dart';

export 'src/model/event/scene/base_scene_event.dart';
export 'src/model/event/scene/base_scene_group_event.dart';
export 'src/model/event/scene/current_preview_scene_changed.dart';
export 'src/model/event/scene/current_program_scene_changed.dart';
export 'src/model/event/scene/scene_created.dart';
export 'src/model/event/scene/scene_list_changed.dart';
export 'src/model/event/scene/scene_name_changed.dart';
export 'src/model/event/scene/scene_removed.dart';

export 'src/model/event/scene_items/scene_item_created.dart';
export 'src/model/event/scene_items/scene_item_enable_state_changed.dart';
export 'src/model/event/scene_items/scene_item_list_reindexed.dart';
export 'src/model/event/scene_items/scene_item_lock_state_changed.dart';
export 'src/model/event/scene_items/scene_item_removed.dart';
export 'src/model/event/scene_items/scene_item_selected.dart';
export 'src/model/event/scene_items/scene_item_transform_changed.dart';

export 'src/model/event/transitions/current_scene_transition_changed.dart';
export 'src/model/event/transitions/current_scene_transition_duration_changed.dart';
export 'src/model/event/transitions/scene_transition_ended.dart';
export 'src/model/event/transitions/scene_transition_started.dart';
export 'src/model/event/transitions/scene_transition_video_ended.dart';

export 'src/model/event/ui/screenshot_saved.dart';
export 'src/model/event/ui/studio_mode_state_changed.dart';
