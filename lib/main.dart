import 'package:flutter/material.dart';
import 'package:mytodoapp/screens/buttom_bar.dart';
import 'package:mytodoapp/screens/setting_page.dart';
import 'package:mytodoapp/themes.dart';
import 'package:provider/provider.dart';
import 'package:mytodoapp/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: primaryTheme, // Your light theme
          darkTheme: ThemeData.dark(), // You can customize this
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: BottomBar(),
        );
      },
    );
  }
}