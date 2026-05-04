---
name: add-obs-websocket-request
description: Add new OBS WebSocket requests to the obs_websocket package following protocol specification. Handles enum creation, response models, request methods, exports, tests, and README updates. Use when adding new OBS WebSocket protocol requests, implementing protocol methods, or extending the obs_websocket package functionality.
---

# Add OBS WebSocket Request

Automated workflow for implementing new OBS WebSocket protocol requests with full code generation, testing, and documentation.

## Prerequisites

Before starting, ensure you have:
- The request type/category (e.g., "Inputs", "Scenes", "Config")
- The actual request command name (e.g., "GetInputDeinterlaceMode")
- Access to the OBS WebSocket protocol documentation

## File Organization Pattern

**CRITICAL**: Follow the established "one file, one class" pattern throughout the codebase.

### File Organization Rules

- ✅ **ONE class per file** - Each enum, response model, or class gets its own dedicated file
- ✅ **Descriptive filenames** - Use snake_case that matches the class name
- ✅ **Separate files for**:
  - Each enum → `lib/src/enum/obs_{name}.dart`
  - Each response model → `lib/src/model/response/{name}_response.dart`
  - Request methods → Added to existing category file (e.g., `inputs.dart`)

### When to Break This Rule

Only combine classes in the same file when there is a **strong architectural reason**:
- Abstract base class + concrete implementations (e.g., `BaseCanvasEvent` + `CanvasCreated`, `CanvasRemoved`)
- Tightly coupled helper classes used exclusively by one main class
- Simple value objects that are never used independently

**When in doubt, use separate files.** This is the default pattern for OBS WebSocket requests.

### Examples

**✅ CORRECT - Separate files:**
```
lib/src/enum/
  ├── obs_deinterlace_mode.dart          # One enum per file
  └── obs_deinterlace_field_order.dart   # One enum per file

lib/src/model/response/
  ├── input_deinterlace_mode_response.dart        # One response model per file
  └── input_deinterlace_field_order_response.dart # One response model per file
```

**✅ ACCEPTABLE - Combined (base + implementations):**
```
lib/src/model/event/canvases/
  ├── base_canvas_event.dart       # Abstract base class
  ├── canvas_created.dart          # Concrete implementation
  ├── canvas_removed.dart          # Concrete implementation
  └── canvas_name_changed.dart     # Concrete implementation
```

**❌ INCORRECT - Multiple unrelated classes:**
```dart
// DON'T DO THIS - Multiple enums in one file
enum ObsDeinterlaceMode { ... }
enum ObsDeinterlaceFieldOrder { ... }
```

## Implementation Workflow

Copy this checklist and track progress:

```
Task Progress:
- [ ] Step 1: Review protocol documentation
- [ ] Step 2: Create enums (if needed)
- [ ] Step 3: Create response models
- [ ] Step 4: Implement request methods
- [ ] Step 5: Update exports
- [ ] Step 6: Run build_runner
- [ ] Step 7: Create comprehensive tests
- [ ] Step 8: Update README.md
- [ ] Step 9: Run full test suite
- [ ] Step 10: Verify no analysis errors
```

---

## Step 1: Review Protocol Documentation

**ALWAYS** fetch and review the latest protocol documentation before writing code.

Two equivalent sources are available — choose whichever best fits the task:

1. **Markdown reference (human-readable):**
   https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md
2. **JSON reference (machine-readable, preferred for programmatic lookup):**
   https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.json

Both sources contain the same protocol information. Use the JSON reference when you need structured data (e.g., extracting field names/types into templates, scripted generation, or precise enum value lookups), and use the Markdown reference when you want narrative context and examples.

Steps:

1. Fetch either the Markdown or JSON reference (or both for cross-verification)
2. Search for the request command name
3. Note the following details:
   - Request name (e.g., "GetInputDeinterlaceMode")
   - Request fields and types
   - Response fields and types
   - Complexity rating
   - RPC version
   - Added in version
   - Any special notes or requirements

### Example Protocol Structure (Markdown)

```markdown
### GetInputDeinterlaceMode
Gets the deinterlace mode of an input.

**Request fields:**
- `inputName` (String) - Name of the input (optional if inputUuid provided)
- `inputUuid` (String) - UUID of the input (optional if inputName provided)

**Response fields:**
- `deinterlaceMode` (String) - Deinterlace mode (enum value)

- Complexity Rating: 3/5
- Latest Supported RPC Version: 1
- Added in v5.0.0
```

