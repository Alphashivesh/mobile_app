// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';
import '../widgets/chioce_card.dart';

class FashionBoutiquesScreen extends StatefulWidget {
  const FashionBoutiquesScreen({super.key});
  @override
  State<FashionBoutiquesScreen> createState() => _FashionBoutiquesScreenState();
}

class _FashionBoutiquesScreenState extends State<FashionBoutiquesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _fabricTypeController = TextEditingController();
  final _patternController = TextEditingController();
  final _brandPreferenceController = TextEditingController();
  String? _gender = 'Any';
  String? _occasion = 'Daily Wear';
  String? _occasionType = 'Casual';
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  DateTime? _preferredDate;
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _clothingTypes = [
    {
      'name': 'Ethnic Wear',
      'image':
          'https://images.pexels.com/photos/1154861/pexels-photo-1154861.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Formal Wear',
      'image':
          'https://images.pexels.com/photos/210552/pexels-photo-210552.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Casual Wear',
      'image':
          'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Party Wear',
      'image':
          'https://images.pexels.com/photos/1126993/pexels-photo-1126993.jpeg?auto=compress&cs=tinysrgb&w=400',
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
    final selectedClothingType = _clothingTypes.firstWhere(
      (c) => c['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedClothingType != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'clothingType': selectedClothingType,
        'size': _sizeController.text,
        'colorPreference': _colorController.text,
        'fabricType': _fabricTypeController.text,
        'patternOrStyle': _patternController.text,
        'brandPreference': _brandPreferenceController.text,
        'gender': _gender,
        'occasion': _occasion,
        'occasionType': _occasionType,
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'preferredDate': _preferredDate != null
            ? DateFormat('yyyy-MM-dd').format(_preferredDate!)
            : null,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitFashionRequest(requestData);
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
    const Color primaryColor = Colors.blue; // Cyan theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashion Boutiques'),
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
                  'Tell Us Your Fashion Needs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Clothing Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _clothingTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _clothingTypes[index]['name'],
                      imageUrl: _clothingTypes[index]['image'],
                      isSelected: _clothingTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var type in _clothingTypes) {
                            type['isSelected'] = false;
                          }
                          _clothingTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Gender'),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceCard(
                        text: 'Male',
                        icon: Icons.male,
                        iconColor: Colors.blue,
                        isSelected: _gender == 'Male',
                        onTap: () => setState(() => _gender = 'Male'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Female',
                        icon: Icons.female,
                        iconColor: Colors.pink,
                        isSelected: _gender == 'Female',
                        onTap: () => setState(() => _gender = 'Female'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Any',
                        icon: Icons.people,
                        iconColor: Colors.grey,
                        isSelected: _gender == 'Any',
                        onTap: () => setState(() => _gender = 'Any'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Size'),
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., M, L, 42',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter a size' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Color Preference'),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Blue, Floral pattern',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter a color preference' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Fabric Type (optional)'),
                TextFormField(
                  controller: _fabricTypeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Cotton, Silk',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Pattern or Style (optional)'),
                TextFormField(
                  controller: _patternController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., A-line, Modern, Minimalist',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Brand Preference (optional)'),
                TextFormField(
                  controller: _brandPreferenceController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Gucci, Zara',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

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
                            'Daily Wear',
                            'Wedding',
                            'Party',
                            'Formal Event',
                            'Holiday',
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

                _buildTitle('Occasion Type'),
                DropdownButtonFormField<String>(
                  value: _occasionType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Casual', 'Semi-Formal', 'Formal', 'Traditional']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _occasionType = value),
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

                _buildTitle('Preferred Date (optional)'),
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
    _sizeController.dispose();
    _colorController.dispose();
    _fabricTypeController.dispose();
    _patternController.dispose();
    _brandPreferenceController.dispose();
    _budgetController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
