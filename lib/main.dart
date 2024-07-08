import 'package:flutter/material.dart';
import 'package:todo/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.white),
          primaryColor: whiteFadeColor,
          listTileTheme: const ListTileThemeData(
              textColor: Colors.white, iconColor: Colors.white),
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: whiteFadeColor),
              centerTitle: true,
              color: Colors.grey[900],
              titleTextStyle: const TextStyle(color: whiteFadeColor)),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)
              .copyWith(background: Colors.grey[900])),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

const whiteFadeColor = Colors.white54;
