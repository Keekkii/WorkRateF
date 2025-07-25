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
  String? _selectedEducationLevel;
  String? _selectedLanguage;
  String? _selectedInternshipType;
  String? _selectedIndustry;
  String? _selectedCompanySize;
  String? _selectedCompanyRating;
  String? _selectedWorkLocation;
  String? _selectedDatePosted;
  List<String> _selectedBenefits = [];
  List<String> _selectedSalaryFrequencies = [];
  RangeValues _hourlyPayRange = const RangeValues(6.06, 101.5);

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
        automaticallyImplyLeading: false, // This removes the back button
        title: const Text(
          "WORKRATE",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'RobotoMono',
            fontSize: 27,
            letterSpacing: 2,
            color: Color(0xFF1156AC),
          ),
        ),
        centerTitle: true, // This centers the title
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFEEEEEE),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                onTap: () {},
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/message.svg',
                label: '',
                isBig: true,
                onTap: () {
                  // TODO: Implement chat screen navigation
                },
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/map.svg',
                label: 'MAP',
                onTap: () {
                  // TODO: Implement map screen navigation
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
              options: ['Full Time', 'Part Time', 'One Time', 'Freelance'],
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
              options: ['Permanent', 'Temporary', 'Seasonal', 'Project-based', 'As-needed'],
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
              options: ['Standard Hours', 'Non-standard Hours', 'Flexible', 'Shift-based'],
              selectedOptions: _selectedWorkSchedule != null ? [_selectedWorkSchedule!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedWorkSchedule = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Salary Filter with Frequency and Hourly Pay
            ExpandableFilter(
              title: 'SALARY:',
              options: const ['Weekly', 'Bi-Weekly', 'Monthly', 'Commission-Based'],
              selectedOptions: _selectedSalaryFrequencies,
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedSalaryFrequencies = selected;
                });
              },
              customContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'HOURLY PAY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _hourlyPayRange,
                    min: 0,
                    max: 150,
                    divisions: 100,
                    labels: RangeLabels(
                      '${_hourlyPayRange.start.toStringAsFixed(2)}€',
                      '${_hourlyPayRange.end.toStringAsFixed(2)}€',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _hourlyPayRange = values;
                      });
                    },
                    activeColor: const Color(0xFF1156AC),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_hourlyPayRange.start.toStringAsFixed(2)}€'),
                        Text('${_hourlyPayRange.end.toStringAsFixed(2)}€'),
                      ],
                    ),
                  ),
                ],
              ),
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
            
            const SizedBox(height: 8),
            
            // Education Level
            ExpandableFilter(
              title: 'EDUCATION LEVEL:',
              options: ['High School', 'Associate Degree', "Bachelor's Degree", "Master's Degree", 'PhD', 'No Formal Education Required'],
              selectedOptions: _selectedEducationLevel != null ? [_selectedEducationLevel!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedEducationLevel = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Language Requirements
            ExpandableFilter(
              title: 'LANGUAGE REQUIREMENTS:',
              options: ['English', 'German', 'Croatian', 'Italian', 'French', 'Spanish'],
              selectedOptions: _selectedLanguage != null ? [_selectedLanguage!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedLanguage = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Internship/Apprenticeship
            ExpandableFilter(
              title: 'INTERNSHIP/APPRENTICESHIP:',
              options: ['Internship', 'Apprenticeship', 'Both', 'Not specified'],
              selectedOptions: _selectedInternshipType != null ? [_selectedInternshipType!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedInternshipType = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Industry
            ExpandableFilter(
              title: 'INDUSTRY:',
              options: ['IT', 'Healthcare', 'Finance', 'Education', 'Retail', 'Manufacturing', 'Hospitality', 'Other'],
              selectedOptions: _selectedIndustry != null ? [_selectedIndustry!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedIndustry = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Company Size
            ExpandableFilter(
              title: 'COMPANY SIZE:',
              options: ['1-10 employees', '11-50 employees', '51-200 employees', '201-1000 employees', '1000+ employees'],
              selectedOptions: _selectedCompanySize != null ? [_selectedCompanySize!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedCompanySize = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Company Rating
            ExpandableFilter(
              title: 'COMPANY RATING:',
              options: ['4.0+', '3.5+', '3.0+', '2.5+', '2.0+', 'No minimum rating'],
              selectedOptions: _selectedCompanyRating != null ? [_selectedCompanyRating!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedCompanyRating = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Remote/In-Office
            ExpandableFilter(
              title: 'REMOTE/IN-OFFICE:',
              options: ['Remote', 'On-site', 'Hybrid', 'Flexible'],
              selectedOptions: _selectedWorkLocation != null ? [_selectedWorkLocation!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedWorkLocation = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Date Posted
            ExpandableFilter(
              title: 'DATE POSTED:',
              options: ['Last 24 hours', 'Last 3 days', 'Last week', 'Last 2 weeks', 'Last month', 'Any time'],
              selectedOptions: _selectedDatePosted != null ? [_selectedDatePosted!] : [],
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedDatePosted = selected.isNotEmpty ? selected.first : null;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            // Benefits Offered
            ExpandableFilter(
              title: 'BENEFITS OFFERED:',
              options: ['Health insurance', 'Dental insurance', 'Paid time off', 'Retirement plan', 'Flexible schedule', 'Professional development', 'Gym membership', 'Free food'],
              selectedOptions: _selectedBenefits,
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedBenefits = selected;
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
  final Widget? customContent;

  const ExpandableFilter({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.isJobTitleFilter = false,
    this.isLocationFilter = false,
    this.locationService,
    this.customContent,
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            '${widget.title} ${_selectedOptions.isNotEmpty && !widget.title.contains('SALARY') ? '(${_selectedOptions.join(', ')})' : ''}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            if (widget.isJobTitleFilter || widget.isLocationFilter)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.title.toLowerCase().replaceAll(':', '')}',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            
            if (widget.customContent != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: widget.customContent!,
              ),
            
            if (widget.options.isNotEmpty)
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
          ],
        ),
      ),
    );
  }
}
