import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile.dart';

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

  // Filter options
  final List<Map<String, dynamic>> _filters = [
    {'title': 'JOB TITLE', 'value': null},
    {'title': 'LOCATION', 'value': null},
    {'title': 'EMPLOYMENT TYPE', 'value': null},
    {'title': 'CONTRACT DURATION', 'value': null},
    {'title': 'WORK SCHEDULE', 'value': null},
    {'title': 'SALARY', 'value': null},
    {'title': 'ACCOMMODATION', 'value': null},
    {'title': 'EDUCATION LEVEL', 'value': null},
    {'title': 'LANGUAGE REQUIREMENTS', 'value': null},
    {'title': 'INTERNSHIP/APPRENTICESHIP', 'value': null},
    {'title': 'INDUSTRY', 'value': null},
    {'title': 'COMPANY SIZE', 'value': null},
    {'title': 'COMPANY RATING', 'value': null},
    {'title': 'REMOTE/IN-OFFICE', 'value': null},
    {'title': 'DATE POSTED', 'value': null},
    {'title': 'BENEFITS OFFERED', 'value': null},
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
                    // TODO: Handle filter selection
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
