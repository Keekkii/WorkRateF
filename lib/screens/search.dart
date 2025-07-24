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
          child: Stack(
            children: [
              // Bottom navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/home.svg',
                            width: 26,
                            height: 26,
                            color: const Color(0xFF757575),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'HOME',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontFamily: 'RobotoMono',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Empty space for search button (will be positioned absolutely)
                  const SizedBox(width: 60),
                  
                  // Empty space for message button (will be positioned absolutely)
                  const SizedBox(width: 60),
                  
                  // Map Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement map navigation
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/map.svg',
                            width: 26,
                            height: 26,
                            color: const Color(0xFF757575),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'MAP',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontFamily: 'RobotoMono',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Profile Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/profile.svg',
                            width: 26,
                            height: 26,
                            color: const Color(0xFF757575),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'PROFILE',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontFamily: 'RobotoMono',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Search Button (Active with background selector)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.21,
                top: 8,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/search.svg',
                          width: 24,
                          height: 24,
                          color: const Color(0xFF1156AC),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'SEARCH',
                          style: TextStyle(
                            color: Color(0xFF1156AC),
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Message Button (Big)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.5 - 28,
                top: -14,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement message navigation
                  },
                  child: SvgPicture.asset(
                    'assets/icons/message.svg',
                    width: 56,
                    height: 56,
                  ),
                ),
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1156AC), size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Search',
              style: TextStyle(
                color: Color(0xFF1156AC),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF757575), size: 26),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF1156AC), size: 26),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                hintStyle: const TextStyle(color: Color(0xFF757575), fontSize: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          
          // Filter Sections
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Category'),
                  _buildChipList(_categories, _selectedCategory, (value) {
                    setState(() => _selectedCategory = value);
                  }),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Location'),
                  _buildChipList(_locations, _selectedLocation, (value) {
                    setState(() => _selectedLocation = value);
                  }),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Experience Level'),
                  _buildChipList(_experienceLevels, _selectedExperience, (value) {
                    setState(() => _selectedExperience = value);
                  }),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Job Type'),
                  _buildChipList(_jobTypes, _selectedJobType, (value) {
                    setState(() => _selectedJobType = value);
                  }),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Salary Range'),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _salaryRange,
                    min: 0,
                    max: 300,
                    divisions: 30,
                    activeColor: const Color(0xFF1156AC),
                    inactiveColor: const Color(0xFFF5F5F5),
                    labels: RangeLabels(
                      '\$${_salaryRange.start.round()}k',
                      '\$${_salaryRange.end.round()}k',
                    ),
                    onChanged: (values) {
                      setState(() => _salaryRange = values);
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$0k', style: TextStyle(color: Color(0xFF757575))),
                      Text('\$300k+', style: TextStyle(color: Color(0xFF757575))),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement search
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1156AC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Search Jobs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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
