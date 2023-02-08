import 'package:flutter/material.dart';

ButtonStyle kWatchedButton = ElevatedButton.styleFrom(
  foregroundColor: Colors.blue,
  backgroundColor: Colors.white,
  side: const BorderSide(
    width: 3,
    color: Colors.blue,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

ButtonStyle kNotWatchedButton = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.blue,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);
