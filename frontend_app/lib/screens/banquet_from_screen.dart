import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/country_list.dart';
import '../data/currency_list.dart';
import '../widgets/chioce_card.dart';
import '../widgets/cuisine_card.dart';

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({super.key});
  @override
  State<BanquetFormScreen> createState() => _BanquetFormScreen();
}

class _BanquetFormScreen extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  String? _eventType = 'Wedding';
  String? _selectedCountry = 'India';
  String? _selectedState;
  List<String> _statesOfSelectedCountry = [];
  final _cityController = TextEditingController();
  final _numAdultsController = TextEditingController();
  String? _cateringPreference = 'Non-veg';
  final List<Map<String, dynamic>> _cuisines = [
    {
      'name': 'Indian',
      'image':
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400',
      'isSelected': false,
    },
    {
      'name': 'Chinese',
      'image':
          'https://images.pexels.com/photos/2347311/pexels-photo-2347311.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Italian',
      'image':
          'https://images.unsplash.com/photo-1594007654729-407eedc4be65?w=400',
      'isSelected': false,
    },
    {
      'name': 'Mexican',
      'image':
          'https://images.pexels.com/photos/2092916/pexels-photo-2092916.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Japanese',
      'image':
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      'isSelected': false,
    },
    {
      'name': 'Thai',
      'image':
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'Mediterranean',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
      'isSelected': false,
    },
    {
      'name': 'French',
      'image':
          'https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
    {
      'name': 'American',
      'image':
          'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
      'isSelected': false,
    },
    {
      'name': 'Spanish',
      'image':
          'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=400',
      'isSelected': false,
    },
  ];

  String? _formError;
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _offerHoursController = TextEditingController();
  List<DateTime> _selectedDates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _statesOfSelectedCountry = countriesWithStates[_selectedCountry] ?? [];
  }

  Future<void> _selectIndividualDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDates.isEmpty ? now : _selectedDates.last,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
    );

    if (pickedDate != null) {
      setState(() {
        if (!_selectedDates.contains(pickedDate)) {
          _selectedDates.add(pickedDate);
          _selectedDates.sort();
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formError = null;
        _isLoading = true;
      });

      final selectedCuisines = _cuisines
          .where((c) => c['isSelected'] == true)
          .map((c) => c['name'] as String)
          .toList();
      final requestData = {
        'eventType': _eventType,
        'country': _selectedCountry,
        'state': _selectedState,
        'city': _cityController.text,
        'eventDates': json.encode(
          _selectedDates
              .map((date) => DateFormat('yyyy-MM-dd').format(date))
              .toList(),
        ),
        'numAdults': int.tryParse(_numAdultsController.text) ?? 0,
        'cateringPreference': _cateringPreference,
        'cuisines': json.encode(selectedCuisines),
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'offerWithinHours': int.tryParse(_offerHoursController.text),
      };

      try {
        await _apiService.submitBanquetRequest(requestData);
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _formError = 'Please fill all the necessary fields.';
      });
    }
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banquets & Venues'),
        backgroundColor: Colors.blue,
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
                  'Tell Us Your Venue Requirements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),

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
                            'Anniversary',
                            'Corporate Event',
                            'Birthday Party',
                            'Engagement',
                            'Farewell',
                            'Seminar',
                            'Award Ceremony',
                            'Reunion',
                            'Product Launch',
                            'Others',
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

                _buildTitle('Country'),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: countriesWithStates.keys
                      .map(
                        (country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                        _statesOfSelectedCountry =
                            countriesWithStates[value] ?? [];
                        _selectedState = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('State'),
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  hint: const Text('Select a state'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _statesOfSelectedCountry
                      .map(
                        (state) =>
                            DropdownMenuItem(value: state, child: Text(state)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedState = value),
                  validator: (value) =>
                      value == null ? 'Please select a state' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('City'),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the city name',
                    focusColor: CupertinoColors.darkBackgroundGray,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a city' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Event Dates'),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Date'),
                  onPressed: _selectIndividualDate,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _selectedDates
                      .map(
                        (date) => Chip(
                          label: Text(DateFormat('d MMM yyyy').format(date)),
                          onDeleted: () {
                            setState(() {
                              _selectedDates.remove(date);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),

                _buildTitle('Number of Adults'),
                TextFormField(
                  controller: _numAdultsController,
                  decoration: const InputDecoration(
                    hintText: 'like: 50',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter number of adults'
                      : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Catering Preference'),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceCard(
                        text: 'Non-veg',
                        icon: Icons.square,
                        iconColor: Colors.red,
                        isSelected: _cateringPreference == 'Non-veg',
                        onTap: () =>
                            setState(() => _cateringPreference = 'Non-veg'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ChoiceCard(
                        text: 'Veg',
                        icon: Icons.square,
                        iconColor: Colors.green,
                        isSelected: _cateringPreference == 'Veg',
                        onTap: () =>
                            setState(() => _cateringPreference = 'Veg'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Please select your Cuisines'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _cuisines.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _cuisines[index]['name'],
                      imageUrl: _cuisines[index]['image'],
                      isSelected: _cuisines[index]['isSelected'],
                      onTap: () => setState(
                        () => _cuisines[index]['isSelected'] =
                            !_cuisines[index]['isSelected'],
                      ),
                    );
                  },
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
                    backgroundColor: Colors.blue,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),

                if (_formError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        _formError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
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
    _cityController.dispose();
    _budgetController.dispose();
    _numAdultsController.dispose();
    _offerHoursController.dispose();
    super.dispose();
  }
}
