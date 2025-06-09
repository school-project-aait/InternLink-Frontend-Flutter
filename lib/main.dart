import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/user_provider.dart'; // 🔁 adjust to match your file path
import 'package:internlink_flutter_application/features/student/presentation/screens/profile_sceen.dart'; // or MyApp if you have one

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      home: const ProfileScreen(), // or any initial screen
    );
  }
}