### Example Protocol Structure (JSON)

The JSON reference exposes each request under `requests[]` with the same fields in structured form:

```json
{
  "requestType": "GetInputDeinterlaceMode",
  "complexity": 3,
  "rpcVersion": "1",
  "deprecated": false,
  "initialVersion": "5.0.0",
  "category": "inputs",
  "description": "Gets the deinterlace mode of an input.",
  "requestFields": [
    {
      "valueName": "inputName",
      "valueType": "String",
      "valueDescription": "Name of the input",
      "valueOptional": true
    },
    {
      "valueName": "inputUuid",
      "valueType": "String",
      "valueDescription": "UUID of the input",
      "valueOptional": true
    }
  ],
  "responseFields": [
    {
      "valueName": "deinterlaceMode",
      "valueType": "String",
      "valueDescription": "Deinterlace mode"
    }
  ]
}
```

Enum definitions live under the top-level `enums[]` array in `protocol.json`, making it the preferred source when generating Dart enums from protocol values.

---

## Step 2: Create Enums (If Needed)

If the request/response uses enum values:

### File Location
`packages/obs_websocket/lib/src/enum/obs_{enum_name}.dart`

### Enum Template

```dart
import 'package:json_annotation/json_annotation.dart';

/// Description of what this enum represents
@JsonEnum()
enum ObsEnumName {
  @JsonValue('OBS_ENUM_VALUE_ONE')
  valueOne('OBS_ENUM_VALUE_ONE'),
  @JsonValue('OBS_ENUM_VALUE_TWO')
  valueTwo('OBS_ENUM_VALUE_TWO');

  const ObsEnumName(this.code);

  final String code;

  /// Returns the enum value from its string code
  static ObsEnumName fromCode(String code) {
    return ObsEnumName.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ObsEnumName.valueOne, // Default fallback
    );
  }

  @override
  String toString() => code;
}
```

### Critical Rules for Enums

- ✅ **ALWAYS** use `@JsonEnum()` annotation
- ✅ **ALWAYS** use `@JsonValue('ACTUAL_VALUE')` for each enum member
- ✅ **ALWAYS** follow `lowerCamelCase` for enum member names
- ✅ **ALWAYS** provide `fromCode()` static method
- ✅ **ALWAYS** store the code string in a final field
- ❌ **NEVER** use uppercase or PascalCase for enum member names

---

## Step 3: Create Response Models

### File Location
`packages/obs_websocket/lib/src/model/response/{request_name_snake_case}_response.dart`

### Response Model Template

```dart
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part '{file_name_snake_case}.g.dart';

@JsonSerializable()
class ResponseClassName {
  @JsonKey(unknownEnumValue: ObsEnumName.defaultValue)
  final ObsEnumName fieldName;

  ResponseClassName({
    required this.fieldName,
  });

  factory ResponseClassName.fromJson(Map<String, dynamic> json) =>
      _$ResponseClassNameFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseClassNameToJson(this);

  @override
  String toString() => json.encode(toJson());
}
```

### Critical Rules for Response Models

- ✅ **ALWAYS** include `part 'filename.g.dart';`
- ✅ **ALWAYS** use `@JsonSerializable()` annotation
- ✅ **ALWAYS** add `@JsonKey(unknownEnumValue: ...)` for enum fields
- ✅ **ALWAYS** implement `fromJson`, `toJson`, and `toString`
- ✅ **ALWAYS** use `json.encode(toJson())` in toString
- ✅ **ALWAYS** make fields `final` and use `required` in constructor

---

## Step 4: Implement Request Methods

### File Location
Find the appropriate request file in `packages/obs_websocket/lib/src/request/`:
- `inputs.dart` for input-related requests
- `scenes.dart` for scene-related requests
- `config.dart` for configuration requests
- etc.

### Request Method Template

```dart
/// Gets the description of what this method does.
///
/// - Complexity Rating: X/5
/// - Latest Supported RPC Version: 1
/// - Added in v5.X.0
Future<ResponseType> getRequestName({
  String? inputName,
  String? inputUuid,
  // ... other parameters
}) async {
  if (inputName == null && inputUuid == null) {
    throw ArgumentError('inputName or inputUuid must be provided');
  }

  final response = await obsWebSocket.sendRequest(
    Request(
      'GetRequestName',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        // ... other fields
      },
    ),
  );

  return ResponseType.fromJson(response!.responseData!);
}
```

