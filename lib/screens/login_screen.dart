import 'package:flutter/material.dart';
import '../services/parse_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    final response = await ParseService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _loading = false);
    if (response.success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error?.message ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Task Manager',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Student Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text("Don't have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}