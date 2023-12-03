import 'package:flutter/material.dart';

class SettingSwitch extends StatefulWidget {
  final String primaryTitle;
  final String secondaryTitle;
  late bool switchValue;

  SettingSwitch(
      {super.key,
      required this.primaryTitle,
      required this.secondaryTitle,
      required this.switchValue});

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.primaryTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              Text(widget.secondaryTitle),
            ],
          ),
          Switch(
            value: widget.switchValue,
            activeColor: Colors.orangeAccent,
            activeTrackColor: Colors.orange,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade600,
            onChanged: (bool value) {
              setState(() {
                widget.switchValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