### Setter Method Template (for void returns)

```dart
/// Sets the description of what this method does.
///
/// - Complexity Rating: X/5
/// - Latest Supported RPC Version: 1
/// - Added in v5.X.0
Future<void> setRequestName({
  String? inputName,
  String? inputUuid,
  required EnumType paramName,
}) async {
  if (inputName == null && inputUuid == null) {
    throw ArgumentError('inputName or inputUuid must be provided');
  }

  await obsWebSocket.sendRequest(
    Request(
      'SetRequestName',
      requestData: {
        'inputName': inputName,
        'inputUuid': inputUuid,
        'paramName': paramName.code,
      },
    ),
  );
}
```

### Critical Rules for Request Methods

- ✅ **ALWAYS** include documentation with complexity, RPC version, and added version
- ✅ **ALWAYS** validate that at least one identifier (inputName/inputUuid) is provided
- ✅ **ALWAYS** use `obsWebSocket.sendRequest()` with `Request` object
- ✅ **ALWAYS** use `.code` property when passing enum values
- ✅ **ALWAYS** use `response!.responseData!` for non-void returns
- ✅ **ALWAYS** throw `ArgumentError` with descriptive message for validation failures

---

## Step 5: Update Exports

### Update obs_websocket.dart

**File:** `packages/obs_websocket/lib/obs_websocket.dart`

Add enum exports (alphabetically sorted):
```dart
export 'src/enum/obs_new_enum.dart';
```

Add response model exports (alphabetically sorted):
```dart
export 'src/model/response/new_response.dart';
```

### No Changes Needed To
- `request.dart` - Already exports entire request directory
- `event.dart` - Only for event classes, not requests

---

## Step 6: Run build_runner

```bash
cd packages/obs_websocket
dart run build_runner build --delete-conflicting-outputs
```

**Expected output:** Should generate `.g.dart` files for all new models

**Note:** Warnings about `--delete-conflicting-outputs` being removed are normal and can be ignored.

---

## Step 7: Create Comprehensive Tests

### File Location
`packages/obs_websocket/test/{feature_name}_test.dart`

### Test Template

```dart
import 'dart:convert';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:test/test.dart';

void main() {
  group('ObsEnumName', () {
    test('should have correct code values', () {
      expect(ObsEnumName.valueOne.code, 'OBS_ENUM_VALUE_ONE');
      expect(ObsEnumName.valueTwo.code, 'OBS_ENUM_VALUE_TWO');
    });

    test('should convert from code string', () {
      expect(
        ObsEnumName.fromCode('OBS_ENUM_VALUE_ONE'),
        ObsEnumName.valueOne,
      );
    });

    test('should return default for unknown code', () {
      expect(
        ObsEnumName.fromCode('UNKNOWN_CODE'),
        ObsEnumName.valueOne,
      );
    });

    test('should toString return code', () {
      expect(ObsEnumName.valueOne.toString(), 'OBS_ENUM_VALUE_ONE');
    });
  });

  group('ResponseClassName', () {
    test('should parse from JSON', () {
      final json = {
        'fieldName': 'OBS_ENUM_VALUE_ONE',
      };

      final response = ResponseClassName.fromJson(json);

      expect(response.fieldName, ObsEnumName.valueOne);
    });

    test('should convert to JSON', () {
      final response = ResponseClassName(
        fieldName: ObsEnumName.valueTwo,
      );

      final json = response.toJson();

      expect(json['fieldName'], 'OBS_ENUM_VALUE_TWO');
    });

    test('should handle round-trip serialization', () {
      final response = ResponseClassName(
        fieldName: ObsEnumName.valueOne,
      );

      final json = response.toJson();
      final jsonString = jsonEncode(json);
      final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final responseFromJson = ResponseClassName.fromJson(parsedJson);

      expect(responseFromJson.fieldName, response.fieldName);
    });

    test('should toString return JSON', () {
      final response = ResponseClassName(
        fieldName: ObsEnumName.valueOne,
      );

      final result = response.toString();

      expect(result, isA<String>());
      expect(result, contains('OBS_ENUM_VALUE_ONE'));
    });
  });
}
```

