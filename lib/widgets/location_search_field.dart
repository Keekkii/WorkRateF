import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/location_service.dart';

class LocationSearchField extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;
  final String? initialValue;
  final String hintText;

  const LocationSearchField({
    Key? key,
    required this.onLocationSelected,
    this.initialValue,
    this.hintText = 'Search for a location...',
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _locationController = TextEditingController();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _locationController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.location_on),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.length < 2) return [];
        return await _locationService.searchCities(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        _locationController.text = suggestion;
        widget.onLocationSelected(suggestion);
      },
      noItemsFoundBuilder: (context) => const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text('No locations found'),
      ),
    );
  }
}
