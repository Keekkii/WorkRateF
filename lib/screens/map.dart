import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workrate/screens/profile.dart';
import 'package:workrate/screens/search.dart';
import 'package:workrate/screens/home_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  String _currentAddress = 'Loading...';
  int _selectedIndex = 2; // Map is selected in bottom nav
  bool _isLoading = true;
  String? _errorMessage;
  double _zoom = 13.0;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    // Clean up any controllers if needed
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      debugPrint('Checking location services...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services are disabled.\nPlease enable them in your device settings.';
        });
        return;
      }

      debugPrint('Checking location permissions...');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions were denied');
          setState(() {
            _isLoading = false;
            _errorMessage = 'Location permission denied.\nPlease enable it in app settings.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permissions are permanently denied.\nPlease enable them in app settings.';
        });
        return;
      }

      debugPrint('Getting current position...');
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 10));
        
        debugPrint('Got position: ${position.latitude}, ${position.longitude}');
        
        await _getAddressFromLatLng(position.latitude, position.longitude);
        
        final newPosition = LatLng(position.latitude, position.longitude);
        
        setState(() {
          _currentPosition = newPosition;
          _isLoading = false;
        });
        
        // Only try to move the map if it's ready
        if (_isMapReady) {
          _mapController.move(newPosition, _zoom);
        }
        
      } on TimeoutException {
        debugPrint('Timeout getting location');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not get location.\nPlease check your internet connection and try again.';
        });
        return;
      }
      
    } on TimeoutException catch (e) {
      debugPrint('Timeout getting location: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Timeout getting location.\nPlease try again.';
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: ${e.toString()}';
      });
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MAP',
          style: TextStyle(
            color: Color(0xFF1156AC),
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1156AC)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _getCurrentLocation();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildMapScreen(),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: const Color(0xFFEEEEEE),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomSvgButton(
                svgPath: 'assets/icons/home.svg', 
                label: "HOME",
                onTap: () {
                  // Navigate to home if not already there
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  }
                }
              ),
              _BottomSvgButton(svgPath: 'assets/icons/search.svg', label: "SEARCH", onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              }),
              _BottomSvgButton(svgPath: 'assets/icons/message.svg', label: "", isBig: true, onTap: () {
                // Handle message button tap
              }),
              _BottomSvgButton(
                svgPath: 'assets/icons/map.svg', 
                label: "MAP",
                selected: true,
                onTap: () {}
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/profile.svg', 
                label: "PROFILE",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapScreen() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition ?? const LatLng(45.1, 15.2), // Default to Croatia center
            initialZoom: _zoom,
            onMapReady: () {
              setState(() {
                _isMapReady = true;
              });
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, _zoom);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.workrate',
            ),
            if (_currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Color(0xFF1156AC),
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _currentAddress,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 20,
          child: FloatingActionButton(
            onPressed: _getCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Color(0xFF1156AC)),
          ),
        ),
      ],
    );
  }
}

class _BottomSvgButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool selected;
  final bool isBig;
  final VoidCallback onTap;

  const _BottomSvgButton({
    required this.svgPath,
    required this.label,
    this.selected = false,
    this.isBig = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                color: const Color(0xFF1156AC),
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
