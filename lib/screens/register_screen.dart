import 'package:flutter/material.dart';

const Color kBackground = Color(0xFF121515);
const Color primary = Color(0xFF1156AC);

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                _buildInput("E-MAIL ADDRESS"),
                const SizedBox(height: 32),
                _buildInput("PASSWORD", obscure: true),
                const SizedBox(height: 32),
                _buildInput("REPEAT PASSWORD", obscure: true),
                const SizedBox(height: 36),

                // Confirm Button
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
                      onPressed: () {},
                      child: const Padding(
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
                // Logo at the bottom, no border or container
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

  Widget _buildInput(String label, {bool obscure = false}) {
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
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
