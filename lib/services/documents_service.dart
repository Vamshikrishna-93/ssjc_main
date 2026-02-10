import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DocumentsService {
  // Using the provided endpoint. Note: The URL path 'outings' suggests this might return outing data,
  // but it is being used for the Documents Page as requested.
  // Updated to point to the correct documents endpoint
  static const String _baseUrl =
      'https://stage.srisaraswathigroups.in/api/student/documents';

  static Future<Map<String, dynamic>> getDocuments() async {
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
        // Ensure we return a Map, wrapping list if necessary
        if (decoded is List) {
          return {'data': decoded};
        }
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
