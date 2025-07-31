import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';
import 'package:flutter/material.dart';

const Color kBackground = Color(0xFF18191A);
const Color primary = Color(0xFF1156AC);

class ChoosingRoleScreen extends StatefulWidget {
  const ChoosingRoleScreen({super.key});

  @override
  State<ChoosingRoleScreen> createState() => _ChoosingRoleScreenState();
}

class _ChoosingRoleScreenState extends State<ChoosingRoleScreen> {
  String? _selectedRole;
  bool _loading = false;

  Future<void> _onConfirm() async {
    if (_selectedRole == null) return;

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not found';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({"role": _selectedRole}, SetOptions(merge: true));

      if (!mounted) return;
      // Get the appropriate home page based on user role
      final homePage = await NavigationUtils.getHomePage();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => homePage),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Text(
                "ARE  YOU:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RobotoMono",
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              _RoleRadioTile(
                value: "LOOKING FOR WORK",
                groupValue: _selectedRole,
                onChanged: (v) => setState(() => _selectedRole = v),
              ),
              const SizedBox(height: 20),
              _RoleRadioTile(
                value: "LOOKING FOR WORKERS",
                groupValue: _selectedRole,
                onChanged: (v) => setState(() => _selectedRole = v),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _selectedRole == null || _loading ? null : _onConfirm,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const Spacer(flex: 3),
              Image.asset(
                'assets/icons/logo.png',
                height: 56,
                width: 56,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleRadioTile extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _RoleRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.white),
              onChanged: onChanged,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoMono",
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    height: 2,
                    color: Colors.white38,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
