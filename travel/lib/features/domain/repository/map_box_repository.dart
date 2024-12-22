abstract class MapboxRepository {
  Future<List<String>> getAddressSuggestions(String query);
  Future<List<String>> getCitySuggestions(String query);
}
