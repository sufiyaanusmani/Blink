import 'package:flutter/material.dart';

class SettingSwitch extends StatefulWidget {
  final String primaryTitle;
  final String secondaryTitle;
  late bool switchValue;

  SettingSwitch(
      {required this.primaryTitle,
      required this.secondaryTitle,
      required this.switchValue});

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(widget.primaryTitle),
            Text(widget.secondaryTitle),
          ],
        ),
        Switch(
          value: widget.switchValue,
          onChanged: (bool value) {
            setState(() {
              widget.switchValue = value;
            });
          },
        ),
      ],
    );
  }
}
