import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';

class ApiClient {
  final http.Client client;
  final NetworkInfo networkInfo;
  final Logger logger = Logger(); // for logging

  ApiClient({required this.client, required this.networkInfo});

  /// Safe GET request with logging, error handling and connectivity check
  Future<Map<String, dynamic>> get(String url) async {
    if (!await networkInfo.isConnected) {
      logger.w("No internet connection → throwing NoInternetException");
      throw NoInternetException();
    }

    try {
      logger.i("➡️ GET: $url");

      final response = await client.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      logger.i("⬅️ Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerException(message: "Error ${response.statusCode}");
      }
    } on SocketException {
      logger.e("❌ SocketException (no internet)");
      throw NoInternetException();
    } on HttpException {
      logger.e("❌ HttpException (bad response)");
      throw ServerException(message: "Invalid response");
    } on FormatException {
      logger.e("❌ FormatException (invalid JSON)");
      throw ServerException(message: "Invalid JSON format");
    } catch (e, stack) {
      logger.e("❌ Unexpected error: $e", error: e, stackTrace: stack);
      throw ServerException(message: e.toString());
    }
  }
}
