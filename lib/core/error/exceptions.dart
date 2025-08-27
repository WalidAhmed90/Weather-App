class ServerException implements Exception {
  final String message;
  ServerException({this.message = "Server error"});
}

class CacheException implements Exception {}

class NoInternetException implements Exception {
  final String message;
  NoInternetException({this.message = "No internet connection"});
}
