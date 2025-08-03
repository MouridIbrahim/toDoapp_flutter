import 'package:flutter/material.dart';
import 'package:mytodoapp/shared/styled_text.dart';
import 'package:provider/provider.dart';
import 'package:mytodoapp/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledTitle('Appearance'),
            SizedBox(height: 20),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Row(
                  children: [
                    Text('Dark Mode', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 15),
                    StyledText(themeProvider.isDarkMode ? 'on' : 'off'),
                    Spacer(),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}