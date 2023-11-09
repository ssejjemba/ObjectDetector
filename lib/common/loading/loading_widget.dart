import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EyePhoneLoading extends StatelessWidget {
  const EyePhoneLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0x4414161D),
      child: Center(
        child: Theme(
          data: ThemeData(
            cupertinoOverrideTheme:
                const CupertinoThemeData(brightness: Brightness.light),
          ),
          child: const CupertinoActivityIndicator(
            radius: 24,
          ),
        ),
      ),
    );
  }
}
