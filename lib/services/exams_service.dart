import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExamsService {
  static const String _baseUrl =
      'https://stage.srisaraswathigroups.in/api/student/online-exams-by-student';
  static const String _writeExamBaseUrl =
      'https://stage.srisaraswathigroups.in/api/student/exam/write';
  static const String _saveAnswerUrl =
      'https://stage.srisaraswathigroups.in/api/student/exam/save-answer';

  static Future<List<dynamic>> getOnlineExams() async {
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
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'] is List ? decoded['data'] : [];
        } else if (decoded is List) {
          return decoded;
        }
        return [];
      } else {
        throw Exception('Failed to load exams: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exams: $e');
    }
  }

  static Future<Map<String, dynamic>> getExamQuestions(String examId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token =
          prefs.getString('access_token') ??
          'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

      final response = await http.get(
        Uri.parse('$_writeExamBaseUrl/$examId'),
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
          'Failed to load exam questions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching exam questions: $e');
    }
  }

  static Future<bool> saveAnswer(Map<String, dynamic> payload) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token =
          prefs.getString('access_token') ??
          'MTYyNjR8SVlIbWlWRjMzbno3ZGJwb3BIWXRySEtPaERkM2x2Y01GUnlGUmthNnwxNzY3MjQ2NDcyfDg4ZmQ4YTQ0YjQ4NGQ1YTJlNGFmMTEzYTAwN2VlYTdlYmE4MDBjM2Q5N2U4ZTljMjU5YmY5NjJhMjliODliNzA=';

      final response = await http.post(
        Uri.parse(_saveAnswerUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Cookie': 'laravel_session=srMI9JoQ2JIcbyOidZayjSDPBWME4lweBFaTOuui',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
