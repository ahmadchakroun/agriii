import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ContactService {
  static const String _baseUrl = 'http://localhost:4000/api/auth';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<List<dynamic>> getFavoriteUsers() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$_baseUrl/favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['favorites'] as List<dynamic>;
      }
      throw Exception('Failed to load favorites');
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  static Future<bool> isFavorite(String userId) async {
    try {
      final favorites = await getFavoriteUsers();
      return favorites.any((user) => user['_id'] == userId);
    } catch (e) {
      return false;
    }
  }

  static Future<void> toggleFavorite(String favoriteUserId) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$_baseUrl/favorites/$favoriteUserId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }
}
  const String _baseUrl = 'http://localhost:4000/api/auth';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<dynamic>> getFavoriteUsers() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$_baseUrl/favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['favorites'];
      } else {
        throw Exception('Failed to load favorite users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching favorite users: $e');
    }
  }
