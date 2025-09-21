// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../data/country_list.dart';
import '../widgets/cuisine_card.dart';

class TravelStayScreen extends StatefulWidget {
  const TravelStayScreen({super.key});
  @override
  State<TravelStayScreen> createState() => _TravelStayScreenState();
}

class _TravelStayScreenState extends State<TravelStayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  String? _selectedCountry = 'India';
  String? _selectedState;
  List<String> _statesOfSelectedCountry = [];
  final _destinationController = TextEditingController();
  final _numTravelersController = TextEditingController();
  final _numRoomsController = TextEditingController();
  final _numChildrenController = TextEditingController();
  final _budgetController = TextEditingController();
  final _offerHoursController = TextEditingController();

  String? _travelerType = 'Family';
  String? _accommodationType = 'Hotel';
  String? _selectedCurrency = 'INR';

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _isLoading = false;

  final List<Map<String, String>> _accommodationTypes = [
    {
      'name': 'Hotel',
      'image':
          'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'name': 'Resort',
      'image':
          'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'name': 'Homestay',
      'image':
          'https://images.pexels.com/photos/271639/pexels-photo-271639.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'name': 'Apartment',
      'image':
          'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
  ];

  @override
  void initState() {
    super.initState();
    _statesOfSelectedCountry = countriesWithStates[_selectedCountry] ?? [];
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isCheckIn ? _checkInDate : _checkOutDate) ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_checkInDate != null &&
          _checkOutDate != null &&
          (_checkOutDate!.isBefore(_checkInDate!) ||
              _checkOutDate!.isAtSameMomentAs(_checkInDate!))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check-out date must be after the check-in date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final requestData = {
        'country': _selectedCountry,
        'state': _selectedState,
        'destinationCity': _destinationController.text,
        'checkInDate': _checkInDate != null
            ? DateFormat('yyyy-MM-dd').format(_checkInDate!)
            : null,
        'checkOutDate': _checkOutDate != null
            ? DateFormat('yyyy-MM-dd').format(_checkOutDate!)
            : null,
        'numTravelers': int.tryParse(_numTravelersController.text) ?? 1,
        'numRooms': int.tryParse(_numRoomsController.text) ?? 1,
        'numChildren': int.tryParse(_numChildrenController.text) ?? 0,
        'travelerType': _travelerType,
        'accommodationType': _accommodationType,
        'budget': double.tryParse(_budgetController.text) ?? 0.0,
        'currency': _selectedCurrency,
        'offerWithinHours': int.tryParse(_offerHoursController.text),
      };

      try {
        await _apiService.submitTravelRequest(requestData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Travel request submitted successfully!'),
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
        title: const Text('Travel & Stay Requirements'),
        backgroundColor: primaryColor,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  'Tell Us Your Travel Requirements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

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

                _buildTitle('Destination City'),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter city name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a destination' : null,
                ),
                const SizedBox(height: 16),

                _buildTitle('Check-in & Check-out Dates'),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateDisplay('Check-in', _checkInDate),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () => _selectDate(context, true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateDisplay('Check-out', _checkOutDate),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () => _selectDate(context, false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Traveler Details'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _numTravelersController,
                        decoration: const InputDecoration(
                          hintText: 'Adults',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _numRoomsController,
                        decoration: const InputDecoration(
                          hintText: 'Rooms',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _numChildrenController,
                        decoration: const InputDecoration(
                          hintText: 'Children',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTitle('Type of Traveler'),
                DropdownButtonFormField<String>(
                  value: _travelerType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Solo', 'Couple', 'Family', 'Group']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _travelerType = value),
                ),
                const SizedBox(height: 16),

                _buildTitle('Accommodation Type'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _accommodationTypes.length,
                  itemBuilder: (context, index) {
                    final type = _accommodationTypes[index];
                    return CuisineCard(
                      name: type['name']!,
                      imageUrl: type['image']!,
                      isSelected: _accommodationType == type['name'],
                      onTap: () =>
                          setState(() => _accommodationType = type['name']),
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

  Widget _buildDateDisplay(String label, DateTime? date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
          Text(
            date == null
                ? 'Select Date'
                : DateFormat('d MMM yyyy').format(date),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _numTravelersController.dispose();
    _numRoomsController.dispose();
    _numChildrenController.dispose();
    _budgetController.dispose();
    _offerHoursController.dispose();
    super.dispose();
  }
}
