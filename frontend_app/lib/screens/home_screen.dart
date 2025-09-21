import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/offer_card.dart';
import '../data/offer_list.dart';

import 'login_page.dart';
import 'banquet_from_screen.dart';
import 'travel_stay_screen.dart';
import 'store_retail_screen.dart';
import 'saloon_grooming_screen.dart';
import 'fitness_gym_screen.dart';
import 'jewelry_accessories_screen.dart';
import 'fashion_boutiques_screen.dart';
import 'gifts_shop_screen.dart';
import 'memories_screen.dart';
import 'craft_culture_screen.dart';
import 'smart_services_screen.dart';
import 'casual_fun_games_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _allCategories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_filterCategories);
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      if (mounted) {
        setState(() {
          _allCategories = categories;
          _filteredCategories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        final categoryName = category['name'].toString().toLowerCase();
        return categoryName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Prevents a back button from appearing
        title: Row(
          children: [
            // User Icon with the first letter of their name
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // User Name
            Text(widget.userName),
          ],
        ),
        actions: [
          // The "Home" text
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // The Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FIXED TOP PART ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for categories...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 243, 241, 241),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredCategories.length + 1 + offers.length,
                      itemBuilder: (context, index) {
                        if (index < _filteredCategories.length) {
                          final category = _filteredCategories[index];
                          return CategoryCard(
                            imageUrl: category['image_url'],
                            name: category['name'],
                            onTap: () {
                              String categoryName = category['name'];
                              if (categoryName == 'Banquets & Venues') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BanquetFormScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Travel & Stay') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TravelStayScreen(),
                                  ),
                                );
                              } else if (categoryName ==
                                  'Retail stores & Shops') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RetailShopsScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Salons & Grooming') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SaloonGroomingScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Fitness & Gyms') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FitnessGymScreen(),
                                  ),
                                );
                              } else if (categoryName ==
                                  'Jewelry & Accessories') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const JewelryAccessoriesScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Fashion Boutiques') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FashionBoutiquesScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Gifts Shop') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GiftsShopScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Memories') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MemoriesScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Craft & Culture') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CraftCultureScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Smart Services') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SmartServicesScreen(),
                                  ),
                                );
                              } else if (categoryName == 'Casual Fun Games') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CasualFunGamesScreen(),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(title: Text(categoryName)),
                                      body: Center(
                                        child: Text(
                                          '$categoryName Page Coming Soon!',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        } else if (index == _filteredCategories.length) {
                          return const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                            child: Text(
                              'Special Offers',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        } else {
                          final offerIndex =
                              index - _filteredCategories.length - 1;
                          final offer = offers[offerIndex];
                          return OfferCard(
                            offerText: offer['offer']!,
                            detailsText: offer['details']!,
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 88, 136, 218),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 84, 118, 192).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 88, 136, 218),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ssquad Ventures',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 255, 255, 255),
                      ),
                    ),
                    Text(
                      'Powered by: Alphashivesh',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
