// lib/screens/fitness_gym_screen.dart

// import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/cuisine_card.dart';
import '../widgets/chioce_card.dart';

class FitnessGymScreen extends StatefulWidget {
  const FitnessGymScreen({super.key});
  @override
  State<FitnessGymScreen> createState() => _FitnessGymScreenState();
}

class _FitnessGymScreenState extends State<FitnessGymScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _durationController = TextEditingController();
  String? _customerGender = 'Any';
  String? _intensityLevel = 'Intermediate';
  final _focusAreaController = TextEditingController();
  final _workoutGoalController = TextEditingController();
  final _equipmentUsedController = TextEditingController();
  final _nutritionLinkController = TextEditingController();
  final _locationController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _activityTypes = [
    {
      'name': 'Gym',
      'image':
          'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Yoga',
      'image':
          'https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Zumba',
      'image':
          'https://images.pexels.com/photos/3775578/pexels-photo-3775578.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Trainer',
      'image':
          'https://images.pexels.com/photos/3768916/pexels-photo-3768916.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  void _submitForm() async {
    final selectedActivity = _activityTypes.firstWhere(
      (a) => a['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedActivity != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'activityType': selectedActivity,
        'durationMonths': int.tryParse(_durationController.text) ?? 1,
        'customerGender': _customerGender,
        'intensityLevel': _intensityLevel,
        'focusArea': _focusAreaController.text,
        'workoutGoal': _workoutGoalController.text,
        'equipmentUsed': _equipmentUsedController.text,
        'nutritionLink': _nutritionLinkController.text,
        'location': _locationController.text,
        'specialRequests': _specialRequestsController.text,
      };
      try {
        await _apiService.submitGymRequest(requestData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.blue; // Red theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness & Gym'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Describe Your Fitness Goals',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Activity Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _activityTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _activityTypes[index]['name'],
                      imageUrl: _activityTypes[index]['image'],
                      isSelected: _activityTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var activity in _activityTypes) {
                            activity['isSelected'] = false;
                          }
                          _activityTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Duration (in months)'),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    hintText: 'choose number of month(s)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a duration' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Preference For'),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceCard(
                        text: 'Male',
                        icon: Icons.male,
                        iconColor: Colors.blue,
                        isSelected: _customerGender == 'Male',
                        onTap: () => setState(() => _customerGender = 'Male'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Female',
                        icon: Icons.female,
                        iconColor: Colors.pink,
                        isSelected: _customerGender == 'Female',
                        onTap: () => setState(() => _customerGender = 'Female'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Any',
                        icon: Icons.people,
                        iconColor: Colors.grey,
                        isSelected: _customerGender == 'Any',
                        onTap: () => setState(() => _customerGender = 'Any'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Intensity Level'),
                DropdownButtonFormField<String>(
                  value: _intensityLevel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Beginner', 'Intermediate', 'Advanced']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _intensityLevel = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Focus Area'),
                TextFormField(
                  controller: _focusAreaController,
                  decoration: const InputDecoration(
                    hintText: 'choose an area for focus',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Workout Goal'),
                TextFormField(
                  controller: _workoutGoalController,
                  decoration: const InputDecoration(
                    hintText: 'goal of workout',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Equipment Used (optional)'),
                TextFormField(
                  controller: _equipmentUsedController,
                  decoration: const InputDecoration(
                    hintText: 'select needed equipments',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Nutrition / Supplement Link (optional)'),
                TextFormField(
                  controller: _nutritionLinkController,
                  decoration: const InputDecoration(
                    hintText: 'Paste a URL if you have one',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Location'),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter city or gym name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Special Requests (optional)'),
                TextFormField(
                  controller: _specialRequestsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., allergies, injuries',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _specialRequestsController.dispose();
    _focusAreaController.dispose();
    _workoutGoalController.dispose();
    _equipmentUsedController.dispose();
    _nutritionLinkController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
