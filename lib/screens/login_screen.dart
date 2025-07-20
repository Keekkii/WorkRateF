import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';


const Color kBackground = Color(0xFF121515);
const Color primary = Color(0xFF1156AC);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepLoggedIn = false;
  bool _obscurePassword = true;
  bool _isSigningIn = false;

Future<void> _signInWithGoogle() async {
  if (Platform.isWindows) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In is not supported on Windows')),
    );
    return;
  }

  setState(() => _isSigningIn = true);

  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(); // v6.x constructor

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      setState(() => _isSigningIn = false);
      return;
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastSignIn': DateTime.now(),
      }, SetOptions(merge: true));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed in successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
  } finally {
    setState(() => _isSigningIn = false);
  }
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
                  "Sign in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please login to continue to your account.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 34),

                // Email Field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Checkbox(
                      value: _keepLoggedIn,
                      onChanged: (value) =>
                          setState(() => _keepLoggedIn = value ?? false),
                      activeColor: Colors.blue,
                    ),
                    const Text(
                      'Keep me logged in',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Sign In Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email login not implemented')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign in', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("or", style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 18),

                // Google Sign-In Button
                SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isSigningIn ? null : _signInWithGoogle,
                  icon: SvgPicture.asset(
                    'assets/icons/google-icon.svg',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      color: Colors.blue, 
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

                const SizedBox(height: 22),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Need an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Create one",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
                const SizedBox(height: 34),

                // Logo
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
