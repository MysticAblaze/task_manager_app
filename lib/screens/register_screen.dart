import 'package:flutter/material.dart';
import '../services/parse_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _register() async {
    setState(() => _loading = true);
    final response = await ParseService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _loading = false);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered! Please login.')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error?.message ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}