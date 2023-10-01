class OrderNumber {
  static String generateOrderNumber(String firebaseID) {
    // Generate Unix TimeStamp
    String timeStamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);

    // Get the last x characters from the firebaseID where x is length of timeStamp
    String fID = firebaseID.substring(firebaseID.length - timeStamp.length);

    // Create a new string by rearranging the timeStamp
    String rearrangedFirstString = rearrangeString(timeStamp, fID);

    return rearrangedFirstString;
  }

  static String rearrangeString(String originalString, String rearrangement) {
    String output = '';
    List<MapEntry<String, int>> indexedArray = [];

    for (int i = 0; i < rearrangement.length; i++) {
      indexedArray.add(MapEntry(rearrangement[i], i));
    }

    indexedArray.sort((a, b) => a.key.compareTo(b.key));
    List<int> indexes = indexedArray.map((entry) => entry.value).toList();

    for (int i = 0; i < originalString.length; i++) {
      output += originalString[indexes[i]];
    }

    return output;
  }
}
