class ApiEndpoints {
  static const String headlineNews = "/v2/everything";

  static const Set<int> validStatusCodes = {200, 201};
  static const Set<int> addPhotoStatusCodes = {400, 401, 403, 404, 500};
}
