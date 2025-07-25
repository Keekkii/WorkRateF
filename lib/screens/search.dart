import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile.dart';
import '../services/location_service.dart';
import './home_page.dart' show _BottomSvgButton;

const Color primary = Color(0xFF1156AC);

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Job titles
  List<String> _jobTitles = [];
  List<String> _selectedJobTitles = [];
  
  // Selected values
  String? _selectedCategory;
  String? _selectedLocation;
  String? _selectedExperience;
  String? _selectedJobType;
  String? _selectedContractDuration;
  String? _selectedWorkSchedule;
  String? _selectedSalary;
  String? _selectedAccommodation;
  RangeValues _salaryRange = const RangeValues(0, 150);

  @override
  void initState() {
    super.initState();
    _loadJobTitles();
  }

  Future<void> _loadJobTitles() async {
    try {
      final String data = await rootBundle.loadString('assets/data/job_titles.txt');
      setState(() {
        _jobTitles = data.split('\n').where((title) => title.trim().isNotEmpty).toList();
      });
    } catch (e) {
      print('Error loading job titles: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1156AC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Color(0xFF1156AC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomSvgButton(
              svgPath: 'assets/icons/home.svg',
              label: 'HOME',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _BottomSvgButton(
              svgPath: 'assets/icons/search.svg',
              label: 'SEARCH',
              selected: true,
              isBig: true,
              onTap: () {},
            ),
            _BottomSvgButton(
              svgPath: 'assets/icons/plus.svg',
              label: 'POST',
              onTap: () {
                // TODO: Implement post screen navigation
              },
            ),
            _BottomSvgButton(
              svgPath: 'assets/icons/chat.svg',
              label: 'CHAT',
              onTap: () {
                // TODO: Implement chat screen navigation
              },
            ),
            _BottomSvgButton(
              svgPath: 'assets/icons/profile.svg',
              label: 'PROFILE',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for jobs...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF757575)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Job Title Expandable Filter
            ExpandableFilter(
              title: 'JOB TITLE:',
              options: _jobTitles,
              selectedOptions: _selectedJobTitles,
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedJobTitles = selected;
                });
              },
              isJobTitleFilter: true,
            ),
            
            const SizedBox(height: 8),
            
            // Location Expandable Filter
            ExpandableFilter(
              title: 'LOCATION:',
              options: [],
              selectedOptions: _selectedLocation != null ? [_selectedLocation!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedLocation = selected.isNotEmpty ? selected.first : null;
                });
              },
              isLocationFilter: true,
              locationService: _locationService,
            ),
            
            const SizedBox(height: 8),
            
            // Employment Type
            ExpandableFilter(
              title: 'EMPLOYMENT TYPE:',
              options: ['Full-time', 'Part-time', 'Contract', 'Freelance', 'Internship'],
              selectedOptions: _selectedJobType != null ? [_selectedJobType!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedJobType = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Contract Duration
            ExpandableFilter(
              title: 'CONTRACT DURATION:',
              options: ['Permanent', 'Temporary', '3 months', '6 months', '1 year', '2+ years'],
              selectedOptions: _selectedContractDuration != null ? [_selectedContractDuration!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedContractDuration = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Work Schedule
            ExpandableFilter(
              title: 'WORK SCHEDULE:',
              options: ['Monday-Friday', 'Weekends', 'Flexible', 'Shift work', 'Night shift'],
              selectedOptions: _selectedWorkSchedule != null ? [_selectedWorkSchedule!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedWorkSchedule = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Salary
            ExpandableFilter(
              title: 'SALARY:',
              options: ['< 5,000 HRK', '5,000 - 10,000 HRK', '10,000 - 15,000 HRK', '15,000+ HRK'],
              selectedOptions: _selectedSalary != null ? [_selectedSalary!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedSalary = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Accommodation
            ExpandableFilter(
              title: 'ACCOMMODATION:',
              options: ['Provided', 'Not provided', 'Assistance available'],
              selectedOptions: _selectedAccommodation != null ? [_selectedAccommodation!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedAccommodation = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 32),
          ],
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

class ExpandableFilter extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool isJobTitleFilter;
  final bool isLocationFilter;
  final LocationService? locationService;

  const ExpandableFilter({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.isJobTitleFilter = false,
    this.isLocationFilter = false,
    this.locationService,
  }) : super(key: key);

  @override
  _ExpandableFilterState createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredOptions = [];
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _selectedOptions = List.from(widget.selectedOptions);
    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => option.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleOption(String option) {
    setState(() {
      if (widget.isLocationFilter || widget.title.contains('EMPLOYMENT') || 
          widget.title.contains('CONTRACT') || widget.title.contains('WORK') ||
          widget.title.contains('SALARY') || widget.title.contains('ACCOMMODATION')) {
        // Single selection for location and other filters
        _selectedOptions = _selectedOptions.contains(option) ? [] : [option];
      } else {
        // Multiple selection for job titles
        if (_selectedOptions.contains(option)) {
          _selectedOptions.remove(option);
        } else {
          _selectedOptions.add(option);
        }
      }
      widget.onSelectionChanged(_selectedOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFF1156AC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                    color: const Color(0xFF1156AC),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          if (_isExpanded) ..._buildExpandedContent(),
        ],
      ),
    );
  }
  
  List<Widget> _buildExpandedContent() {
    if (widget.isLocationFilter) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TypeAheadField<String>(
            controller: TextEditingController(text: _selectedOptions.isNotEmpty ? _selectedOptions.first : ''),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Search for a city in Croatia...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.length < 2) return [];
              return await widget.locationService!.searchCities(pattern);
            },
            itemBuilder: (context, suggestion) => ListTile(
              leading: const Icon(Icons.location_city, size: 20),
              title: Text(suggestion),
            ),
            onSelected: (suggestion) {
              setState(() {
                _selectedOptions = [suggestion];
                widget.onSelectionChanged(_selectedOptions);
              });
            },
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('No locations found'),
            ),
          ),
        ),
      ];
    } else {
      return [
        // Search field for job titles and other filters
        if (widget.isJobTitleFilter)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredOptions.length,
            itemBuilder: (context, index) {
              final option = _filteredOptions[index];
              final isSelected = _selectedOptions.contains(option);
              
              return ListTile(
                title: Text(option),
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleOption(option),
                  activeColor: const Color(0xFF1156AC),
                ),
                onTap: () => _toggleOption(option),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                dense: true,
              );
            },
          ),
        ),
      ];
    }
  }
}
