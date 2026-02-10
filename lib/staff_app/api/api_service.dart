import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../api/api_collection.dart';

class ApiService {
  ApiService._();

  static final GetStorage _box = GetStorage();

  // ================= HEADERS =================

  static Map<String, String> _authHeaders(String token) => {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    // 🔥 IMPORTANT: credentials in URL (NOT body)
    final Uri url = Uri.parse(
      ApiCollection.baseUrl +
          ApiCollection.login(username: username, password: password),
    );

    try {
      // clear old session (multi-user safe)
      _box.remove("token");
      _box.remove("user_id");

      final response = await http
          .post(
            url,
            headers: {
              "Accept": "application/json",
              // ❌ NO Content-Type
            },
          )
          .timeout(const Duration(seconds: 20));

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      // Parse JSON response
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        debugPrint("LOGIN JSON PARSE ERROR: ${response.body}");
        throw Exception("Invalid server response format");
      }

      // 🔍 DEBUG: Log the full response
      debugPrint("LOGIN API RESPONSE: ${response.body}");
      debugPrint("LOGIN PARSED DATA: $data");

      // Check if login was successful
      final isSuccess =
          data["success"] == true ||
          data["success"] == "true" ||
          data["success"] == 1;

      debugPrint(
        "LOGIN SUCCESS CHECK: isSuccess=$isSuccess, hasToken=${data["access_token"] != null}",
      );

      if (isSuccess && data["access_token"] != null) {
        _box.write("token", data["access_token"]);
        _box.write("user_id", data["userid"]);
        return data;
      }

      // Extract error message from response
      final errorMessage =
          data["message"] ??
          data["error"] ??
          data["msg"] ??
          data["errors"]?.toString() ??
          "Invalid credentials";

      debugPrint("LOGIN ERROR MESSAGE: $errorMessage");
      throw Exception(errorMessage);
    } on http.ClientException {
      throw Exception("Network error: Please check your internet connection");
    } on FormatException {
      throw Exception("Invalid server response format");
    } catch (e) {
      // If it's already an Exception, rethrow it
      if (e is Exception) {
        rethrow;
      }
      // Otherwise wrap it
      throw Exception(e.toString());
    }
  }

  // ================= AUTH GET =================
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final String? token = _box.read<String>("token");

    if (token == null || token.isEmpty) {
      throw Exception("Session expired. Please login again.");
    }

    final Uri url = Uri.parse(ApiCollection.baseUrl + endpoint);

    try {
      final response = await http
          .get(url, headers: _authHeaders(token))
          .timeout(const Duration(seconds: 20));

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded is Map<String, dynamic>) {
        return decoded;
      }

      if (response.statusCode == 401) {
        _box.remove("token");
        _box.remove("user_id");
        throw Exception("Unauthorized");
      }

      throw Exception("API Error ${response.statusCode}: ${response.body}");
    } catch (e) {
      rethrow;
    }
  }

  // ================= STUDENT SEARCH =================
  static Future<List<Map<String, dynamic>>> searchStudentByAdmNo(
    String admNo,
  ) async {
    final res = await getRequest(ApiCollection.studentByAdmNo(admNo));

    if ((res["success"] == true || res["success"] == "true") &&
        res["indexdata"] != null) {
      return List<Map<String, dynamic>>.from(res["indexdata"]);
    }

    throw Exception("Student not found");
  }

  // ================= DEPARTMENTS =================
  static Future<List<Map<String, dynamic>>> getDepartmentsList() async {
    final res = await getRequest(ApiCollection.departmentsList);

    if ((res["success"] == true || res["success"] == "true") &&
        res["indexdata"] != null) {
      return List<Map<String, dynamic>>.from(res["indexdata"]);
    }

    throw Exception("Failed to load departments");
  }

  // ================= DESIGNATIONS =================
  static Future<List<Map<String, dynamic>>> getDesignationsList() async {
    final res = await getRequest(ApiCollection.designationsList);

    if ((res["success"] == true || res["success"] == "true") &&
        res["indexdata"] != null) {
      return List<Map<String, dynamic>>.from(res["indexdata"]);
    }

    throw Exception("Failed to load designations");
  }

  // ================= OUTING LIST (RAW RESPONSE) =================
  static Future<Map<String, dynamic>> getOutingListRaw() async {
    final res = await getRequest(ApiCollection.outingList);

    if ((res["success"] == true || res["success"] == "true")) {
      return res;
    }

    throw Exception("Failed to load outing list");
  }

  // ================= PENDING OUTING =================
  static Future<List<Map<String, dynamic>>> getPendingOutingList() async {
    final res = await getRequest(ApiCollection.pendingOutingList);

    if ((res["success"] == true || res["success"] == "true") &&
        res["indexdata"] != null) {
      return List<Map<String, dynamic>>.from(res["indexdata"]);
    }

    throw Exception("Failed to load pending outing list");
  }
}
