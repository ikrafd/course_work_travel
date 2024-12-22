import 'package:travel/features/data/data_sources/map_box_service.dart';
import 'package:travel/features/domain/repository/map_box_repository.dart';

class MapboxRepositoryImpl implements MapboxRepository {
  final MapboxService _mapboxService;

  MapboxRepositoryImpl(this._mapboxService);

  @override
  Future<List<String>> getAddressSuggestions(String query) {
    return _mapboxService.getAddressSuggestions(query);
  }

  @override
  Future<List<String>> getCitySuggestions(String query) {
    return _mapboxService.getCitySuggestions(query);
  }
}
