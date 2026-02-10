import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HostelAttendanceService {
  static const String _baseUrl =
      'https://stage.srisaraswathigroups.in/api/student/student-hostel-attendance-grid';

  static Future<Map<String, dynamic>> getHostelAttendance() async {
    try {
      // Hardcoded student ID and token as per request
      const String studentId = '16264';
      const String token = 'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

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
        throw Exception(
          'Failed to load hostel attendance: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching hostel attendance: $e');
    }
  }
}
