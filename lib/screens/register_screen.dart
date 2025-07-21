import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_screen.dart';

const Color kBackground = Color(0xFF121515);
const Color primary = Color(0xFF1156AC);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _repeatPasswordError;

  bool _loading = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _validateEmail(String value) {
    final email = value.trim();
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!_isValidEmail(email)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateRepeatPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _repeatPasswordError = 'Please repeat your password';
      } else if (value != _passwordController.text) {
        _repeatPasswordError = 'Passwords do not match';
      } else {
        _repeatPasswordError = null;
      }
    });
  }

  bool get _canSubmit {
    return _emailError == null &&
        _passwordError == null &&
        _repeatPasswordError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _repeatPasswordController.text.isNotEmpty;
  }

  Future<void> _onConfirm() async {
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);
    _validateRepeatPassword(_repeatPasswordController.text);

    if (!_canSubmit) return;

    setState(() => _loading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = credential.user;
      if (user == null) throw 'User is null';

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            uid: user.uid,
            email: user.email!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildInput(
    String label, {
    bool obscure = false,
    TextEditingController? controller,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "RobotoMono",
            fontWeight: FontWeight.bold,
            fontSize: 17,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              color: Colors.redAccent,
              fontSize: 13,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "CREATE  YOUR  ACCOUNT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                _buildInput(
                  "E-MAIL ADDRESS",
                  controller: _emailController,
                  errorText: _emailError,
                  onChanged: _validateEmail,
                ),
                const SizedBox(height: 32),
                _buildInput(
                  "PASSWORD",
                  obscure: true,
                  controller: _passwordController,
                  errorText: _passwordError,
                  onChanged: _validatePassword,
                ),
                const SizedBox(height: 32),
                _buildInput(
                  "REPEAT PASSWORD",
                  obscure: true,
                  controller: _repeatPasswordController,
                  errorText: _repeatPasswordError,
                  onChanged: _validateRepeatPassword,
                ),
                const SizedBox(height: 36),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _onConfirm,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                Center(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    height: 56,
                    width: 56,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
