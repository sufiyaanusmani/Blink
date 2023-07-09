import 'package:flutter/material.dart';
import 'package:food_delivery/components/setting_switch.dart';
import 'package:food_delivery/components/title_button.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool light = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('pressed');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Large Title',
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SettingSwitch(
                primaryTitle: 'Setting Title',
                secondaryTitle: 'Secondary line of text',
                switchValue: false,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SettingSwitch(
                primaryTitle: 'Setting Title',
                secondaryTitle: 'Secondary line of text',
                switchValue: true,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SettingSwitch(
                primaryTitle: 'Setting Title',
                secondaryTitle: 'Secondary line of text',
                switchValue: false,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Column(
                children: [
                  TitleButton(
                    title: "Title",
                    onPressed: () {
                      print('pressed');
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TitleButton(
                    title: "Title",
                    onPressed: () {
                      print('pressed');
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TitleButton(
                    title: "Title",
                    onPressed: () {
                      print('pressed');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
