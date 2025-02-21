import 'dart:convert';
import 'package:http/http.dart' as http;

class BureauService {
  static const String baseUrl = 'http://localhost:4000/api/users';

  static Future<List<dynamic>> fetchBureau(String token) async {
    print("Fetching Bureau d’étude with Token: $token");

    final response = await http.get(
      Uri.parse('$baseUrl/type/Bureau%20d%E2%80%99%C3%A9tude'), // URL-encoded for "Bureau d’étude"
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error Response: ${response.body}");
      throw Exception('Failed to load Bureau d’étude');
    }
  }
}