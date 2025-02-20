import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config.dart';
import '../providers/post_provider.dart';
import '../models/pagination.dart';
import '../models/post.dart';
import '../widgets/base_screen.dart';
import 'factuer.dart';
import 'panier_screen.dart';

class IntrantListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider(
        PaginationModel(Category: 'intrant', page: 1, pageSize: 10)));

    return BaseScreen(
      currentIndex: 0,
      showBottomNavBar: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'INTRANT AGRICOLE',
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 10),
              _buildFilterBar(),
              SizedBox(height: 10),
              Expanded(
                child: postsAsyncValue.when(
                  data: (posts) {
                    if (posts == null || posts.isEmpty) {
                      return Center(child: Text('Aucun post trouvé'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(6),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return _buildPostCard(context, posts[index]);
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Erreur : $err')),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
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

  Widget _buildPostCard(BuildContext context, Post post) {
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
              child: Image.network(
                Config.imageURL + post.PostImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 150),
              ),
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
                    post.postId,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    post.PostDescription,
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
                          context, 'Buy', Icons.shopping_cart, FactureScreen()),
                      _buildActionButton(
                          context, 'Favorite', Icons.favorite, PanierScreen()),
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
      BuildContext context, String label, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: label == 'Buy' ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: label == 'Buy' ? Colors.white : Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: label == 'Buy' ? Colors.white : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
