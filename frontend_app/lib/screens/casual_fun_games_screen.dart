// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../data/currency_list.dart';
import '../widgets/cuisine_card.dart';

class CasualFunGamesScreen extends StatefulWidget {
  const CasualFunGamesScreen({super.key});
  @override
  State<CasualFunGamesScreen> createState() => _CasualFunGamesScreenState();
}

class _CasualFunGamesScreenState extends State<CasualFunGamesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form state variables
  final _numPlayersController = TextEditingController();
  String? _ageGroup = 'All Ages';
  String? _locationType = 'Indoor';
  final _locationDetailsController = TextEditingController();
  DateTime? _eventDate;
  final _eventTimeController = TextEditingController();
  final _budgetController = TextEditingController();
  String? _selectedCurrency = 'INR';
  final _equipmentNeededController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _gameTypes = [
    {'name': 'Board Games', 'image': 'https://images.pexels.com/photos/776656/pexels-photo-776656.jpeg?auto=compress&cs=tinysrgb&w=400', 'isSelected': true},
    {'name': 'Outdoor Sports', 'image': 'https://images.pexels.com/photos/248547/pexels-photo-248547.jpeg?auto=compress&cs=tinysrgb&w=400', 'isSelected': false},
    {'name': 'Video Games', 'image': 'https://images.pexels.com/photos/442576/pexels-photo-442576.jpeg?auto=compress&cs=tinysrgb&w=400', 'isSelected': false},
    {'name': 'Party Games', 'image': 'https://images.pexels.com/photos/5952136/pexels-photo-5952136.jpeg?auto=compress&cs=tinysrgb&w=400', 'isSelected': false},
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) setState(() => _eventDate = picked);
  }

  void _submitForm() async {
    final selectedGameType = _gameTypes.firstWhere((g) => g['isSelected'] == true, orElse: () => {'name': null})['name'];
    if (_formKey.currentState!.validate() && selectedGameType != null) {
      setState(() { _isLoading = true; });
      final requestData = {
        'gameType': selectedGameType,
        'numPlayers': int.tryParse(_numPlayersController.text) ?? 2,
        'ageGroup': _ageGroup,
        'locationType': _locationType,
        'locationDetails': _locationDetailsController.text,
        'eventDate': _eventDate != null ? DateFormat('yyyy-MM-dd').format(_eventDate!) : null,
        'eventTime': _eventTimeController.text,
        'budget': double.tryParse(_budgetController.text),
        'currency': _selectedCurrency,
        'equipmentNeeded': _equipmentNeededController.text,
        'additionalNotes': _additionalNotesController.text,
      };
      try {
        await _apiService.submitGamesRequest(requestData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit request: $e'), backgroundColor: Colors.red));
      } finally {
        if(mounted) setState(() { _isLoading = false; });
      }
    }
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.blue; // Amber theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Casual Fun Games'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade50], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Text(
                  'Plan Your Game Event',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _buildTitle('Type of Game/Activity'),
                 GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5),
                  itemCount: _gameTypes.length,
                  itemBuilder: (context, index) {
                    return CuisineCard(
                      name: _gameTypes[index]['name'],
                      imageUrl: _gameTypes[index]['image'],
                      isSelected: _gameTypes[index]['isSelected'],
                      onTap: () {
                        setState(() {
                          for (var type in _gameTypes) {
                            type['isSelected'] = false;
                          }
                          _gameTypes[index]['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildTitle('Number of Players'),
                TextFormField(controller: _numPlayersController, decoration: const InputDecoration(hintText: 'e.g., 8', border: OutlineInputBorder(), filled: true, fillColor: Colors.white), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                
                _buildTitle('Age Group'),
                DropdownButtonFormField<String>(
                  value: _ageGroup,
                  decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  items: ['All Ages', 'Kids', 'Teens', 'Adults'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                  onChanged: (value) => setState(() => _ageGroup = value),
                ),
                const SizedBox(height: 16),
                
                _buildTitle('Location Type'),
                DropdownButtonFormField<String>(
                  value: _locationType,
                  decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  items: ['Indoor', 'Outdoor', 'Flexible'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                  onChanged: (value) => setState(() => _locationType = value),
                ),
                const SizedBox(height: 16),
                
                _buildTitle('Location Details'),
                TextFormField(controller: _locationDetailsController, decoration: const InputDecoration(hintText: 'e.g., Home, park, office address', border: OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                
                _buildTitle('Date & Time'),
                Row(children: [
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                    child: Text(_eventDate == null ? 'Select a date' : DateFormat('d MMM yyyy').format(_eventDate!)),
                  )),
                  IconButton(icon: const Icon(Icons.calendar_today, color: primaryColor), onPressed: _selectDate),
                ]),
                const SizedBox(height: 16),
                 TextFormField(controller: _eventTimeController, decoration: const InputDecoration(hintText: 'Enter preferred time (e.g., 7 PM)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                
                _buildTitle('Budget (optional)'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _budgetController,
                        decoration: const InputDecoration(hintText: 'Enter amount', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                        items: currencies.map((currency) => DropdownMenuItem(value: currency['code'], child: Text("${currency['code']} (${currency['symbol']})"))).toList(),
                        onChanged: (value) => setState(() => _selectedCurrency = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildTitle('Equipment Needed (optional)'),
                TextFormField(controller: _equipmentNeededController, decoration: const InputDecoration(hintText: 'e.g., Projector, whiteboard, speakers', border: OutlineInputBorder(), filled: true, fillColor: Colors.white), maxLines: 2),
                const SizedBox(height: 16),

                _buildTitle('Additional Notes (optional)'),
                TextFormField(controller: _additionalNotesController, decoration: const InputDecoration(hintText: 'Any other details', border: OutlineInputBorder(), filled: true, fillColor: Colors.white), maxLines: 2),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: primaryColor, foregroundColor: Colors.black87),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
    _numPlayersController.dispose();
    _locationDetailsController.dispose();
    _eventTimeController.dispose();
    _budgetController.dispose();
    _equipmentNeededController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }
}