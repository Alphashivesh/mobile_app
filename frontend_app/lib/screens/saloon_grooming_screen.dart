// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/cuisine_card.dart';
import '../widgets/chioce_card.dart';

class SaloonGroomingScreen extends StatefulWidget {
  const SaloonGroomingScreen({super.key});
  @override
  State<SaloonGroomingScreen> createState() => _SaloonGroomingScreenState();
}

class _SaloonGroomingScreenState extends State<SaloonGroomingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;
  String? _customerGender = 'Any';
  String? _stylistPreference = 'Any';
  final _budgetController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _serviceTypes = [
    {
      'name': 'Haircut',
      'image':
          'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': true,
    },
    {
      'name': 'Facial',
      'image':
          'https://images.pexels.com/photos/3762873/pexels-photo-3762873.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Manicure',
      'image':
          'https://images.pexels.com/photos/3997388/pexels-photo-3997388.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Massage',
      'image':
          'https://images.pexels.com/photos/4389667/pexels-photo-4389667.jpeg?auto=compress&cs=tinysrgb&w=400',
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
    if (picked != null && picked != _preferredDate) {
      setState(() => _preferredDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _preferredTime) {
      setState(() => _preferredTime = picked);
    }
  }

  void _submitForm() async {
    final selectedService = _serviceTypes.firstWhere(
      (s) => s['isSelected'] == true,
      orElse: () => {'name': null},
    )['name'];

    if (_formKey.currentState!.validate() && selectedService != null) {
      setState(() {
        _isLoading = true;
      });
      final requestData = {
        'serviceType': selectedService,
        'preferredDate': _preferredDate != null
            ? DateFormat('yyyy-MM-dd').format(_preferredDate!)
            : null,
        'preferredTime': _preferredTime?.format(context),
        'customerGender': _customerGender,
        'stylistPreference': _stylistPreference,
        'budget': double.tryParse(_budgetController.text),
        'specialRequests': _specialRequestsController.text,
      };
      try {
        await _apiService.submitSaloonRequest(requestData);
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
        title: const Text('Salons & Grooming'),
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
                  'Tell Us Your Grooming Needs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTitle('Service Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _serviceTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _serviceTypes[index]['name'],
                      imageUrl: _serviceTypes[index]['image'],
                      isSelected: _serviceTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var service in _serviceTypes) {
                            service['isSelected'] = false;
                          }
                          _serviceTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Preferred Date & Time'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _preferredDate == null
                                  ? 'Select a date'
                                  : DateFormat(
                                      'd MMM yyyy',
                                    ).format(_preferredDate!),
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
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _preferredTime == null
                                  ? 'Select a time'
                                  : _preferredTime!.format(context),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.access_time,
                              color: primaryColor,
                            ),
                            onPressed: _selectTime,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _buildTitle('For'),
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

                _buildTitle('Stylist Preference'),
                DropdownButtonFormField<String>(
                  value: _stylistPreference,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Any', 'Male', 'Female']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _stylistPreference = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Budget (optional)'),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount in INR',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTitle('Special Requests (optional)'),
                TextFormField(
                  controller: _specialRequestsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., specific products, allergies',
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
    _specialRequestsController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
}
