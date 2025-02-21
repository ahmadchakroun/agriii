import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      "http://localhost:4000/api/auth"; // Update with your server address

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    final responseBody =
        jsonDecode(response.body); // ✅ Now, this will correctly decode

    print("📩 Server Response: ${response.body}");

    if (response.statusCode == 201) {
      print('✅ Registration Success: ${responseBody['message']}');
    } else {
      print(
          '❌ Error: ${responseBody['error']}'); // ✅ Handle error messages correctly
      throw Exception(responseBody['error'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    print("📩 Raw Server Response: ${response.body}"); // Debugging
    print("📌 Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print("✅ Decoded Response: $decodedResponse");

      if (!decodedResponse.containsKey('accessToken')) {
        print("🚨 Error: Token not found in response");
        throw Exception("Token not found in response");
      }

      return decodedResponse;
    } else {
      print("❌ Error Response: ${response.body}");
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
