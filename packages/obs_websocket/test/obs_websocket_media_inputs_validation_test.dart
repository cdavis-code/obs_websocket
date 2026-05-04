import 'package:test/test.dart';

/// Test helper function that mimics the validation logic in ObsSetMediaInputCursorCommand
String? validateMediaCursor(String? mediaCursorString) {
  if (mediaCursorString == null) {
    return 'The `media-cursor` parameter is required.';
  }

  final mediaCursor = int.tryParse(mediaCursorString);
  if (mediaCursor == null) {
    return 'The `media-cursor` parameter must be a valid integer.';
  }

  if (mediaCursor < 0) {
    return 'The `media-cursor` parameter must be a non-negative integer (>= 0).';
  }

  return null; // Valid
}

/// Test helper function that mimics the validation logic for offset commands
String? validateMediaCursorOffset(String? mediaCursorOffsetString) {
  if (mediaCursorOffsetString == null) {
    return 'The `media-cursor-offset` parameter is required.';
  }

  final mediaCursorOffset = int.tryParse(mediaCursorOffsetString);
  if (mediaCursorOffset == null) {
    return 'The `media-cursor-offset` parameter must be a valid integer.';
  }

  // Offset allows negative values unlike set-cursor
  return null; // Valid
}

/// Test helper function that mimics the updated validation logic for input parameters
String? validateInputParameters(String? inputName, String? inputUuid) {
  if (inputName == null && inputUuid == null) {
    return 'Your request must contain at least one of the following fields: `input-name` or `input-uuid`.';
  }

  // In the actual command, type checking is done at runtime but since these are from
  // argResults they should already be strings. These checks would be done in actual usage.
  return null; // Valid
}

/// Test helper function for media action validation
String? validateMediaAction(String? mediaActionString) {
  if (mediaActionString == null) {
    return 'The `media-action` parameter is required.';
  }

  final allowedActions = [
    'none',
    'play',
    'pause',
    'stop',
    'restart',
    'next',
    'previous',
  ];
  if (!allowedActions.contains(mediaActionString)) {
    return 'Invalid media action: $mediaActionString';
  }

  return null; // Valid
}

void main() {
  group('MediaInput Command Validation Logic', () {
    group('validateMediaCursor', () {
      test('should return null for valid positive integers', () {
        expect(validateMediaCursor('1000'), isNull);
        expect(validateMediaCursor('0'), isNull);
        expect(validateMediaCursor('999999999'), isNull);
      });

      test('should return error for null input', () {
        expect(
          validateMediaCursor(null),
          'The `media-cursor` parameter is required.',
        );
      });

      test('should return error for invalid integer strings', () {
        expect(
          validateMediaCursor('abc'),
          'The `media-cursor` parameter must be a valid integer.',
        );
        expect(
          validateMediaCursor('123.45'),
          'The `media-cursor` parameter must be a valid integer.',
        );
        expect(
          validateMediaCursor('123abc'),
          'The `media-cursor` parameter must be a valid integer.',
        );
        expect(
          validateMediaCursor('123!'),
          'The `media-cursor` parameter must be a valid integer.',
        );
        expect(
          validateMediaCursor(''),
          'The `media-cursor` parameter must be a valid integer.',
        );
      });

      test('should return error for negative integers', () {
        expect(
          validateMediaCursor('-1'),
          'The `media-cursor` parameter must be a non-negative integer (>= 0).',
        );
        expect(
          validateMediaCursor('-999999'),
          'The `media-cursor` parameter must be a non-negative integer (>= 0).',
        );
      });

      test(
        'should handle whitespace correctly (int.tryParse trims whitespace)',
        () {
          expect(validateMediaCursor(' 123 '), isNull);
          expect(validateMediaCursor('\t456\t'), isNull);
          expect(validateMediaCursor('\n789\n'), isNull);
        },
      );
    });

    group('validateMediaCursorOffset', () {
      test('should return null for valid positive integers', () {
        expect(validateMediaCursorOffset('1000'), isNull);
        expect(validateMediaCursorOffset('0'), isNull);
        expect(validateMediaCursorOffset('999999999'), isNull);
      });

      test(
        'should return null for negative integers (offsets can be negative)',
        () {
          expect(validateMediaCursorOffset('-1'), isNull);
          expect(validateMediaCursorOffset('-999999'), isNull);
        },
      );

      test('should return error for null input', () {
        expect(
          validateMediaCursorOffset(null),
          'The `media-cursor-offset` parameter is required.',
        );
      });

      test('should return error for invalid integer strings', () {
        expect(
          validateMediaCursorOffset('abc'),
          'The `media-cursor-offset` parameter must be a valid integer.',
        );
        expect(
          validateMediaCursorOffset('123.45'),
          'The `media-cursor-offset` parameter must be a valid integer.',
        );
      });
    });

    group('validateInputParameters', () {
      test('should return null when input-name is provided', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateInputParameters('Media Source', null), isNull);
        expect(validateInputParameters('my-input-123', null), isNull);
      });

      test('should return null when input-uuid is provided', () {
        expect(validateInputParameters(null, 'test-uuid'), isNull);
        expect(validateInputParameters(null, '12345-67890-abcdef'), isNull);
      });

      test('should return null when both are provided', () {
        expect(validateInputParameters('test', 'test-uuid'), isNull);
      });

      test('should return error when neither is provided', () {
        expect(
          validateInputParameters(null, null),
          'Your request must contain at least one of the following fields: `input-name` or `input-uuid`.',
        );
      });
    });

    group('validateMediaAction', () {
      test('should return null for valid media actions', () {
        final validActions = [
          'none',
          'play',
          'pause',
          'stop',
          'restart',
          'next',
          'previous',
        ];
        for (final action in validActions) {
          expect(validateMediaAction(action), isNull);
        }
      });

      test('should return error for invalid media actions', () {
        expect(validateMediaAction('invalid'), 'Invalid media action: invalid');
        expect(validateMediaAction('PLAY'), 'Invalid media action: PLAY');
        expect(validateMediaAction(''), 'Invalid media action: ');
      });

      test('should return error for null input', () {
        expect(
          validateMediaAction(null),
          'The `media-action` parameter is required.',
        );
      });
    });

    group('Combined validation scenarios', () {
      test('all parameters valid for set cursor', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursor('1000'), isNull);
      });

      test('all parameters valid for offset cursor', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursorOffset('-500'), isNull);
      });

      test('all parameters valid for trigger action', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaAction('play'), isNull);
      });

      test('input parameters missing', () {
        expect(validateInputParameters(null, null), isNotNull);
        expect(validateMediaCursor('1000'), isNull);
      });

      test('media cursor missing', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursor(null), isNotNull);
      });

      test('input parameters valid, media cursor invalid', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursor('invalid'), isNotNull);
      });

      test('input parameters valid, media cursor negative', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursor('-1'), isNotNull);
      });

      test('offset cursor can be negative', () {
        expect(validateInputParameters('test', null), isNull);
        expect(validateMediaCursorOffset('-1'), isNull);
      });
    });
  });
}
