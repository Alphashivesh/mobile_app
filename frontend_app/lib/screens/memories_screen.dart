// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});
  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  String? _eventType = 'Wedding';
  DateTime? _eventDate;
  final _locationController = TextEditingController();
  final _themeController = TextEditingController();
  final _guestCountController = TextEditingController();
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _photographerController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _mediaTypes = [
    {
      'name': 'Photography',
      'image':
          'https://images.pexels.com/photos/3783471/pexels-photo-3783471.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Videography',
      'image':
          'https://images.pexels.com/photos/4057753/pexels-photo-4057753.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Drone Shots',
      'image':
          'https://images.pexels.com/photos/1034859/pexels-photo-1034859.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Both Photo & Video',
      'image':
          'https://images.pexels.com/photos/337909/pexels-photo-337909.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  void _submitForm() async {
    final selectedMediaType = _mediaTypes.firstWhere(
      (c) => c['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedMediaType != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'eventType': _eventType,
        'serviceType': selectedMediaType,
        'eventDate': _eventDate != null
            ? DateFormat('yyyy-MM-dd').format(_eventDate!)
            : null,
        'location': _locationController.text,
        'themeOrMood': _themeController.text,
        'guestCount': int.tryParse(_guestCountController.text),
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'preferredPhotographer': _photographerController.text,
        'mediaTypes': selectedMediaType,
        'specialRequests': _specialRequestsController.text,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitMemoriesRequest(requestData);
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
    const Color primaryColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories (Photo & Video)'),
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
                  'Tell Us Your Photography Needs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Type of Service'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _mediaTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _mediaTypes[index]['name'],
                      imageUrl: _mediaTypes[index]['image'],
                      isSelected: _mediaTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var type in _mediaTypes) {
                            type['isSelected'] = false;
                          }
                          _mediaTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Event Type'),
                DropdownButtonFormField<String>(
                  value: _eventType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'Wedding',
                            'Birthday',
                            'Corporate Event',
                            'Family Gathering',
                            'Fashion Shoot',
                            'Product Shoot',
                            'Other',
                          ]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _eventType = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Event Date'),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _eventDate == null
                              ? 'Select a date'
                              : DateFormat('d MMM yyyy').format(_eventDate!),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: primaryColor,
                      ),
                      onPressed: _selectDate,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Event Location / City'),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Goa, India',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter a location' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Theme or Mood (optional)'),
                TextFormField(
                  controller: _themeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Candid, Natural, Vintage',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Approximate Guest Count'),
                TextFormField(
                  controller: _guestCountController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., 200',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter guest count' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Photographer (optional)'),
                TextFormField(
                  controller: _photographerController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name if you have a preference',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Budget'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _budgetController,
                        decoration: const InputDecoration(
                          hintText: 'Enter amount',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter an amount'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: currencies
                            .map(
                              (currency) => DropdownMenuItem(
                                value: currency['code'],
                                child: Text(
                                  "${currency['code']} (${currency['symbol']})",
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCurrency = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Special Requests (optional)'),
                TextFormField(
                  controller: _specialRequestsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., need pre-wedding shoot',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                _buildTitle('Additional Notes (optional)'),
                TextFormField(
                  controller: _additionalNotesController,
                  decoration: const InputDecoration(
                    hintText: 'Any other details for the vendor',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
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
    _locationController.dispose();
    _themeController.dispose();
    _guestCountController.dispose();
    _budgetController.dispose();
    _photographerController.dispose();
    _specialRequestsController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
