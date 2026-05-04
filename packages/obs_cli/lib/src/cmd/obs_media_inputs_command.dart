import 'package:args/command_runner.dart';
import 'package:obs_cli/obs_cli.dart';
import 'package:obs_websocket/obs_websocket.dart' show ObsMediaInputAction;

/// UI Requests
class ObsMediaInputsCommand extends Command<void> {
  @override
  String get description => 'Commands that manipulate media inputs';

  @override
  String get name => 'media-inputs';

  ObsMediaInputsCommand() {
    addSubcommand(ObsGetMediaInputStatusCommand());
    addSubcommand(ObsSetMediaInputCursorCommand());
    addSubcommand(ObsOffsetMediaInputCursorCommand());
    addSubcommand(ObsTriggerMediaInputActionCommand());
  }
}

/// Gets the status of a media input.
class ObsGetMediaInputStatusCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the status of a media input.';

  @override
  String get name => 'get-media-input-status';

  ObsGetMediaInputStatusCommand() {
    argParser
      ..addOption(
        'input-name',
        valueHelp: 'string',
        help: 'Name of the media input',
      )
      ..addOption(
        'input-uuid',
        valueHelp: 'string',
        help: 'UUID of the media input',
      );
  }

  @override
  void run() async {
    if (argResults?['input-name'] == null &&
        argResults?['input-uuid'] == null) {
      throw UsageException(
        'Your request must contain at least one of the following fields: `inputName` or `inputUuid`.',
        '',
      );
    }

    await initializeObs();

    final mediaInputStatus = await obs.mediaInputs.getMediaInputStatus(
      inputName: argResults?['input-name'],
      inputUuid: argResults?['input-uuid'],
    );

    print(mediaInputStatus);

    await obs.close();
  }
}

/// Base class for media input cursor commands.
abstract class ObsMediaInputCursorCommandBase extends ObsHelperCommand {
  final String cursorParameterName;
  final String cursorParameterHelp;

  ObsMediaInputCursorCommandBase({
    required this.cursorParameterName,
    required this.cursorParameterHelp,
  }) {
    argParser
      ..addOption(
        'input-name',
        valueHelp: 'string',
        help: 'Name of the media input',
      )
      ..addOption(
        'input-uuid',
        valueHelp: 'string',
        help: 'UUID of the media input',
      )
      ..addOption(
        cursorParameterName,
        mandatory: true,
        valueHelp: 'number',
        help: cursorParameterHelp,
      );
  }

  /// Validates common input parameters and returns validated values
  Future<Map<String, dynamic>> validateAndGetInputs() async {
    // Validate that at least one of input-name or input-uuid is provided
    final inputName = argResults?['input-name'];

    final inputUuid = argResults?['input-uuid'];

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'Your request must contain at least one of the following fields: `input-name` or `input-uuid`.',
        '',
      );
    }

    // Validate that input-name is a string if provided
    if (inputName != null && inputName is! String) {
      throw UsageException('The `input-name` parameter must be a string.', '');
    }

    // Validate that input-uuid is a string if provided
    if (inputUuid != null && inputUuid is! String) {
      throw UsageException('The `input-uuid` parameter must be a string.', '');
    }

    // Validate cursor parameter
    final cursorString = argResults?[cursorParameterName];

    if (cursorString == null) {
      throw UsageException(
        'The `$cursorParameterName` parameter is required.',
        '',
      );
    }

    final cursorValue = int.tryParse(cursorString);

    if (cursorValue == null) {
      throw UsageException(
        'The `$cursorParameterName` parameter must be a valid integer.',
        '',
      );
    }

    return {
      'inputName': inputName,
      'inputUuid': inputUuid,
      'cursorValue': cursorValue,
    };
  }

  /// Abstract method for subclasses to implement their specific logic
  Future<void> executeCommand(Map<String, dynamic> inputs);

  @override
  void run() async {
    final inputs = await validateAndGetInputs();

    await initializeObs();

    await executeCommand(inputs);

    await obs.close();
  }
}

