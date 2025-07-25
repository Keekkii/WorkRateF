import 'dart:async';
import 'package:flutter/services.dart';

class LocationService {
  static Future<List<String>> loadCroatianCities() async {
    try {
      print('Loading Croatian cities from HR.txt...');
      // Load the HR.txt file
      final String response = await rootBundle.loadString('assets/data/HR.txt');
      
      // Split the file into lines
      final List<String> lines = response.split('\n');
      print('Loaded ${lines.length} lines from HR.txt');
      
      // Set to store unique city names
      final Set<String> cities = {};
      int processedCount = 0;
      
      // Process each line
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        
        final parts = line.split('\t');
        if (parts.length < 8) continue; // Ensure we have enough columns
        
        final featureClass = parts[6]; // Feature class is at index 6
        final cityName = parts[1]; // City name is at index 1 (name)
        
        // Only include populated places (P) and ensure the name is not empty
        if (featureClass == 'P' && cityName.isNotEmpty) {
          cities.add(cityName);
          processedCount++;
          if (processedCount % 100 == 0) {
            print('Processed $processedCount cities...');
          }
        }
      }
      
      // Convert to list and sort alphabetically
      final sortedCities = cities.toList()..sort((a, b) => a.compareTo(b));
      print('Successfully loaded ${sortedCities.length} unique cities');
      return sortedCities;
    } catch (e, stackTrace) {
      // In case of error, return an empty list
      print('Error loading cities: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  // Cache for cities to avoid reloading the file
  static List<String>? _cachedCities;

  // Filter cities based on search input
  Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];
    
    try {
      print('Searching for cities with query: $query');
      
      // Use cached cities if available, otherwise load them
      if (_cachedCities == null) {
        print('Loading cities for the first time...');
        _cachedCities = await loadCroatianCities();
        print('Finished loading ${_cachedCities!.length} cities');
      }
      
      final lowercaseQuery = query.toLowerCase();
      final results = _cachedCities!
          .where((city) => city.toLowerCase().contains(lowercaseQuery))
          .toList();
          
      print('Found ${results.length} matching cities for query: $query');
      return results.take(20).toList(); // Limit to 20 results for performance
    } catch (e, stackTrace) {
      print('Error searching cities: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}
