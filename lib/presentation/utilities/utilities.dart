import 'dart:async';

import 'package:flutter/material.dart';

//Debouncer to stop making unnecessary network calls
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

String convertToReleaseYear(String text) {
  String returnString = text;
  if (text.isEmpty) return "Date unknown";
  if (text != 'Release date unknown' && text != 'Air Date unknown' && text.isNotEmpty) {
    var time = DateTime.parse(text);
    returnString = time.year.toString();
  }
  return returnString;
}

String convertReleaseDate(String text) {
  String returnString = text;
  if (text.isEmpty) return "Release date unknown";
  if (text != 'Release date unknown' && text != 'Air Date unknown' && text.isNotEmpty) {
    var time = DateTime.parse(text);
    String month = "";
    switch (time.month) {
      case (1):
        month = "Jan";
        break;
      case (2):
        month = "Feb";
        break;
      case (3):
        month = "Mar";
        break;
      case (4):
        month = "Apr";
        break;
      case (5):
        month = "May";
        break;
      case (6):
        month = "June";
        break;
      case (7):
        month = "Jul";
        break;
      case (8):
        month = "Aug";
        break;
      case (9):
        month = "Sep";
        break;
      case (10):
        month = "Oct";
        break;
      case (11):
        month = "Nov";
        break;
      case (12):
        month = "Dec";
        break;
      default:
    }
    returnString = "$month ${time.day}, ${time.year}";
  }
  return returnString;
}

String convertRuntime(int runtimeInMin) {
  if (runtimeInMin < 1) {
    return "Unknown length";
  }
  int hour = runtimeInMin ~/ 60;
  int minutes = runtimeInMin % 60;
  if (hour > 0) {
    return "${hour}h ${minutes}m";
  } else {
    return "${minutes}m";
  }
}

class BuildLoaderNextPage extends StatelessWidget {
  const BuildLoaderNextPage({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

class BuildSearchProgressIndicator extends StatelessWidget {
  const BuildSearchProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

class BuildSearchErrorMessage extends StatelessWidget {
  final String errorMessage;

  const BuildSearchErrorMessage(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "☹",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const Text(
              "Try again.",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
}
