import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

const Color primary = Color(0xFF1156AC);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Helper method to safely parse integer values from Firestore
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  Future<void> _fetchUserData() async {
    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        currentUserId = currentUser.uid;
        
        // Create default data from Firebase Auth first
        Map<String, dynamic> defaultData = {
          'name': currentUser.displayName ?? currentUser.email?.split('@')[0] ?? 'User',
          'email': currentUser.email ?? 'No email',
          'profileImageUrl': currentUser.photoURL,
          'about': 'No description available.',
        };
        
        try {
          // Try to fetch user data from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          
          if (userDoc.exists && userDoc.data() != null) {
            // Merge Firestore data with default data
            Map<String, dynamic> firestoreData = userDoc.data() as Map<String, dynamic>;
            setState(() {
              userData = {
                ...defaultData,
                ...firestoreData, // Firestore data overrides defaults
              };
              isLoading = false;
            });
          } else {
            // No Firestore document, use default data
            setState(() {
              userData = defaultData;
              isLoading = false;
            });
          }
        } catch (firestoreError) {
          // Firestore error, use default data
          print('Firestore error: $firestoreError');
          setState(() {
            userData = defaultData;
            isLoading = false;
          });
        }
      } else {
        // No user logged in, redirect to login
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      print('General error fetching user data: $e');
      setState(() {
        isLoading = false;
        userData = {
          'name': 'Error loading data',
          'email': 'Error loading email',
          'about': 'Error loading description.',
        };
      });
    }
  }

  int _calculateAge() {
    if (userData == null) {
      print('userData is null');
      return 0;
    }
    
    // Debug logging
    print('User data keys: ${userData!.keys.toList()}');
    
    // Check both possible field names for date of birth
    final dateOfBirth = userData!['date_of_birth'] ?? userData!['dateOfBirth'];
    print('dateOfBirth value: $dateOfBirth');
    print('dateOfBirth runtimeType: ${dateOfBirth?.runtimeType}');
    
    if (dateOfBirth == null) {
      print('No date of birth found in user data');
      return 0;
    }
    
    try {
      // Handle Map format: {month: 11, year: 2004, day: 26}
      if (dateOfBirth is Map<String, dynamic>) {
        // Safely parse values that might be either String or int
        final month = _parseInt(dateOfBirth['month']);
        final year = _parseInt(dateOfBirth['year']);
        final day = _parseInt(dateOfBirth['day']);
        
        print('Parsed date - year: $year, month: $month, day: $day');
        
        if (month != null && year != null && day != null) {
          final birthDate = DateTime(year, month, day);
          final now = DateTime.now();
          int age = now.year - birthDate.year;
          if (now.month < birthDate.month || 
              (now.month == birthDate.month && now.day < birthDate.day)) {
            age--;
          }
          return age > 0 ? age : 0;
        }
      }
      // Handle Timestamp format
      else if (dateOfBirth is Timestamp) {
        final birthDate = dateOfBirth.toDate();
        final now = DateTime.now();
        int age = now.year - birthDate.year;
        if (now.month < birthDate.month || 
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }
        return age > 0 ? age : 0;
      }
      // Handle String format (dd/MM/yyyy or ISO 8601)
      else if (dateOfBirth is String) {
        // Try parsing 'dd/MM/yyyy' format
        if (dateOfBirth.contains('/')) {
          final parts = dateOfBirth.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            
            if (day != null && month != null && year != null) {
              final birthDate = DateTime(year, month, day);
              final now = DateTime.now();
              int age = now.year - birthDate.year;
              if (now.month < birthDate.month || 
                  (now.month == birthDate.month && now.day < birthDate.day)) {
                age--;
              }
              return age > 0 ? age : 0;
            }
          }
        }
        
        // Fallback to ISO 8601 format (e.g., '2000-12-31')
        final birthDate = DateTime.tryParse(dateOfBirth);
        if (birthDate != null) {
          final now = DateTime.now();
          int age = now.year - birthDate.year;
          if (now.month < birthDate.month || 
              (now.month == birthDate.month && now.day < birthDate.day)) {
            age--;
          }
          return age > 0 ? age : 0;
        }
      }
      
      print('Could not parse date of birth: $dateOfBirth (${dateOfBirth.runtimeType})');
      return 0;
    } catch (e) {
      print('Error calculating age: $e');
      return 0;
    }
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Settings title
              Text(
                'SETTINGS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontFamily: 'RobotoMono',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Settings options
              _buildSettingsOption(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to edit profile
                },
              ),
              _buildSettingsOption(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to notifications settings
                },
              ),
              _buildSettingsOption(
                icon: Icons.security_outlined,
                title: 'Privacy & Security',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to privacy settings
                },
              ),
              _buildSettingsOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to help
                },
              ),
              _buildSettingsOption(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to about
                },
              ),
              _buildSettingsOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmation(context);
                },
                isDestructive: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Clear any stored user data here (SharedPreferences, etc.)
    // For now, we'll just navigate to login screen
    
    // Navigate to login screen and clear all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : primary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
          fontFamily: 'RobotoMono',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            )
          : SafeArea(
        child: Column(
          children: [
            // Top section with hamburger menu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showSettingsBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Profile image with notification badge
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: userData?['profileImageUrl'] != null
                                ? NetworkImage(userData!['profileImageUrl'])
                                : null,
                            child: userData?['profileImageUrl'] == null
                                ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                                : null,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _calculateAge().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name
                      Text(
                        userData?['name'] ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Email
                      Text(
                        userData?['email'] ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // About Me section
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABOUT ME',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary,
                                fontFamily: 'RobotoMono',
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 80,
                              color: primary,
                              margin: const EdgeInsets.only(top: 4, bottom: 16),
                            ),
                            Text(
                              userData?['about'] ?? 'No description available.',
                              style: TextStyle(
                                fontSize: 14,
                                color: primary,
                                fontFamily: 'RobotoMono',
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Previous Work Experience button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to work experience screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'PREVIOUS WORK EXPERIENCE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoMono',
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // My Work Reviews button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to work reviews screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'MY WORK REVIEWS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoMono',
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Your Posts section
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR POSTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary,
                                fontFamily: 'RobotoMono',
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 100,
                              color: primary,
                              margin: const EdgeInsets.only(top: 4, bottom: 16),
                            ),
                            // Posts grid
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: Color(0xFFEEEEEE),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomSvgButton(svgPath: 'assets/icons/home.svg', label: "HOME"),
              _BottomSvgButton(svgPath: 'assets/icons/search.svg', label: "SEARCH"),
              _BottomSvgButton(svgPath: 'assets/icons/message.svg', label: "", isBig: true),
              _BottomSvgButton(svgPath: 'assets/icons/map.svg', label: "MAP"),
              _BottomSvgButton(svgPath: 'assets/icons/profile.svg', label: "PROFILE", selected: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSvgButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool selected;
  final bool isBig;

  const _BottomSvgButton({
    required this.svgPath,
    required this.label,
    this.selected = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "HOME") {
          Navigator.pop(context); // Go back to home
        }
        // TODO: Add navigation for other tabs
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: isBig ? const Offset(0, -30) : Offset.zero,
            child: SizedBox(
              width: isBig ? 100 : 36,
              height: isBig ? 100 : 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (selected)
                    SvgPicture.asset(
                      'assets/icons/backgroundselector.svg',
                      width: isBig ? 100 : 36,
                      height: isBig ? 100 : 36,
                    ),
                  SvgPicture.asset(
                    svgPath,
                    width: isBig ? 80 : 26,
                    height: isBig ? 80 : 26,
                  ),
                ],
              ),
            ),
          ),
          if (label.isNotEmpty)
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primary,
                fontFamily: "RobotoMono",
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: selected ? 1.2 : 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
