extension KeyCheck on Map<dynamic, dynamic> {
  bool mapHasAllKeys(List<String> checkKeys) {
    var checkSize = checkKeys.toSet().difference(keys.toSet()).isEmpty;

    var checkLength = checkKeys.length == keys.length;

    return checkSize && checkLength;
  }
}