### Test Coverage Requirements

- ✅ Enum: code values, fromCode(), default fallback, toString()
- ✅ Response: fromJson, toJson, round-trip serialization, toString
- ✅ Request methods: (Integration tests require live OBS instance)

---

## Step 8: Update README.md

### Find the Appropriate Section

Locate the request category section in `packages/obs_websocket/README.md`:
- "Inputs Requests" for input-related
- "Scenes Requests" for scene-related
- etc.

### Add Entry Format

```markdown
- [x\] [RequestName](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#requestname) - Brief description of what it does.
```

### Example Addition

```markdown
- [Inputs Requests](...) - `obsWebSocket.inputs`
  - [x\] [GetInputDeinterlaceMode](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#getinputdeinterlacemode) - Gets the deinterlace mode of an input.
  - [x\] [SetInputDeinterlaceMode](https://github.com/obsproject/obs-websocket/blob/master/docs/generated/protocol.md#setinputdeinterlacemode) - Sets the deinterlace mode of an input.
```

### Critical Rules for README Updates

- ✅ **ALWAYS** use `[x\]` for implemented requests
- ✅ **ALWAYS** include link to protocol documentation
- ✅ **ALWAYS** include brief description
- ✅ **ALWAYS** use lowercase anchor in URL (#getinputdeinterlacemode)
- ✅ **ALWAYS** maintain alphabetical order within category

---

## Step 9: Run Full Test Suite

```bash
cd packages/obs_websocket
dart test
```

**Expected:** All tests pass (including new tests)

**Note:** Test count should increase by the number of new tests added.

---

## Step 10: Verify No Analysis Errors

```bash
cd packages/obs_websocket
dart analyze
```

**Expected:** "No issues found!"

**Fix any issues before completing the task.**

---

## Common Patterns Reference

### Input Identifier Pattern
Most input-related methods accept either `inputName` or `inputUuid` (at least one required):

```dart
if (inputName == null && inputUuid == null) {
  throw ArgumentError('inputName or inputUuid must be provided');
}
```

### Enum Serialization Pattern
Enums MUST use `@JsonValue` annotations for proper JSON serialization:

```dart
@JsonEnum()
enum ObsEnumName {
  @JsonValue('OBS_ENUM_VALUE_ONE')
  valueOne('OBS_ENUM_VALUE_ONE'),
}
```

### Response Model Pattern
All response models follow this structure:
- Import `dart:convert`
- Import `json_annotation`
- Import `obs_websocket.dart` (for enums)
- Use `part` directive for generated code
- Implement `fromJson`, `toJson`, `toString`

---

## Quality Checklist

Before considering the implementation complete, verify:

- [ ] Protocol documentation reviewed
- [ ] Enums use `@JsonEnum()` and `@JsonValue()` annotations
- [ ] Enums follow lowerCamelCase naming
- [ ] Response models have proper annotations
- [ ] Response models include all required methods
- [ ] Request methods have complete documentation
- [ ] Request methods validate required parameters
- [ ] Exports added to obs_websocket.dart
- [ ] build_runner executed successfully
- [ ] Tests cover enums and response models
- [ ] Tests include round-trip serialization
- [ ] README.md updated with new requests
- [ ] All tests pass
- [ ] No analysis errors or warnings

---

## Troubleshooting

### Build Runner Issues
- **Problem:** Missing .g.dart files
- **Solution:** Run `dart run build_runner build --delete-conflicting-outputs`

### Test Failures
- **Problem:** Enum serialization fails
- **Solution:** Ensure `@JsonValue()` annotations match protocol values exactly

### Analysis Warnings
- **Problem:** unnecessary_import warning
- **Solution:** Remove redundant imports if types are already exported via obs_websocket.dart

- **Problem:** constant_identifier_names warning
- **Solution:** Use lowerCamelCase for enum members, not PascalCase

---

## Example: Complete Implementation

For a real-world example of this workflow in action, see the implementation of:
- GetInputDeinterlaceMode
- SetInputDeinterlaceMode  
- GetInputDeinterlaceFieldOrder
- SetInputDeinterlaceFieldOrder

These demonstrate the complete flow from protocol review to final verification.
