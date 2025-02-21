import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yoser/api/bureau_service.dart';
import 'package:yoser/screens/message.dart';
import '../widgets/base_screen.dart';
import 'about_screen.dart'; // Import the AboutScreen

class BureauScreen extends StatefulWidget {
  @override
  _BureauScreenState createState() => _BureauScreenState();
}

class _BureauScreenState extends State<BureauScreen> {
  late Future<List<dynamic>> _bureauFuture;
  List<dynamic> _allBureau = [];
  List<dynamic> _filteredBureau = [];
  String _searchQuery = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchBureau();
  }

  Future<void> _fetchBureau() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw Exception('User is not authenticated');
      }

      final bureau = await BureauService.fetchBureau(token);
      setState(() {
        _allBureau = bureau;
        _filteredBureau = bureau;
      });
    } catch (e) {
      print('Error fetching Bureau d’étude: $e');
    }
  }

  void _filterBureau(String query) {
    setState(() {
      _searchQuery = query;
      _filteredBureau = _allBureau.where((bureau) {
        final name = bureau['username'].toLowerCase();
        final email = bureau['email'].toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 0,
      showBottomNavBar: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bureau d’étude',
            style: TextStyle(
              color: Color.fromRGBO(76, 175, 80, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.green),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 10),
              _buildFilterBar(),
              SizedBox(height: 10),
              Expanded(
                child: _filteredBureau.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.only(top: 16.0),
                        itemCount: _filteredBureau.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final bureau = _filteredBureau[index];
                          return _buildBureauCard(bureau);
                        },
                      )
                    : Center(
                        child: Text('No Bureau d’étude found'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        suffixIcon: Icon(Icons.search, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (query) => _filterBureau(query),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: _buildFilterButton('Region')),
          Expanded(child: _buildFilterButton('Nature')),
          Expanded(child: _buildFilterButton('Type')),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildBureauCard(Map<String, dynamic> bureau) {
    return Container(
      width: double.infinity,
      height: 169,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rectangular image on the left
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              child: bureau['image'] != null
                  ? Image.network(
                      bureau['image'], // Use the user's image URL from the backend
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/1.png', // Fallback to a local placeholder
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: 12),
          // User details and buttons
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    bureau['username'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  // Email
                  Text(
                    bureau['email'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Message button
                      _buildActionButton(
                        context,
                        'Message',
                        Icons.message,
                        Colors.green,
                        () {
                          // Navigate to MessageScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MessageScreen()),
                          );
                        },
                      ),
                      // Consultation button
                      _buildActionButton(
                        context,
                        'Consultation',
                        Icons.info,
                        Colors.white, // White background
                        () {
                          // Navigate to AboutScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutScreen()),
                          );
                        },
                        textColor: Colors.green, // Green text
                        borderColor: Colors.green, // Green border
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color backgroundColor,
    VoidCallback onPressed, {
    Color textColor = Colors.white, // Default text color
    Color borderColor = Colors.transparent, // Default border color
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}