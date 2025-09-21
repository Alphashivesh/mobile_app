// import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class RetailShopsScreen extends StatefulWidget {
  const RetailShopsScreen({super.key});
  @override
  State<RetailShopsScreen> createState() => _RetailShopsScreenState();
}

class _RetailShopsScreenState extends State<RetailShopsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _itemDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _brandPreferenceController = TextEditingController();
  String? _itemCondition = 'New';
  final _deliveryLocationController = TextEditingController();
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _offerHoursController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _productCategories = [
    {
      'name': 'Electronics',
      'image':
          'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Apparel',
      'image':
          'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Home Goods',
      'image':
          'https://images.pexels.com/photos/6489083/pexels-photo-6489083.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Groceries',
      'image':
          'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  void _submitForm() async {
    final selectedCategory = _productCategories.firstWhere(
      (cat) => cat['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedCategory != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'productCategory': selectedCategory,
        'itemDescription': _itemDescriptionController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 1,
        'brandPreference': _brandPreferenceController.text,
        'itemCondition': _itemCondition,
        'deliveryLocation': _deliveryLocationController.text,
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'offerWithinHours': int.tryParse(_offerHoursController.text),
      };
      try {
        await _apiService.submitRetailRequest(requestData);
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
        title: const Text('Retail & Shops Requirements'),
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
                  'Tell Us Your Product Requirements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Product Category'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _productCategories.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _productCategories[index]['name'],
                      imageUrl: _productCategories[index]['image'],
                      isSelected: _productCategories[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var cat in _productCategories) {
                            cat['isSelected'] = false;
                          }
                          _productCategories[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Item Description'),
                TextFormField(
                  controller: _itemDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Describe the item you need',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please describe the item' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Quantity'),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., 2',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a quantity' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Brand Preference (optional)'),
                TextFormField(
                  controller: _brandPreferenceController,
                  decoration: const InputDecoration(
                    hintText: 'Choose a brand',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('Item Condition'),
                DropdownButtonFormField<String>(
                  value: _itemCondition,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['New', 'Used - Like New', 'Used - Good', 'Any']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _itemCondition = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Delivery Location'),
                TextFormField(
                  controller: _deliveryLocationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter city or address',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
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

                _buildTitle('Get offer within (optional)'),
                TextFormField(
                  controller: _offerHoursController,
                  decoration: const InputDecoration(
                    suffixText: 'hours',
                    helperText: 'Normal response time is within 2 days',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
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
    _itemDescriptionController.dispose();
    _quantityController.dispose();
    _brandPreferenceController.dispose();
    _deliveryLocationController.dispose();
    _budgetController.dispose();
    _offerHoursController.dispose();
    super.dispose();
  }
}
