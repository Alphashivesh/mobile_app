// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //Always check your computer's current IP address using 'ipconfig' in the command prompt.
  static const String _baseUrl = 'http://XXX.XX.XX.XXX:3000/api';

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<Map<String, String>>> fetchCurrencies() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all?fields=currencies'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final Map<String, String> currencyMap = {};
      for (var country in data) {
        final currencies = country['currencies'] as Map<String, dynamic>?;
        if (currencies != null) {
          currencies.forEach((code, details) {
            if (details['symbol'] != null && !currencyMap.containsKey(code)) {
              currencyMap[code] = details['symbol'];
            }
          });
        }
      }
      final currencyList = currencyMap.entries.map((entry) {
        return {'code': entry.key, 'symbol': entry.value};
      }).toList();
      currencyList.sort((a, b) => a['code']!.compareTo(b['code']!));
      return currencyList;
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<void> submitBanquetRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/banquet-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit banquet request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitTravelRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/travel-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit travel request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitJewelryRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/jewelry-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit jewelry request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitFashionRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/fashion-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit fashion request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitGiftsRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/gifts-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit gifts request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitRetailRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/retail-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit retail request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitMemoriesRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/memories-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit memories request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitCraftRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/craft-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit craft request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitSaloonRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/saloon-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit saloon request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitGymRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/gym-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit gym request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitSmartServicesRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/smart-services-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit service request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> submitGamesRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/games-requests'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to submit game request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> registerUser(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      final body = json.decode(response.body);
      throw Exception(body['error'] ?? 'Failed to register.');
    }
  }

  Future<Map<String, dynamic>> loginUser(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final body = json.decode(response.body);
      throw Exception(body['error'] ?? 'Failed to log in.');
    }
  }

}
