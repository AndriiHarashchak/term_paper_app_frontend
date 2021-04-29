class DataModifier {
  static String getTimeAndDate(String time) {
    int idx = time.indexOf('T');
    if (idx < 0) return time;
    List<String> parts = [
      time.substring(0, idx).trim(),
      time.substring(idx + 1).trim()
    ];
    int index2 = parts[1].indexOf(".");

    String time2 = index2 > 0 ? parts[1].substring(0, index2).trim() : parts[1];
    String result = parts[0] + " " + time2;
    return result;
  }

  static String getDate(String time) {
    if (time == null) return "";
    int idx = time.indexOf('T');
    if (idx > 0) {
      return time.substring(0, idx);
    }
    return time;
  }
}
