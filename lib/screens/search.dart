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
