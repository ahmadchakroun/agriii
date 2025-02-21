import 'dart:convert';
import 'package:http/http.dart' as http;

class IngenieurService {
  static const String baseUrl = 'http://localhost:4000/api/users';

  static Future<List<dynamic>> fetchIngenieurs(String token) async {
    print("Fetching Ingenieurs with Token: $token");

    final response = await http.get(
      Uri.parse('$baseUrl/type/Ingenieurs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error Response: ${response.body}");
      throw Exception('Failed to load Ingenieurs');
    }
  }
}