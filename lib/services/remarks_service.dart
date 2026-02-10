import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RemarksService {
  static const String _baseUrl =
      'https://stage.srisaraswathigroups.in/api/student/remarks';

  static Future<List<dynamic>> getRemarks() async {
    try {
      // Use the specific token provided in the request
      const String token = 'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';
      
      // Use the specific student ID provided in the request
      const String studentId = '16264';

      final response = await http.get(
        Uri.parse('$_baseUrl/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'laravel_session=srMI9JoQ2JIcbyOidZayjSDPBWME4lweBFaTOuui',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Handle response structure
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
           // If 'data' is the list
          return decoded['data'] is List ? decoded['data'] : []; 
        } else if (decoded is List) {
          return decoded;
        } else if (decoded is Map<String, dynamic> && decoded.containsKey('remarks')) {
             // Just in case it's under 'remarks'
            return decoded['remarks'] is List ? decoded['remarks'] : [];
        }
        
        // Fallback: if the root object is a map but we don't know the key, return empty or try to inspect
        return [];
      } else {
        throw Exception('Failed to load remarks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching remarks: $e');
    }
  }
}
