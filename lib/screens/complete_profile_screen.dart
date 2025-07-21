import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'choosing_role.dart';

const Color kBackground = Color(0xFF18191A);
const Color primary = Color(0xFF1156AC);

class CompleteProfileScreen extends StatefulWidget {
  final String uid;
  final String email;

  const CompleteProfileScreen({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String? _selectedGender;
  bool _loading = false;

  Future<void> _saveAndNext() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final userData = {
      'uid': widget.uid,
      'email': widget.email,
      'displayName':
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      'lastSignIn': DateTime.now(),
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'dateOfBirth': {
        'day': _dayController.text.trim(),
        'month': _monthController.text.trim(),
        'year': _yearController.text.trim(),
      },
      'gender': _selectedGender ?? '',
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .set(userData, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChoosingRoleScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateText(String? value) => (value == null || value.trim().isEmpty) ? '' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              children: [
                const Text(
                  'WORKRATE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField("FIRST NAME", _firstNameController, "John", _validateText),
                _buildField("LAST NAME", _lastNameController, "Smith", _validateText),
                _buildDOBSection(),
                _buildGenderSelector(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  ),
                  onPressed: _loading ? null : _saveAndNext,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white60,
            letterSpacing: 2,
            fontFamily: "RobotoMono",
          ),
        ),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDOBSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "DATE OF BIRTH",
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontFamily: "RobotoMono",
          ),
        ),
        Row(
          children: [
            Expanded(child: _dobInput(_dayController, "DD")),
            const SizedBox(width: 12),
            Expanded(child: _dobInput(_monthController, "MM")),
            const SizedBox(width: 12),
            Expanded(child: _dobInput(_yearController, "YYYY")),
          ],
        ),
      ],
    );
  }

  Widget _dobInput(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: _validateText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "GENDER",
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontFamily: "RobotoMono",
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                value: "Male",
                groupValue: _selectedGender,
                activeColor: primary,
                onChanged: (val) => setState(() => _selectedGender = val),
                title: const Text("MALE", style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                value: "Female",
                groupValue: _selectedGender,
                activeColor: primary,
                onChanged: (val) => setState(() => _selectedGender = val),
                title: const Text("FEMALE", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
