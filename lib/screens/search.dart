import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'profile.dart';

class ExpandableFilter extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;

  const ExpandableFilter({
    Key? key,
    required this.title,
    required this.options,
    this.selectedOptions = const [],
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _ExpandableFilterState createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  late List<String> _filteredOptions;
  late List<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.from(widget.selectedOptions);
    _filteredOptions = List.from(widget.options);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(ExpandableFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedOptions != oldWidget.selectedOptions) {
      setState(() {
        _selectedOptions = List.from(widget.selectedOptions);
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
      widget.onSelectionChanged(_selectedOptions);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (!_isExpanded) {
                _searchController.clear();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: _isExpanded ? const Color(0xFF1156AC) : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _isExpanded ? Colors.white : const Color(0xFF1156AC),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                  color: _isExpanded ? Colors.white : const Color(0xFF1156AC),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        
        // Expanded content
        if (_isExpanded)
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'SEARCH...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFF1156AC),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFF1156AC),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFF1156AC),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF1156AC), size: 20),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                
                // Options list
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected = _selectedOptions.contains(option);
                      
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleOption(option),
                            activeColor: const Color(0xFF1156AC),
                            checkColor: Colors.white,
                          ),
                          onTap: () => _toggleOption(option),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedCategory;
  String? _selectedLocation;
  String? _selectedExperience;
  String? _selectedJobType;
  RangeValues _salaryRange = const RangeValues(0, 150);
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Design',
    'Development',
    'Marketing',
    'Business',
    'Photography',
  ];

  final List<String> _locations = [
    'Remote',
    'New York',
    'San Francisco',
    'London',
    'Berlin',
  ];

  final List<String> _experienceLevels = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Executive',
  ];

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
  ];

  // Job titles loaded from the asset file
  final List<String> _jobTitles = [];
  bool _isLoadingJobTitles = true;
  
  // Selected job titles
  final List<String> _selectedJobTitles = [];
  
  @override
  void initState() {
    super.initState();
    _loadJobTitles();
  }
  
  // Load job titles from the asset file
  Future<void> _loadJobTitles() async {
    try {
      final String response = await rootBundle.loadString('assets/data/job_titles.txt');
      final List<String> titles = response.split('\n').where((title) => title.trim().isNotEmpty).toList();
      setState(() {
        _jobTitles.addAll(titles);
        _isLoadingJobTitles = false;
      });
    } catch (e) {
      debugPrint('Error loading job titles: $e');
      setState(() {
        _isLoadingJobTitles = false;
      });
    }
  }
  
  // Filter options
  final List<Map<String, dynamic>> _filters = [
    {'title': 'JOB TITLE', 'isExpandable': true},
    {'title': 'LOCATION', 'isExpandable': false},
    {'title': 'EMPLOYMENT TYPE', 'isExpandable': false},
    {'title': 'CONTRACT DURATION', 'isExpandable': false},
    {'title': 'WORK SCHEDULE', 'isExpandable': false},
    {'title': 'SALARY', 'isExpandable': false},
    {'title': 'ACCOMMODATION', 'isExpandable': false},
    {'title': 'EDUCATION LEVEL', 'isExpandable': false},
    {'title': 'LANGUAGE REQUIREMENTS', 'isExpandable': false},
    {'title': 'INTERNSHIP/APPRENTICESHIP', 'isExpandable': false},
    {'title': 'INDUSTRY', 'isExpandable': false},
    {'title': 'COMPANY SIZE', 'isExpandable': false},
    {'title': 'COMPANY RATING', 'isExpandable': false},
    {'title': 'REMOTE/IN-OFFICE', 'isExpandable': false},
    {'title': 'DATE POSTED', 'isExpandable': false},
    {'title': 'BENEFITS OFFERED', 'isExpandable': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                onTap: () => Navigator.pop(context),
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/search.svg',
                label: "SEARCH",
                selected: true,
                onTap: () {},
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/message.svg',
                label: "",
                isBig: true,
                onTap: () {
                  // TODO: Implement message navigation
                },
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/map.svg',
                label: "MAP",
                onTap: () {
                  // TODO: Implement map navigation
                },
              ),
              _BottomSvgButton(
                svgPath: 'assets/icons/profile.svg',
                label: "PROFILE",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFEEEEEE),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'WORKRATE',
              style: TextStyle(
                color: Color(0xFF1156AC),
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'RobotoMono',
                letterSpacing: 2,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                hintStyle: const TextStyle(color: Color(0xFF999999)),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1156AC), size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                suffixIcon: const Icon(Icons.search, color: Color(0xFF1156AC), size: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF1156AC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF1156AC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF1156AC), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          
          // Filter List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                
                // Special case for JOB TITLE which uses the expandable filter
                if (filter['title'] == 'JOB TITLE') {
                  if (_isLoadingJobTitles) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1156AC))),
                    );
                  }
                  return ExpandableFilter(
                    title: 'JOB TITLE',
                    options: _jobTitles,
                    selectedOptions: _selectedJobTitles,
                    onSelectionChanged: (selected) {
                      setState(() {
                        _selectedJobTitles.clear();
                        _selectedJobTitles.addAll(selected);
                      });
                    },
                  );
                }
                
                // Regular filter item for all others
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  title: Text(
                    filter['title'] as String,
                    style: const TextStyle(
                      color: Color(0xFF1156AC),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1156AC), size: 16),
                  onTap: () {
                    // TODO: Handle other filter selections
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildChipList(List<String> items, String? selected, ValueChanged<String> onSelected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selected == item;
        return ChoiceChip(
          label: Text(
            item,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF757575),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          selectedColor: const Color(0xFF1156AC),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) onSelected(item);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? const Color(0xFF1156AC) : const Color(0xFFE0E0E0),
              width: isSelected ? 0 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          labelPadding: const EdgeInsets.all(0),
        );
      }).toList(),
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
    required this.onTap,
    this.selected = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF1156AC);
    
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
