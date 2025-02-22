import 'package:flutter/material.dart';
import 'package:yoser/api/about_service.dart';
import 'package:yoser/api/contact_service.dart';
import 'package:yoser/widgets/base_screen.dart';


class AboutScreen extends StatefulWidget {
  final String userId;

  const AboutScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<Map<String, dynamic>> _userFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();
    _checkFavoriteStatus();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    return await UserService.getUserById(widget.userId);
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFav = await ContactService.isFavorite(widget.userId);
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await ContactService.toggleFavorite(widget.userId);
      setState(() {
        _isFavorite = !_isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 4,
      showBottomNavBar: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ABOUT PAGE',
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(child: Text('Error loading user data'));
            }

            final userData = snapshot.data ?? {};
            
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Image.network(
                      userData['imageUrl'] ?? 'assets/images/1.png',
                      height: 120.0,
                      width: 120.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/1.png',
                        height: 120.0,
                        width: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    userData['username'] ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          icon: Icon(Icons.send, color: Colors.white, size: 20),
                          label: Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _isFavorite ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.favorite,
                            color: _isFavorite ? Colors.white : Colors.green,
                            size: 20,
                          ),
                          label: Text(
                            _isFavorite ? 'In List' : 'Add To List',
                            style: TextStyle(
                              color: _isFavorite ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userData['about'] ?? 'No information available',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            _buildContactInfo('Mail', userData['email']),
                            _buildContactInfo('Phone', userData['phone']),
                            _buildContactInfo('Address', userData['address']),
                            _buildContactInfo('Website', userData['website']),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildPostsSection(userData['posts']),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value ?? 'Not provided'),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsSection(List<dynamic>? posts) {
    if (posts == null || posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('No posts available', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: posts.map((post) => Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(post['content'] ?? ''),
      )).toList(),
    );
  }
}