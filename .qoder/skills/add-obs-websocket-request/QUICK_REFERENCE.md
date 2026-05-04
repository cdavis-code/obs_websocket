# Quick Reference: Adding OBS WebSocket Requests

## File Organization Pattern

**CRITICAL**: One file, one class (unless strong architectural reason to combine)

- ✅ Each enum → separate file
- ✅ Each response model → separate file
- ✅ Base class + implementations → can share file
- ❌ Multiple unrelated classes → NEVER in same file

## File Locations

| Component | Location |
|-----------|----------|
| Enums | `lib/src/enum/obs_{name}.dart` |
| Response Models | `lib/src/model/response/{name}_response.dart` |
| Request Methods | `lib/src/request/{category}.dart` |
| Tests | `test/{feature}_test.dart` |
| README | `README.md` |

## Quick Templates

### Enum
```dart
@JsonEnum()
enum ObsName {
  @JsonValue('OBS_VALUE_ONE')
  valueOne('OBS_VALUE_ONE'),
  
  const ObsName(this.code);
  final String code;
  
  static ObsName fromCode(String code) =>
    ObsName.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ObsName.valueOne,
    );
}
```

### Response Model
```dart
@JsonSerializable()
class NameResponse {
  @JsonKey(unknownEnumValue: ObsName.valueOne)
  final ObsName fieldName;
  
  NameResponse({required this.fieldName});
  
  factory NameResponse.fromJson(Map<String, dynamic> json) =>
    _$NameResponseFromJson(json);
    
  Map<String, dynamic> toJson() => _$NameResponseToJson(this);
  
  @override
  String toString() => json.encode(toJson());
}
```

### Request Method
```dart
/// Description.
///
/// - Complexity Rating: 3/5
/// - Latest Supported RPC Version: 1
/// - Added in v5.X.0
Future<ResponseType> getMethod({String? name, String? uuid}) async {
  if (name == null && uuid == null) {
    throw ArgumentError('name or uuid must be provided');
  }
  
  final response = await obsWebSocket.sendRequest(
    Request('MethodName', requestData: {'name': name, 'uuid': uuid}),
  );
  
  return ResponseType.fromJson(response!.responseData!);
}
```

## Essential Commands

```bash
# Generate .g.dart files
dart run build_runner build --delete-conflicting-outputs

# Run tests
dart test

# Run tests for specific file
dart test test/my_test.dart

# Check for errors
dart analyze

# Fix code style
dart fix --apply
```

## Critical Rules

### Enums
- ✅ Use `@JsonEnum()` annotation
- ✅ Use `@JsonValue('ACTUAL_VALUE')` on each member
- ✅ Use lowerCamelCase for member names
- ✅ Provide `fromCode()` method

### Response Models
- ✅ Include `part 'filename.g.dart';`
- ✅ Use `@JsonSerializable()` annotation
- ✅ Add `@JsonKey(unknownEnumValue: ...)` for enums
- ✅ Implement fromJson, toJson, toString

### Request Methods
- ✅ Include full documentation
- ✅ Validate required parameters
- ✅ Use `.code` for enum values
- ✅ Throw ArgumentError with message

### README Updates
- ✅ Use `[x\]` for implemented
- ✅ Link to protocol docs
- ✅ Include description
- ✅ Use lowercase anchor in URL

## Common Pitfalls

| Issue | Solution |
|-------|----------|
| Enum serialization fails | Add `@JsonValue()` annotations |
| Missing .g.dart files | Run build_runner |
| unnecessary_import warning | Remove redundant imports |
| constant_identifier_names | Use lowerCamelCase for enums |
| Test failures | Check JSON field names match protocol |

## Export Updates

Add to `lib/obs_websocket.dart`:
```dart
// Enums (alphabetically)
export 'src/enum/obs_new_enum.dart';

// Responses (alphabetically)
export 'src/model/response/new_response.dart';
```

## Test Checklist

- [ ] Enum code values
- [ ] Enum fromCode()
- [ ] Enum default fallback
- [ ] Enum toString()
- [ ] Response fromJson
- [ ] Response toJson
- [ ] Round-trip serialization
- [ ] Response toString contains expected values

## Verification Steps

1. ✅ Protocol documentation reviewed
2. ✅ Code follows existing patterns
3. ✅ build_runner succeeds
4. ✅ All tests pass: `dart test`
5. ✅ No analysis errors: `dart analyze`
6. ✅ README.md updated
7. ✅ Exports added
