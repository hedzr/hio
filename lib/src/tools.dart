import 'dart:async';

void blockedDelay({int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 1000,
    int microseconds = 0}) async {
    return Future<void>.delayed(Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds));
}

void blockedDelay1s() async =>
    Future<void>.delayed(const Duration(milliseconds: 1000));
