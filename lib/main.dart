import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/Screens/Login/login.dart';

void main() {
  // runApp(const MainApp());

  DevicePreview(
     builder: (context) =>MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Login(),
        ),
      ),
    );
  }
}
