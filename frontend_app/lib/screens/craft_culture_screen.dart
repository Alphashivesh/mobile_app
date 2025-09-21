// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class CraftCultureScreen extends StatefulWidget {
  const CraftCultureScreen({super.key});
  @override
  State<CraftCultureScreen> createState() => _CraftCultureScreenState();
}

class _CraftCultureScreenState extends State<CraftCultureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _descriptionController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _colorPreferencesController = TextEditingController();
  final _sizeOrDimensionsController = TextEditingController();
  final _quantityController = TextEditingController();
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _personalizationDetailsController = TextEditingController();
  DateTime? _preferredDate;
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _craftTypes = [
    {
      'name': 'Painting',
      'image':
          'https://images.pexels.com/photos/1269968/pexels-photo-1269968.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Pottery',
      'image':
          'https://images.pexels.com/photos/6612395/pexels-photo-6612395.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Sculpture',
      'image':
          'https://images.pexels.com/photos/236111/pexels-photo-236111.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Handicraft',
      'image':
          'https://images.pexels.com/photos/4474043/pexels-photo-4474043.jpeg?auto=compress&cs=tinysrgb&w=400',
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
    final selectedCraftType = _craftTypes.firstWhere(
      (c) => c['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedCraftType != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'craftType': selectedCraftType,
        'description': _descriptionController.text,
        'materialType': _materialTypeController.text,
        'colorPreferences': _colorPreferencesController.text,
        'sizeOrDimensions': _sizeOrDimensionsController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 1,
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'personalizationDetails': _personalizationDetailsController.text,
        'preferredDate': _preferredDate != null
            ? DateFormat('yyyy-MM-dd').format(_preferredDate!)
            : null,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitCraftRequest(requestData);
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
    const Color primaryColor = Colors.blue; // Deep Orange theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Craft & Culture'),
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
                  'Describe Your Artistic Requirement',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Type of Craft'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _craftTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _craftTypes[index]['name'],
                      imageUrl: _craftTypes[index]['image'],
                      isSelected: _craftTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var type in _craftTypes) {
                            type['isSelected'] = false;
                          }
                          _craftTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Describe Your Requirement'),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., A portrait painting, custom jewelry',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Material Type (optional)'),
                TextFormField(
                  controller: _materialTypeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Canvas, Clay, Wood',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Color Preferences (optional)'),
                TextFormField(
                  controller: _colorPreferencesController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Earth tones, vibrant colors',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Size or Dimensions (optional)'),
                TextFormField(
                  controller: _sizeOrDimensionsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., 24x36 inches, 6 feet tall',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Quantity'),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., 1',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a quantity' : null,
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

                _buildTitle('Personalization Details (optional)'),
                TextFormField(
                  controller: _personalizationDetailsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Add name "Alice", specific patterns',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
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
                    hintText: 'Any other details for the artist',
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
    _descriptionController.dispose();
    _materialTypeController.dispose();
    _colorPreferencesController.dispose();
    _sizeOrDimensionsController.dispose();
    _quantityController.dispose();
    _budgetController.dispose();
    _personalizationDetailsController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
