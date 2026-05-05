# Changelog

## 5.7.1

* **Fix**: Include generated `obs_mcp_server.mcp.dart` file in published package, which was previously excluded by `.pubignore`, causing `dart pub global activate obs_mcp` to fail with "No such file or directory" build error.

## 5.7.0

* Added comprehensive support for OBS WebSocket v5.7.0 features
* **Canvases**: New `canvases_list` tool to list all configured canvases
* **Input Audio Properties**: Full control over audio balance, sync offset, monitor type, and audio tracks
  * `inputs_get_audio_balance`, `inputs_set_audio_balance`
  * `inputs_get_audio_sync_offset`, `inputs_set_audio_sync_offset`
  * `inputs_get_audio_monitor_type`, `inputs_set_audio_monitor_type`
  * `inputs_get_audio_tracks`, `inputs_set_audio_tracks`
* **Input Properties Dialog**: Access to list property items and button presses
  * `inputs_get_properties_list_property_items`
  * `inputs_press_properties_button`
* **Scene Items Extended**: Access to source names and private settings
  * `scene_items_get_source`
  * `scene_items_get_private_settings`, `scene_items_set_private_settings`
* **Transitions**: Complete transition management (9 tools)
  * `transitions_get_kind_list`, `transitions_get_list`, `transitions_get_current`
  * `transitions_set_current`, `transitions_set_duration`, `transitions_set_settings`
  * `transitions_get_cursor`, `transitions_trigger_studio`, `transitions_set_tbar`
* **Filters**: Full filter lifecycle management (10 tools)
  * `filters_get_kind_list`, `filters_get_list`, `filters_get_default_settings`
  * `filters_create`, `filters_remove`, `filters_rename`
  * `filters_get`, `filters_set_index`, `filters_set_settings`, `filters_set_name`
* **Outputs Extended**: List all outputs, get/set output status and settings
  * `outputs_get_list`, `outputs_get_status`, `outputs_set_settings`
* Improved error handling with bootstrap error tracking
* Extracted monitor type parsing to reusable helper method
* Standardized @Tool annotation formatting for better readability
* Added clarifying comments for scene_items methods returning Map directly

## 5.6.0

* Initial release as standalone package
* Extracted MCP server from obs_websocket package
* Core OBS WebSocket v5.6.0 support
* Basic tools for inputs, scenes, streaming, recording, and outputs
