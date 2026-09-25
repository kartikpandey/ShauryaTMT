import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/constants/app_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // Build request headers, attaching DRF token auth when a token is available
  static Map<String, String> buildHeaders({String? token}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers[AppConstants.authHeaderKey] =
          '${AppConstants.authScheme} $token';
    }
    return headers;
  }

  // Decode response body and validate the response_code envelope
  static Map<String, dynamic> decodeResponse(
    http.Response response, {
    String failureLabel = 'Request failed',
  }) {
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Unexpected server response (${response.statusCode}). Please try again.',
        statusCode: response.statusCode,
      );
    }

    final rawCode = decoded['response_code'];
    final int? responseCode = rawCode is num
        ? rawCode.toInt()
        : rawCode is String
        ? int.tryParse(rawCode)
        : null;
    final bool success =
        (response.statusCode >= 200 && response.statusCode < 300) ||
            responseCode == 200;

    if (!success) {
      final rawMessage = decoded['message'];
      final message =
          (rawMessage is String ? rawMessage : null) ??
          '$failureLabel (${responseCode ?? response.statusCode}). Please try again.';
      throw ApiException(message, statusCode: responseCode ?? response.statusCode);
    }

    return decoded;
  }

  // GET request helper
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    final uri = Uri.parse(endpoint);

    final http.Response response;
    try {
      response = await http
          .get(uri, headers: buildHeaders(token: token))
          .timeout(AppConstants.apiTimeout);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      throw ApiException('Unable to reach the server. Please try again.');
    }

    return decodeResponse(response);
  }

  // Fetch distributor dashboard data
  static Future<Map<String, dynamic>> fetchDistributionDashboard({
    String? token,
  }) async {
    return get(AppConstants.dashboardEndpoint, token: token);
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required int userType,
  }) async {
    final uri = Uri.parse(AppConstants.loginEndpoint);

    final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: buildHeaders(),
            body: jsonEncode({
              'username': username,
              'password': password,
              'user_type': userType,
            }),
          )
          .timeout(AppConstants.apiTimeout);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      throw ApiException('Unable to reach the server. Please try again.');
    }

    return decodeResponse(response, failureLabel: 'Login failed');
  }
}