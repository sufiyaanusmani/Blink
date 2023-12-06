import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

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
      padding: const EdgeInsets.only(left: 18, right: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.primaryTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
              Text(
                widget.secondaryTitle,
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          Switch(
            value: widget.switchValue,
            activeColor: ui.val(10),
            activeTrackColor: ui.val(10).withOpacity(0.7),
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