/// Sets the cursor position of a media input.
class ObsSetMediaInputCursorCommand extends ObsMediaInputCursorCommandBase {
  @override
  String get description => 'Sets the cursor position of a media input.';

  @override
  String get name => 'set-media-input-cursor';

  ObsSetMediaInputCursorCommand()
    : super(
        cursorParameterName: 'media-cursor',
        cursorParameterHelp: 'New cursor position to set',
      );

  @override
  Future<void> executeCommand(Map<String, dynamic> inputs) async {
    final cursorValue = inputs['cursorValue'] as int;

    // Validate that cursor value is non-negative for set operation
    if (cursorValue < 0) {
      throw UsageException(
        'The `media-cursor` parameter must be a non-negative integer (>= 0).',
        '',
      );
    }

    await obs.mediaInputs.setMediaInputCursor(
      inputName: inputs['inputName'],
      inputUuid: inputs['inputUuid'],
      mediaCursor: cursorValue,
    );
  }
}

/// Offsets the cursor position of a media input.
class ObsOffsetMediaInputCursorCommand extends ObsMediaInputCursorCommandBase {
  @override
  String get description => 'Offsets the cursor position of a media input.';

  @override
  String get name => 'offset-media-input-cursor';

  ObsOffsetMediaInputCursorCommand()
    : super(
        cursorParameterName: 'media-cursor-offset',
        cursorParameterHelp: 'Value to offset the current cursor position by',
      );

  @override
  Future<void> executeCommand(Map<String, dynamic> inputs) async {
    final cursorOffset = inputs['cursorValue'] as int;

    await obs.mediaInputs.offsetMediaInputCursor(
      inputName: inputs['inputName'],
      inputUuid: inputs['inputUuid'],
      mediaCursorOffset: cursorOffset,
    );

    print('Media input cursor offset by $cursorOffset milliseconds.');
  }
}

/// Triggers an action on a media input.
class ObsTriggerMediaInputActionCommand extends ObsHelperCommand {
  @override
  String get description => 'Triggers an action on a media input.';

  @override
  String get name => 'trigger-media-input-action';

  ObsTriggerMediaInputActionCommand() {
    argParser
      ..addOption(
        'input-name',
        valueHelp: 'string',
        help: 'Name of the media input',
      )
      ..addOption(
        'input-uuid',
        valueHelp: 'string',
        help: 'UUID of the media input',
      )
      ..addOption(
        'media-action',
        mandatory: true,
        allowed: [
          'none',
          'play',
          'pause',
          'stop',
          'restart',
          'next',
          'previous',
        ],
        allowedHelp: {
          'none': 'No action',
          'play': 'Play the media input',
          'pause': 'Pause the media input',
          'stop': 'Stop the media input',
          'restart': 'Restart the media input',
          'next': 'Go to next item (if applicable)',
          'previous': 'Go to previous item (if applicable)',
        },
        help: 'The action to trigger on the media input',
      );
  }

  @override
  void run() async {
    // Validate that at least one of input-name or input-uuid is provided
    final inputName = argResults?['input-name'];
    final inputUuid = argResults?['input-uuid'];

    if (inputName == null && inputUuid == null) {
      throw UsageException(
        'Your request must contain at least one of the following fields: `input-name` or `input-uuid`.',
        '',
      );
    }

    // Validate that input-name is a string if provided
    if (inputName != null && inputName is! String) {
      throw UsageException('The `input-name` parameter must be a string.', '');
    }

    // Validate that input-uuid is a string if provided
    if (inputUuid != null && inputUuid is! String) {
      throw UsageException('The `input-uuid` parameter must be a string.', '');
    }

    // Get and validate media action
    final mediaActionString = argResults?['media-action'] as String;

    // Convert string to enum
    final mediaAction = ObsMediaInputAction.values.firstWhere(
      (action) => action.name == mediaActionString,
      orElse: () =>
          throw UsageException('Invalid media action: $mediaActionString', ''),
    );

    await initializeObs();

    await obs.mediaInputs.triggerMediaInputAction(
      inputName: inputName,
      inputUuid: inputUuid,
      mediaAction: mediaAction,
    );

    await obs.close();
  }
}
