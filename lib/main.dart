import 'package:flutter/material.dart';
import 'package:profile_app/core/color_constants.dart';
import 'package:profile_app/view/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Profile App',
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      home: const ProfilePage(),
    );
  }
}
