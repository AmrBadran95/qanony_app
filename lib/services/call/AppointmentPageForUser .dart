Stream<bool> timeToJoinStream(DateTime sessionTime) async* {
  while (true) {
    final now = DateTime.now();
    final endTime = sessionTime.add(const Duration(hours: 1));
    final isTimeToJoin = now.isAfter(sessionTime) && now.isBefore(endTime);

    yield isTimeToJoin;
    await Future.delayed(const Duration(seconds: 30));
  }
}
