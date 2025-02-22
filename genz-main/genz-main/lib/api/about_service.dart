// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const String _baseUrl = 'http://localhost:4000/api/users';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}