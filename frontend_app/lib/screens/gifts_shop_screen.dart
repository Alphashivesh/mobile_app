// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/cuisine_card.dart';
import '../widgets/chioce_card.dart';

class GiftsShopScreen extends StatefulWidget {
  const GiftsShopScreen({super.key});
  @override
  State<GiftsShopScreen> createState() => _GiftsShopScreenState();
}

class _GiftsShopScreenState extends State<GiftsShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  String? _occasion = 'Birthday';
  String? _recipientGender = 'Any';
  String? _recipientAgeGroup = 'Adult (18-60)';
  String? _recipientRelation = 'Friend';
  String? _giftCategory = 'Personalized';
  String? _priceRange = '₹1000 - ₹5000';
  final _personalizationController = TextEditingController();
  final _preferredBrandsController = TextEditingController();
  DateTime? _preferredDate;
  String? _urgencyLevel = 'Medium';
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _giftTypes = [
    {
      'name': 'Gadgets',
      'image':
          'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Fashion',
      'image':
          'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Decor',
      'image':
          'https://images.pexels.com/photos/6489083/pexels-photo-6489083.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Experiences',
      'image':
          'https://images.pexels.com/photos/3769999/pexels-photo-3769999.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _preferredDate = picked);
  }

  void _submitForm() async {
    final selectedGiftType = _giftTypes.firstWhere(
      (t) => t['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedGiftType != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'occasion': _occasion,
        'recipientGender': _recipientGender,
        'recipientAgeGroup': _recipientAgeGroup,
        'recipientRelation': _recipientRelation,
        'giftCategory': _giftCategory,
        'giftType': selectedGiftType,
        'priceRange': _priceRange,
        'currency': 'INR', // Assuming INR for price range
        'personalizationDetails': _personalizationController.text,
        'preferredBrands': _preferredBrandsController.text,
        'preferredDate': _preferredDate != null
            ? DateFormat('yyyy-MM-dd').format(_preferredDate!)
            : null,
        'urgencyLevel': _urgencyLevel,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitGiftsRequest(requestData);
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
          color: Colors.purple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gifts Shop'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.4),
              primaryColor.withOpacity(0.1),
            ],
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
                  'Tell Us Your Gifting Needs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Occasion'),
                DropdownButtonFormField<String>(
                  value: _occasion,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'Birthday',
                            'Anniversary',
                            'Wedding',
                            'Festival',
                            'Corporate',
                            'Other',
                          ]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _occasion = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Recipient Details'),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _recipientAgeGroup,
                        decoration: const InputDecoration(
                          labelText: 'Age Group',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items:
                            [
                                  'Child (0-12)',
                                  'Teen (13-17)',
                                  'Adult (18-60)',
                                  'Senior (60+)',
                                ]
                                .map(
                                  (label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) =>
                            setState(() => _recipientAgeGroup = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _recipientRelation,
                        decoration: const InputDecoration(
                          labelText: 'Relation',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items:
                            [
                                  'Friend',
                                  'Spouse',
                                  'Parent',
                                  'Sibling',
                                  'Colleague',
                                ]
                                .map(
                                  (label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) =>
                            setState(() => _recipientRelation = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceCard(
                        text: 'Male',
                        icon: Icons.male,
                        iconColor: Colors.blue,
                        isSelected: _recipientGender == 'Male',
                        onTap: () => setState(() => _recipientGender = 'Male'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Female',
                        icon: Icons.female,
                        iconColor: Colors.pink,
                        isSelected: _recipientGender == 'Female',
                        onTap: () =>
                            setState(() => _recipientGender = 'Female'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Any',
                        icon: Icons.people,
                        iconColor: Colors.grey,
                        isSelected: _recipientGender == 'Any',
                        onTap: () => setState(() => _recipientGender = 'Any'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Gift Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _giftTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _giftTypes[index]['name'],
                      imageUrl: _giftTypes[index]['image'],
                      isSelected: _giftTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var type in _giftTypes) {
                            type['isSelected'] = false;
                          }
                          _giftTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Gift Category'),
                DropdownButtonFormField<String>(
                  value: _giftCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'Personalized',
                            'Gadgets',
                            'Decor',
                            'Fashion',
                            'Gourmet',
                            'Experiences',
                          ]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _giftCategory = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Price Range'),
                DropdownButtonFormField<String>(
                  value: _priceRange,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'Under ₹1000',
                            '₹1000 - ₹5000',
                            '₹5000 - ₹10000',
                            'Above ₹10000',
                          ]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _priceRange = value),
                  validator: (v) =>
                      v == null ? 'Please select a price range' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Personalization Details (optional)'),
                TextFormField(
                  controller: _personalizationController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Name to engrave, special message',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Brands (optional)'),
                TextFormField(
                  controller: _preferredBrandsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Apple, Tanishq',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Urgency Level'),
                DropdownButtonFormField<String>(
                  value: _urgencyLevel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Low', 'Medium', 'High']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _urgencyLevel = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Delivery Date'),
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
                          _preferredDate == null
                              ? 'Select a date'
                              : DateFormat(
                                  'd MMM yyyy',
                                ).format(_preferredDate!),
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

                _buildTitle('Additional Notes (optional)'),
                TextFormField(
                  controller: _additionalNotesController,
                  decoration: const InputDecoration(
                    hintText: 'Any other details',
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
    _personalizationController.dispose();
    _preferredBrandsController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
