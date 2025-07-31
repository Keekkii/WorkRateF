import 'package:flutter/material.dart';

const Color primary = Color(0xFF1156AC);
const Color kBackground = Color(0xFFF5F5F5);

class PostAJobScreen extends StatefulWidget {
  const PostAJobScreen({Key? key}) : super(key: key);

  @override
  State<PostAJobScreen> createState() => _PostAJobScreenState();
}

class _PostAJobScreenState extends State<PostAJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _workScheduleController = TextEditingController();
  final _accommodationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _remoteController = TextEditingController();
  
  String? _selectedEmploymentType;
  String? _selectedIndustry;
  String? _selectedLanguageRequirement;
  String? _selectedExperienceLevel;
  String? _selectedEducationLevel;
  String? _selectedWorkScheduleType;
  
  final List<String> _employmentTypes = [
    'Full Time',
    'Part Time',
    'Contract',
    'Temporary',
    'Internship'
  ];
  
  final List<String> _industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Construction',
    'Hospitality',
    'Transportation',
    'Other'
  ];
  
  final List<String> _languageRequirements = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Multilingual',
    'No Requirement'
  ];
  
  final List<String> _experienceLevels = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Executive',
    'No Experience Required'
  ];
  
  final List<String> _educationLevels = [
    'High School',
    'Associate Degree',
    'Bachelor Degree',
    'Master Degree',
    'PhD',
    'Professional Certification',
    'No Requirement'
  ];
  
  final List<String> _workScheduleTypes = [
    'Full Time',
    'Part Time',
    'Flexible',
    'Shift Work'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'WORKRATE',
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'CREATE A NEW JOB',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fill out the form below to post a new job.',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Job Title
              _buildSectionTitle('JOB TITLE*'),
              _buildTextField(
                controller: _jobTitleController,
                hintText: 'Enter job title',
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              // Employment Type
              _buildSectionTitle('EMPLOYMENT TYPE*'),
              _buildDropdown(
                value: _selectedEmploymentType,
                items: _employmentTypes,
                hintText: 'Select type',
                onChanged: (value) => setState(() => _selectedEmploymentType = value),
              ),
              const SizedBox(height: 20),
              
              // Industry
              _buildSectionTitle('INDUSTRY*'),
              _buildDropdown(
                value: _selectedIndustry,
                items: _industries,
                hintText: 'Select industry',
                onChanged: (value) => setState(() => _selectedIndustry = value),
              ),
              const SizedBox(height: 20),
              
              // Contract Duration
              _buildSectionTitle('CONTRACT DURATION*'),
              _buildTextField(
                controller: _jobDescriptionController,
                hintText: 'Enter duration',
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              
              // Language Requirement
              _buildSectionTitle('LANGUAGE REQUIREMENT*'),
              _buildDropdown(
                value: _selectedLanguageRequirement,
                items: _languageRequirements,
                hintText: 'Select language',
                onChanged: (value) => setState(() => _selectedLanguageRequirement = value),
              ),
              const SizedBox(height: 20),
              
              // Experience/Apprenticeship
              _buildSectionTitle('EXPERIENCE/APPRENTICESHIP*'),
              _buildDropdown(
                value: _selectedExperienceLevel,
                items: _experienceLevels,
                hintText: 'Select level',
                onChanged: (value) => setState(() => _selectedExperienceLevel = value),
              ),
              const SizedBox(height: 20),
              
              // Job Description
              _buildSectionTitle('JOB DESCRIPTION*'),
              const Text(
                'Provide a detailed description of the job responsibilities, requirements, and qualifications.',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _jobDescriptionController,
                hintText: 'Enter job description',
                maxLines: 6,
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              // Benefits
              _buildSectionTitle('BENEFITS*'),
              _buildTextField(
                controller: _benefitsController,
                hintText: 'Select benefits',
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              
              // Remote/In-Office
              _buildSectionTitle('REMOTE/IN-OFFICE*'),
              _buildTextField(
                controller: _remoteController,
                hintText: 'Select option',
              ),
              const SizedBox(height: 20),
              
              // Location
              _buildSectionTitle('LOCATION*'),
              _buildTextField(
                controller: _locationController,
                hintText: 'Enter location',
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              // Company Name
              _buildSectionTitle('COMPANY NAME*'),
              _buildTextField(
                controller: _companyNameController,
                hintText: 'Enter company name',
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              // Work Schedule
              _buildSectionTitle('WORK SCHEDULE*'),
              _buildDropdown(
                value: _selectedWorkScheduleType,
                items: _workScheduleTypes,
                hintText: 'Select schedule',
                onChanged: (value) => setState(() => _selectedWorkScheduleType = value),
              ),
              const SizedBox(height: 20),
              
              // Accommodation
              _buildSectionTitle('ACCOMMODATION*'),
              _buildTextField(
                controller: _accommodationController,
                hintText: 'Enter accommodation details',
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              
              // Education Level
              _buildSectionTitle('EDUCATION LEVEL*'),
              _buildDropdown(
                value: _selectedEducationLevel,
                items: _educationLevels,
                hintText: 'Select level',
                onChanged: (value) => setState(() => _selectedEducationLevel = value),
              ),
              const SizedBox(height: 20),
              
              // Previous Experience
              _buildSectionTitle('PREVIOUS EXPERIENCE*'),
              _buildTextField(
                controller: _workScheduleController,
                hintText: 'Enter experience requirements',
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              
              // Salary
              _buildSectionTitle('SALARY*'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _salaryController,
                      hintText: 'Min',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: TextEditingController(),
                      hintText: 'Max',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Post Job Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _postJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'POST JOB',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 12,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
  
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        hint: Text(
          hintText,
          style: const TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  void _postJob() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'READY TO POST THIS JOB?',
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make sure you have filled out everything and review your information.',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Warning: This job will be visible to all users.',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 10,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Job posted successfully!',
                      style: TextStyle(fontFamily: 'RobotoMono'),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
              ),
              child: const Text(
                'POST JOB',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _workScheduleController.dispose();
    _accommodationController.dispose();
    _companyNameController.dispose();
    _benefitsController.dispose();
    _remoteController.dispose();
    super.dispose();
  }
}