// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class SmartServicesScreen extends StatefulWidget {
  const SmartServicesScreen({super.key});
  @override
  State<SmartServicesScreen> createState() => _SmartServicesScreenState();
}

class _SmartServicesScreenState extends State<SmartServicesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _descriptionController = TextEditingController();
  DateTime? _preferredDate;
  String? _timeSlot = 'Morning (9 AM - 12 PM)';
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _serviceCategories = [
    {
      'name': 'Home Cleaning',
      'image':
          'https://images.pexels.com/photos/4239031/pexels-photo-4239031.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Plumbing',
      'image':
          'https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Electrical',
      'image':
          'https://images.pexels.com/photos/577210/pexels-photo-577210.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'AC Service',
      'image':
          'https://images.pexels.com/photos/5069416/pexels-photo-5069416.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _preferredDate = picked);
  }

  void _submitForm() async {
    final selectedCategory = _serviceCategories.firstWhere(
      (s) => s['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'serviceCategory': selectedCategory,
        'description': _descriptionController.text,
        'preferredDate': _preferredDate != null
            ? DateFormat('yyyy-MM-dd').format(_preferredDate!)
            : null,
        'timeSlot': _timeSlot,
        'budget': double.tryParse(_budgetController.text),
        'currency': _selectedCurrency,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitSmartServicesRequest(requestData);
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
        title: const Text('Smart Services'),
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
                  'Tell Us Your Service Needs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Service Category'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _serviceCategories.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _serviceCategories[index]['name'],
                      imageUrl: _serviceCategories[index]['image'],
                      isSelected: _serviceCategories[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var cat in _serviceCategories) {
                            cat['isSelected'] = false;
                          }
                          _serviceCategories[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Describe the Work'),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Leaky faucet in the kitchen',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      v!.isEmpty ? 'Please provide a description' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Date'),
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

                _buildTitle('Preferred Time Slot'),
                DropdownButtonFormField<String>(
                  value: _timeSlot,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'Morning (9 AM - 12 PM)',
                            'Afternoon (1 PM - 4 PM)',
                            'Evening (5 PM - 8 PM)',
                          ]
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _timeSlot = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Budget (optional)'),
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

                _buildTitle('Additional Notes (optional)'),
                TextFormField(
                  controller: _additionalNotesController,
                  decoration: const InputDecoration(
                    hintText: 'Any other details for the professional',
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
    _budgetController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}
