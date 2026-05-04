/// Small helper for masking secret values before they hit logs or stdout.
///
/// Not a cryptographic primitive — it simply reduces the chance that a
/// password, credential payload, or auth header appears verbatim in
/// operator-facing output.
library;

/// Known substrings whose values should be redacted in serialized output.
const _sensitiveKeys = <String>{
  'password',
  'passwd',
  'secret',
  'token',
  'authorization',
  'auth',
  'apikey',
  'api_key',
};

/// Returns `true` if [key] (case-insensitive) matches a known secret name.
bool isSensitiveKey(String key) {
  final lower = key.toLowerCase();
  return _sensitiveKeys.any(lower.contains);
}

/// Returns a copy of [map] where values whose keys look sensitive are
/// replaced with `***`.
///
/// Nested maps and lists are walked recursively. Non-[Map] / non-[List]
/// values are returned unchanged.
Object? redactSecrets(Object? value) {
  if (value is Map) {
    return <String, Object?>{
      for (final entry in value.entries)
        '${entry.key}': isSensitiveKey('${entry.key}')
            ? '***'
            : redactSecrets(entry.value),
    };
  }
  if (value is List) {
    return value.map(redactSecrets).toList();
  }
  return value;
}

/// Convenience wrapper that returns a string-safe redacted representation
/// suitable for logging.
String redactedToString(Object? value) => '${redactSecrets(value)}';
