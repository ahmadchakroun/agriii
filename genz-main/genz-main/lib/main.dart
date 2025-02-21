import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoser/screens/signup_screen.dart';

import 'screens/loginScreen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(
    ProviderScope( // Required for Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login", // Start with the login screen
      routes: {
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignUpScreen(), // Add route for SignUp
        "/categories": (context) => CategoriesScreen(), // Add categories screen
      },
    );
  }
}
