import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginUrl =
      'https://stage.srisaraswathigroups.in/api/student_login';

  static Future<bool> login({
    required String mobile,
    required String password,
  }) async {
    try {
      final url = Uri.parse(_loginUrl);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'mobile': mobile, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Check if the response indicates success (adjust key if needed)
        if (body is Map) {
          final prefs = await SharedPreferences.getInstance();
          if (body['data'] != null && body['data'] is Map) {
            if (body['data']['token'] != null) {
              await prefs.setString("token", body['data']['token']);
            }
            if (body['data']['sid'] != null) {
              await prefs.setInt("sid", body['data']['sid']);
            }
          }
          return true;
        }
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return false;
  }
}
