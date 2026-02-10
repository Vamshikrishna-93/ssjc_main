import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HostelFeeService {
  static const String _baseUrl = 'https://stage.srisaraswathigroups.in';

  static Future<dynamic> getHostelFeeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve token or use the one provided in the request as fallback
      final String token =
          prefs.getString('access_token') ??
          'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

      // Retrieve student ID or use the one provided in the request as fallback
      final String studentId = prefs.getString('student_id') ?? '16264';

      final Uri url = Uri.parse('$_baseUrl/api/student/studentfeetabData/$studentId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'laravel_session=srMI9JoQ2JIcbyOidZayjSDPBWME4lweBFaTOuui',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load hostel fee data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('HostelFeeService Exception: $e');
      rethrow;
    }
  }
}
