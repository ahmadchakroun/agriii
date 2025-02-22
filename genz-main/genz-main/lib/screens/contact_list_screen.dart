import 'package:flutter/material.dart';
import 'package:yoser/api/contact_service.dart';
import 'package:yoser/screens/about_screen.dart';
import 'package:yoser/screens/message.dart';
import '../widgets/base_screen.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late Future<List<dynamic>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _favoritesFuture = ContactService.getFavoriteUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      showBottomNavBar: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'LISTE DES CONTACTS',
            style: TextStyle(
              color: Color.fromRGBO(76, 175, 80, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            _buildBackgroundImages(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<dynamic>>(
                future: _favoritesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading contacts'));
                  }
                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return Center(child: Text('No favorite contacts found'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16.0),
                      itemCount: users.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildUserCard(users[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImages() {
    return Stack(
      children: [
        _buildBackgroundImage(112.04, 96.6, -120, 'assets/images/background.png', 101.87, 100.08),
        _buildBackgroundImage(158.36, 383.1, 118.65, 'assets/images/background.png', 144.13, 141.59),
        _buildBackgroundImage(461.47, 315.62, 58.41, 'assets/images/background.png', 144.13, 141.59),
        _buildBackgroundImage(803.8, 363.16, 70.53, 'assets/images/background.png', 82.88, 81.42),
      ],
    );
  }

  Widget _buildBackgroundImage(double top, double left, double angle,
      String assetPath, double width, double height) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: angle * 3.141592653589793 / 180,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(
            assetPath,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
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
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              child: _buildUserImage(user),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['username'] ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    user['email'] ?? 'No email provided',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton(
                        'Message',
                        Icons.send,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessageScreen()),
                        ),
                      ),
                      _buildActionButton(
  'Consultation',
  Icons.info,
  Colors.white,
  () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutScreen(userId: user['_id']),
      ),
    );
    _refreshData(); // Refresh after returning from AboutScreen
  },
  textColor: Colors.green,
  borderColor: Colors.green,
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

  Widget _buildUserImage(Map<String, dynamic> user) {
    final imageUrl = user['imageUrl']?.toString() ?? '';
    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
          )
        : _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/images/1.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color backgroundColor,
    VoidCallback onPressed, {
    Color textColor = Colors.white,
    Color borderColor = Colors.transparent,
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