
# Easy OBS WebSocket CLI

A command line interface for controlling OBS with cli commands
- [Easy OBS WebSocket CLI](#easy-obs-websocket-cli)
  - [Installation](#installation)
  - [Quick start](#quick-start)
  - [Available Commands](#available-commands)
    - [authorize](#authorize)
    - [config](#config)
      - [config get-record-directory](#config-get-record-directory)
      - [config get-stream-service-settings](#config-get-stream-service-settings)
      - [config get-video-settings](#config-get-video-settings)
      - [config set-stream-service-settings](#config-set-stream-service-settings)
      - [config set-video-settings](#config-set-video-settings)
    - [general](#general)
      - [general get-stats](#general-get-stats)
      - [general get-version](#general-get-version)
    - [inputs](#inputs)
      - [inputs get-input-kind-list](#inputs-get-input-kind-list)
      - [inputs get-input-list](#inputs-get-input-list)
      - [inputs get-input-mute](#inputs-get-input-mute)
      - [inputs remove-input](#inputs-remove-input)
      - [inputs set-input-mute](#inputs-set-input-mute)
      - [inputs set-input-name](#inputs-set-input-name)
      - [inputs toggle-input-mute](#inputs-toggle-input-mute)
    - [listen](#listen)
    - [scene-items](#scene-items)
      - [scene-items get-scene-item-list](#scene-items-get-scene-item-list)
      - [scene-items get-scene-item-locked](#scene-items-get-scene-item-locked)
      - [scene-items set-scene-item-locked](#scene-items-set-scene-item-locked)
    - [scenes](#scenes)
      - [scenes get-current-program-scene](#scenes-get-current-program-scene)
      - [scenes get-group-list](#scenes-get-group-list)
      - [scenes get-scenes-list](#scenes-get-scenes-list)
    - [send](#send)
    - [sources](#sources)
      - [sources get-source-active](#sources-get-source-active)
      - [sources get-source-screenshot](#sources-get-source-screenshot)
      - [sources save-source-screenshot](#sources-save-source-screenshot)
    - [stream](#stream)
      - [stream get-stream-status](#stream-get-stream-status)
      - [stream send-stream-caption](#stream-send-stream-caption)
      - [stream start-streaming](#stream-start-streaming)
      - [stream stop-streaming](#stream-stop-streaming)
      - [stream toggle-stream](#stream-toggle-stream)
    - [ui](#ui)
      - [ui get-monitor-list](#ui-get-monitor-list)
      - [ui get-studio-mode-enabled](#ui-get-studio-mode-enabled)
      - [ui set-studio-mode-enabled](#ui-set-studio-mode-enabled)
    - [version](#version)
  - [Advanced Usage](#advanced-usage)
    - [Subscribing to an OBS event](#subscribing-to-an-obs-event)
    - [Trigger a shell command for an OBS event](#trigger-a-shell-command-for-an-obs-event)

## Installation

Install using `dart pub`:

For more information about `dart` and how to install it, check out [dart.dev](https://dart.dev/get-dart) 

```sh
dart pub global activate obs_websocket
```

Install using `brew`:

For more information about the `brew` package manager and how to install it, check out [brew.sh](https://brew.sh/) 

```sh
brew tap faithoflifedev/obs_websocket
brew install obs
```

Then check the install with,

```sh
obs --help
```

Result,

```text
A command line interface for controlling OBS.

Usage: obs <command> [arguments]

Global options:
-h, --help                        Print this usage information.
-u, --uri=<ws://[host]:[port]>    The url and port for OBS websocket
-t, --timeout=<int>               The timeout in seconds for the web socket connection.
-l, --log-level                   [all, debug, info, warning, error, off (default)]
-p, --passwd=<string>             The OBS websocket password, only required if enabled in OBS

Available commands:
  authorize     Generate an authentication file for an OBS connection
  config        Config Requests
  general       General commands
  inputs        Inputs Requests
  listen        Generate OBS events to stdout
  scene-items   Scene Items Requests
  scenes        Scenes Requests
  send          Send a low-level websocket request to OBS
  sources       Commands that manipulate OBS sources
  stream        Commands that manipulate OBS streams
  ui            Commands that manipulate the OBS user interface.
  version       Display the package name and version
```

| command | description |
| --- | --- |
| authorize | Generate an authentication file for an Onvif device |
| config | Config Requests - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#config-requests) |
| general | General commands - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#general-requests) |
| inputs | Inputs Requests - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#inputs-requests) |
| listen | Generate OBS events to stdout - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#events-table-of-contents) |
| scene-items | Scene Items Requests - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#scene-items-requests) |
| scenes | Scenes Requests - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#scenes-requests) |
| send | Send a low-level websocket request to OBS - [commands](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#requests-table-of-contents) |
| sources | Commands that manipulate OBS sources - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#sources-requests) |
| ui | Commands that manipulate the OBS user interface - [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#ui-requests)
| stream | Commands that manipulate OBS streams -  [documentation](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#stream-requests) |
| version | The current package and version for this tool. |

Just like the main dart library, any responses provided through the above commands will be given in JSON format.  So ideally, you will want to use a command line json parser to interpret the results.  The recommended json parser for this purpose is [_jq_](https://stedolan.github.io/jq/).

## Quick start

```sh
# step 1 - Configure your OBS credentials in bin/.env
# Edit bin/.env with your OBS WebSocket URL and password
# OBS_WEBSOCKET_URL=ws://localhost:4455
# OBS_WEBSOCKET_PASSWORD=your_password
```

```sh
# step 2 - Generate the authentication file
obs authorize
```

```sh
# step 3 - Test the connection
obs stream get-stream-status
```

Gives result,

```text
{"outputActive":false,"outputReconnecting":false,"outputTimecode":"00:00:00.000","outputDuration":0,"outputCongestion":0.0,"outputBytes":0,"outputSkippedFrames":0,"outputTotalFrames":0}
```

```sh
# or using the jq utility
obs stream get-stream-status | jq -r '.outputActive'
```

Result is,

```text
false
```

```sh
# or alternatively use the low-level send command
obs send --command GetStreamStatus | jq -r '.responseData.outputActive'
# same output as before: false
```

## Available Commands

### authorize

```sh
obs authorize --help
```

```text
Generate an authentication file for an OBS connection using bin/.env credentials

Usage: obs authorize [arguments]
-h, --help    Print this usage information.
```

The authorize command reads OBS WebSocket credentials from the `bin/.env` file and creates a credentials file at `~/.obs/credentials.json` for use by all future commands. 

**Required `.env` file format:**

```env
OBS_WEBSOCKET_URL=ws://[ip address or hostname]:[port]
OBS_WEBSOCKET_PASSWORD=[password]
```

**Setup instructions:**

1. Create or edit the `bin/.env` file in the obs_cli package directory
2. Add your OBS WebSocket URL and password
3. Run `obs authorize` to generate the credentials file

The generated credentials file contains:

```json
{"uri":"ws://[ip address or hostname]:[port]","password":"[password]"}
```

In general, this command only needs to be run when connecting to a different OBS instance or when the connection settings (URI, password) have changed.

### config

```sh
obs config --help
```

```text
Config Requests

Usage: obs config <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-record-directory          Gets the current directory that the record output is set to.
  get-stream-service-settings   Gets the current stream service settings (stream destination).
  get-video-settings            Gets the current video settings.
  set-stream-service-settings   Sets the current stream service settings (stream destination).
  set-video-settings            Sets the current video settings.
```

#### config get-record-directory

```sh
obs config get-record-directory --help
```

```text
Gets the current directory that the record output is set to.

Usage: obs config get-record-directory [arguments]
-h, --help    Print this usage information.
```


#### config get-stream-service-settings

```sh
obs config get-stream-service-settings --help
```

```text
Gets the current stream service settings (stream destination).

Usage: obs config get-stream-service-settings [arguments]
-h, --help    Print this usage information.
```

#### config get-video-settings

```sh
obs config get-video-settings --help
```

```text
Gets the current video settings.

Usage: obs config get-video-settings [arguments]
-h, --help    Print this usage information.
```

#### config set-stream-service-settings

```sh
obs config set-stream-service-settings --help
```

```text
Sets the current stream service settings (stream destination).

Usage: obs config set-stream-service-settings [arguments]
-h, --help                                          Print this usage information.
    --stream-service-type=<string> (mandatory)      Type of stream service to apply. Example: rtmp_common or rtmp_custom
    --stream-service-settings=<json> (mandatory)    Settings to apply to the service
```

#### config set-video-settings

```sh
obs config set-video-settings --help
```

```text
Sets the current video settings.

Usage: obs config set-video-settings [arguments]
-h, --help                                        Print this usage information.
    --fps-numerator=<int (greater than 0)>        Numerator of the fractional FPS value
    --fps-denominator=<int (greater than 0)>      Denominator of the fractional FPS value
    --base-width=<int (between 1 and 4096)>       Width of the base (canvas) resolution in pixels
    --base-height=<int (between 1 and 4096)>      Height of the base (canvas) resolution in pixels
    --output-width=<int (between 1 and 4096)>     Width of the output resolution in pixels
    --output-height=<int (between 1 and 4096)>    Height of the output resolution in pixels
```

### general

```sh
obs general --help
```

```text
General commands

Usage: obs general <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-stats     Gets statistics about OBS, obs-websocket, and the current session.
  get-version   Gets data about the current plugin and RPC version.
```

#### general get-stats

```sh
obs general get-stats --help
```

```text
Gets statistics about OBS, obs-websocket, and the current session.

Usage: obs general get-stats [arguments]
-h, --help    Print this usage information.
```

#### general get-version

```sh
obs general get-version --help
```

```text
Gets data about the current plugin and RPC version.

Usage: obs general get-version [arguments]
-h, --help    Print this usage information.
```

### inputs 

```sh
obs inputs --help
```

```text
Inputs Requests

Usage: obs inputs <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-input-kind-list   Gets an array of all available input kinds in OBS.
  get-input-list        Gets an array of all inputs in OBS.
  get-input-mute        Gets the mute status of an input.
  remove-input          Removes an existing input.
  set-input-mute        Sets the mute status of an input.
  set-input-name        Sets the name of an input (rename).
  toggle-input-mute     Toggles the mute status of an input.
```

#### inputs get-input-kind-list

```sh
obs inputs get-input-kind-list --help
```

```text
Gets an array of all available input kinds in OBS.

Usage: obs inputs get-input-kind-list [arguments]
-h, --help                Print this usage information.
    --[no-]unversioned    Whether to get unversioned input kinds.
```

#### inputs get-input-list

```sh
obs inputs get-input-list --help
```

```text
Gets an array of all inputs in OBS.

Usage: obs inputs get-input-list [arguments]
-h, --help         Print this usage information.
    --inputKind    The kind of input to get.
```

#### inputs get-input-mute

```sh
obs inputs get-input-mute --help
```

```text
Gets the mute status of an input.

Usage: obs inputs get-input-mute [arguments]
-h, --help         Print this usage information.
    --inputName    The name of the input to get the mute status of.
```

#### inputs remove-input

```sh
obs inputs remove-input --help
```

```text
Removes an existing input.

Usage: obs inputs remove-input [arguments]
-h, --help         Print this usage information.
    --inputName    The name of the input to remove.
```

#### inputs set-input-mute

```sh
obs inputs set-input-mute --help
```

```text
Sets the mute status of an input.

Usage: obs inputs set-input-mute [arguments]
-h, --help         Print this usage information.
    --inputName    The name of the input to set the mute status of.
    --[no-]mute    Whether to mute the input.
```

#### inputs set-input-name

```sh
obs inputs set-input-name --help
```

```text
Sets the name of an input (rename).

Usage: obs inputs set-input-name [arguments]
-h, --help            Print this usage information.
    --inputName       The name of the input to rename.
    --newInputName    The new name of the input.
```

#### inputs toggle-input-mute

```sh
obs inputs toggle-input-mute --help
```

```text
Toggles the mute status of an input.

Usage: obs inputs toggle-input-mute [arguments]
-h, --help         Print this usage information.
    --inputName    The name of the input to toggle the mute status of.
```

### listen 

```sh
obs listen --help
```

```text
Generate OBS events to stdout

Usage: obs listen [arguments]
-h, --help      Print this usage information.
    --event-subscriptions=<Supply one more more values comma separated.
    See https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#eventsubscription>
    Name of the source to get the active state of.

          [all] (default)               Helper to receive all non-high-volume events.
          [config]                      Subscription value to receive events in the Config category.
          [filters]                     Subscription value to receive events in the Filters category.
          [general]                     Subscription value to receive events in the General category.
          [inputActiveStateChanged]     Subscription value to receive the InputActiveStateChanged high-volume event.
          [inputShowStateChanged]       Subscription value to receive the InputShowStateChanged high-volume event.
          [inputVolumeMeters]           Subscription value to receive the InputVolumeMeters high-volume event.
          [inputs]                      Subscription value to receive events in the Inputs category.
          [mediaInputs]                 Subscription value to receive events in the MediaInputs category.
          [none]                        Subscription value used to disable all events.
          [outputs]                     Subscription value to receive events in the Outputs category.
          [sceneItemTransformChanged]   Subscription value to receive the SceneItemTransformChanged high-volume event.
          [sceneItems]                  Subscription value to receive events in the SceneItems category.
          [scenes]                      Subscription value to receive events in the Scenes category.
          [transitions]                 Subscription value to receive events in the Transitions category.
          [ui]                          Subscription value to receive events in the Ui category.
          [vendors]                     Subscription value to receive the VendorEvent event.
```

### scene-items

```sh
obs scene-items --help
```

```text
Scene Items Requests

Usage: obs scene-items <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-scene-item-list     Gets the lock state of a scene item.
  get-scene-item-locked   Gets the lock state of a scene item.
  set-scene-item-locked   Sets the lock state of a scene item.
```

#### scene-items get-scene-item-list

```sh
obs scene-items get-scene-item-list --help
```

```text
Gets a list of all scene items in a scene.

Usage: obs scene-items get-scene-item-list [arguments]
-h, --help                               Print this usage information.
-n, --scene-name=<string> (mandatory)    Name of the scene to get the items of
```

#### scene-items get-scene-item-locked

```sh
obs scene-items get-scene-item-locked --help
```

```text
Gets the lock state of a scene item.

Usage: obs scene-items get-scene-item-locked [arguments]
-h, --help                               Print this usage information.
-n, --scene-name=<string> (mandatory)    Name of the scene the item is in
-i, --scene-item-id=<int> (mandatory)    Numeric ID of the scene item
```

#### scene-items set-scene-item-locked

```sh
obs scene-items set-scene-item-locked --help
```

```text
Sets the lock state of a scene item.

Usage: obs scene-items set-scene-item-locked [arguments]
-h, --help                               Print this usage information.
-n, --scene-name=<string> (mandatory)    Name of the scene the item is in
-i, --scene-item-id=<int> (mandatory)    Numeric ID of the scene item
-l, --[no-]scene-item-locked             New lock state of the scene item
```

### scenes

```sh
obs scenes --help
```

```text
Scenes Requests

Usage: obs scenes <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-current-program-scene   Gets the current program scene.
  get-group-list              Gets an array of all groups in OBS.
  get-scenes-list             Gets an array of all scenes in OBS.
```

#### scenes get-current-program-scene

```sh
obs scenes get-current-program-scene --help
```

```text
Gets the current program scene.

Usage: obs scenes get-current-program-scene [arguments]
-h, --help    Print this usage information.
```

#### scenes get-group-list

```sh
obs scenes get-group-list --help
```

```text
Gets an array of all groups in OBS.

Usage: obs scenes get-group-list [arguments]
-h, --help    Print this usage information.
```

#### scenes get-scenes-list

```sh
obs scenes get-scenes-list --help
```

```text
Gets an array of all scenes in OBS.

Usage: obs scenes get-scenes-list [arguments]
-h, --help    Print this usage information.
```

### send

```sh
obs send --help
```

```text
Option command is mandatory.

Usage: obs send [arguments]
-h, --help                            Print this usage information.
-c, --command=<string> (mandatory)    One of the OBS web socket supported requests - https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#requests-table-of-contents
-a, --args=<json string>              The json representing the arguments necessary for the supplied command.
```

### sources

```sh
obs sources --help
```

```text
Commands that manipulate OBS sources

Usage: obs sources <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-source-active        Gets the active and show state of a source.
  get-source-screenshot    Gets a Base64-encoded screenshot of a source.
  save-source-screenshot   Saves a screenshot of a source to the filesystem.
```

#### sources get-source-active

```sh
obs sources get-source-active --help
```

```text
Gets the active and show state of a source.

Usage: obs sources get-source-active [arguments]
-h, --help                                Print this usage information.
    --source-name=<string> (mandatory)    Name of the source to get the active state of
```

#### sources get-source-screenshot

```sh
obs sources get-source-screenshot --help
```

```text
Gets a Base64-encoded screenshot of a source.

Usage: obs sources get-source-screenshot [arguments]
-h, --help                                 Print this usage information.
    --source-name=<string> (mandatory)     Name of the source to take a screenshot of
    --image-format=<string> (mandatory)    Image compression format to use. Use GetVersion to get compatible image formats
```

#### sources save-source-screenshot

```sh
obs sources save-source-screenshot --help
```

```text
Saves a screenshot of a source to the filesystem.

Usage: obs sources save-source-screenshot [arguments]
-h, --help                                    Print this usage information.
    --source-name=<string> (mandatory)        Name of the source to take a screenshot of
    --image-format=<string> (mandatory)       Image compression format to use. Use GetVersion to get compatible image formats
    --image-file-path=<string> (mandatory)    Path to save the screenshot file to.
```

### stream

```sh
obs stream --help
```

```text
Commands that manipulate OBS streams

Usage: obs stream <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-stream-status     Gets the status of the stream output.
  send-stream-caption   Sends CEA-608 caption text over the stream output.
  start-streaming       Starts the stream output.
  stop-streaming        Stops the stream output.
  toggle-stream         Toggles the status of the stream output.
```

#### stream get-stream-status

```sh
obs stream get-stream-status --help
```

```text
Gets the status of the stream output.

Usage: obs stream get-stream-status [arguments]
-h, --help    Print this usage information.
```

#### stream send-stream-caption

```sh
obs stream send-stream-caption --help
```

```text
Sends CEA-608 caption text over the stream output.

Usage: obs stream send-stream-caption [arguments]
-h, --help                                 Print this usage information.
    --caption-Text=<string> (mandatory)    Caption text
```

#### stream start-streaming

```sh
obs stream start-streaming --help
```

```text
Starts the stream output.

Usage: obs stream start-streaming [arguments]
-h, --help    Print this usage information.
``` 

#### stream stop-streaming

```sh
obs stream stop-streaming --help
```

```text
Stops the stream output.

Usage: obs stream stop-streaming [arguments]
-h, --help    Print this usage information.
```


#### stream toggle-stream

```sh
obs stream toggle-stream --help
```

```text
Toggles the status of the stream output.

Usage: obs stream toggle-stream [arguments]
-h, --help    Print this usage information.
``` 

### ui

```sh
obs ui --help
```

```text
Commands that manipulate the OBS user interface.

Usage: obs ui <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  get-monitor-list          Gets a list of connected monitors and information about them.
  get-studio-mode-enabled   Gets whether studio is enabled.
  set-studio-mode-enabled   Enables or disables studio mode.
```


#### ui get-monitor-list 

```sh
obs ui get-monitor-list  --help
```

```text
Gets a list of connected monitors and information about them.

Usage: obs ui get-monitor-list [arguments]
-h, --help    Print this usage information.
``` 


#### ui get-studio-mode-enabled

```sh
obs ui get-studio-mode-enabled  --help
```

```text
Gets whether studio is enabled.

Usage: obs ui get-studio-mode-enabled [arguments]
-h, --help    Print this usage information.
``` 


#### ui set-studio-mode-enabled

```sh
obs ui set-studio-mode-enabled  --help
```

```text
Enables or disables studio mode.

Usage: obs ui set-studio-mode-enabled [arguments]
-h, --help                Print this usage information.
-m, --[no-]studio-mode    
``` 

### version

```sh
obs version --help
```

```text
Display the package name and version

Usage: obs version [arguments]
-h, --help    Print this usage information.
```

## Advanced Usage

### Subscribing to an OBS event

```sh
# will output json for any "scene" related event 
obs listen --event-subscriptions scenes
```

Gives the following result,

```text
{"eventType":"CurrentProgramSceneChanged","eventIntent":4,"eventData":{"sceneName":"Scene 2"}}
{"eventType":"CurrentProgramSceneChanged","eventIntent":4,"eventData":{"sceneName":"MY Scene"}}
{"eventType":"CurrentProgramSceneChanged","eventIntent":4,"eventData":{"sceneName":"Scene 2"}}
```

Now pipe the result through the `jq` command for each event

```sh
# jq will parse the json
obs listen --event-subscriptions scenes | jq -r '.eventType + "\t" + .eventData.sceneName'
```

Gives this result,

```text
CurrentProgramSceneChanged	Scene 2
CurrentProgramSceneChanged	MY Scene
CurrentProgramSceneChanged	Scene 2
```

### Trigger a shell command for an OBS event

The `listen` command provides an optional `--command` argument that allows the user to specify the shell command that will be executed each time OBS fires one of the events that has been subscribed to.  The example below will send a separate email containing the JSON payload of each event fired.

```sh
# send an email for every scene event
obs listen --event-subscriptions scenes --command 'mutt -s "OBS Scene Event" address@email.com'
```