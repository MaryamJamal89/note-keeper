class DateTimeManager {
  static String getCurrentDate() {
    DateTime currentTime = DateTime.now();
    return '${currentTime.day}-${currentTime.month}-${currentTime
        .year} ${currentTime.hour}:${currentTime.minute}';
  }
}