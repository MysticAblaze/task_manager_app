import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'TkexAtYMjh85CZb541p2HxjCxGqbVLhF2MwjvfeA';      // ← paste from Back4App
  const keyClientKey = 'nZibPxc4cqeITG5ZVijBPUM4QIOatY1oXDQZx4XF';       // ← paste from Back4App
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}