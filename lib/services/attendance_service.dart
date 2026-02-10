import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static const String _baseUrl =
      'https://stage.srisaraswathigroups.in/api/student/student-attendance-grid';
  static const String _summaryUrl =
      'https://stage.srisaraswathigroups.in/api/student/getattendanceSummary';

  static Future<Map<String, dynamic>> getAttendance() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve token or use the one provided in the request
      final String token =
          prefs.getString('access_token') ??
          'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

      // Retrieve student ID or use the one provided in the request
      final String studentId = prefs.getString('student_id') ?? '16264';

      final response = await http.get(
        Uri.parse('$_baseUrl/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'laravel_session=srMI9JoQ2JIcbyOidZayjSDPBWME4lweBFaTOuui',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Return the full map or just the data object depending on API structure
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        throw Exception('Failed to load attendance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching attendance: $e');
    }
  }

  static Future<Map<String, dynamic>> getAttendanceSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve token or use the one provided in the request
      final String token =
          prefs.getString('access_token') ??
          'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

      // Retrieve student ID or use the one provided in the request
      final String studentId = prefs.getString('student_id') ?? '16264';

      final response = await http.get(
        Uri.parse('$_summaryUrl/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'laravel_session=srMI9JoQ2JIcbyOidZayjSDPBWME4lweBFaTOuui',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        throw Exception(
          'Failed to load attendance summary: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching attendance summary: $e');
    }
  }
}
