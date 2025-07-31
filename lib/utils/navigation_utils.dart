import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/home_page_business.dart';

class NavigationUtils {
  // Get the appropriate home page based on user role
  static Future<Widget> getHomePage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If user is not logged in, return the default home page
        return const HomePage();
      }

      // Get user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // If user document doesn't exist, return default home page
        return const HomePage();
      }

      // Get user role
      final role = userDoc.data()?['role'] as String?;

      // Return appropriate home page based on role
      if (role == 'LOOKING FOR WORKERS') {
        return const HomePageBusiness();
      } else {
        // Default to regular home page for 'LOOKING FOR WORK' or any other role
        return const HomePage();
      }
    } catch (e) {
      // In case of any error, return the default home page
      return const HomePage();
    }
  }
}
