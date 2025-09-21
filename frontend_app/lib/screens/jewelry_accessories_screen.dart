// lib/screens/jewelry_accessories_screen.dart

// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class JewelryAccessoriesScreen extends StatefulWidget {
  const JewelryAccessoriesScreen({super.key});
  @override
  State<JewelryAccessoriesScreen> createState() =>
      _JewelryAccessoriesScreenState();
}

class _JewelryAccessoriesScreenState extends State<JewelryAccessoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  String? _material = 'Gold';
  final _gemstoneController = TextEditingController();
  final _sizeDetailsController = TextEditingController();
  final _customizationController = TextEditingController();
  final _designReferenceUrlController = TextEditingController();
  String? _occasion = 'Gift';
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  DateTime? _deliveryDeadline;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _itemTypes = [
    {
      'name': 'Ring',
      'image':
          'https://images.pexels.com/photos/265906/pexels-photo-265906.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Necklace',
      'image':
          'https://images.pexels.com/photos/1191531/pexels-photo-1191531.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Earrings',
      'image':
          'https://images.pexels.com/photos/2735970/pexels-photo-2735970.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Bracelet',
      'image':
          'https://images.pexels.com/photos/2849743/pexels-photo-2849743.jpeg?auto=compress&cs=tinysrgb&w=400',
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
    if (picked != null) setState(() => _deliveryDeadline = picked);
  }

  void _submitForm() async {
    final selectedItemType = _itemTypes.firstWhere(
      (item) => item['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedItemType != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'itemType': selectedItemType,
        'material': _material,
        'gemstone': _gemstoneController.text,
        'sizeDetails': _sizeDetailsController.text,
        'customizationDetails': _customizationController.text,
        'designReferenceUrl': _designReferenceUrlController.text,
        'occasion': _occasion,
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'deliveryDeadline': _deliveryDeadline != null
            ? DateFormat('yyyy-MM-dd').format(_deliveryDeadline!)
            : null,
      };
      try {
        await _apiService.submitJewelryRequest(requestData);
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
          fontSize: 16,
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
        title: const Text('Jewellery & Accessories'),
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
                  'Describe Your Jewelry Requirement',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Item Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _itemTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _itemTypes[index]['name'],
                      imageUrl: _itemTypes[index]['image'],
                      isSelected: _itemTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var item in _itemTypes) {
                            item['isSelected'] = false;
                          }
                          _itemTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Material'),
                DropdownButtonFormField<String>(
                  value: _material,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Gold', 'Silver', 'Platinum', 'Diamond', 'Artificial']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _material = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Gemstone (optional)'),
                TextFormField(
                  controller: _gemstoneController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Diamond, Ruby, Sapphire',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Size Details'),
                TextFormField(
                  controller: _sizeDetailsController,
                  decoration: const InputDecoration(
                    hintText: 'Ring size 7, Necklace length 18 inches',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter size details' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Customization Details (optional)'),
                TextFormField(
                  controller: _customizationController,
                  decoration: const InputDecoration(
                    hintText: 'Describe any specific design or customization',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                _buildTitle('Design Reference URL (optional)'),
                TextFormField(
                  controller: _designReferenceUrlController,
                  decoration: const InputDecoration(
                    hintText: 'Paste a link to a photo or sketch',
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
                            'Gift',
                            'Wedding',
                            'Anniversary',
                            'Engagement',
                            'Daily Wear',
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

                _buildTitle('Preferred Delivery Date (optional)'),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _deliveryDeadline == null
                              ? 'Select a date'
                              : DateFormat(
                                  'd MMM yyyy',
                                ).format(_deliveryDeadline!),
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
    _customizationController.dispose();
    _budgetController.dispose();
    _gemstoneController.dispose();
    _sizeDetailsController.dispose();
    _designReferenceUrlController.dispose();
    super.dispose();
  }
}
