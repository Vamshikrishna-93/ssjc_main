import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthService {
  static Future<bool> login({
    required String mobile,
    required String password,
  }) async {
    final url = Uri.parse(ApiConfig.baseUrl + ApiConfig.login);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "User-Agent": "Flutter"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", body["data"]["token"]);
        await prefs.setInt("sid", body["data"]["sid"]);
        return true;
      }
    }
    return false;
  }
}
