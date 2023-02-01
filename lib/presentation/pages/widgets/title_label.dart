import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleLabel extends StatelessWidget {
  const TitleLabel({Key? key, this.color = Colors.blue}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        AppStrings.appName,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );
}
