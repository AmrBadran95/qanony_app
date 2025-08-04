class TimeStreamUtils {
  static Stream<bool> timeToJoinStream(DateTime sessionTime, int hoursAfter) async* {
    while (true) {
      final now = DateTime.now();
      final endTime = sessionTime.add(Duration(hours: hoursAfter));
      final isTimeToJoin = now.isAfter(sessionTime) && now.isBefore(endTime);
      yield isTimeToJoin;
      await Future.delayed(const Duration(seconds: 30));
    }
  }

  static Stream<bool> canDeleteAfterSession(DateTime sessionTime, int hoursAfter) async* {
    while (true) {
      final now = DateTime.now();
      final allowedTime = sessionTime.add(Duration(hours: hoursAfter));
      final canDelete = now.isAfter(allowedTime);
      yield canDelete;
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}
