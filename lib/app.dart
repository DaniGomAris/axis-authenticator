import 'package:flutter/material.dart';
import 'features/auth/presentation/initial_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Axis Authenticator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialPage(),
    );
  }
}
