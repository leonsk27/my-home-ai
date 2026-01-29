import 'package:my_home/models/predictionHistoryModel.dart';
import 'package:my_home/services/interceptor.dart';

class PredictionService {
  final ApiClient _client = ApiClient();

  Future<List<PredictionModel>> getHistory() async {
    // LLAMADA LIMPIA: Sin headers, sin checks de 401, sin baseUrl repetida
    final data = await _client.get('/api/history/');
    // Convertimos la data (que ya viene como Lista/Map gracias al cliente)
    return (data as List)
        .map((json) => PredictionModel.fromJson(json))
        .toList();
  }

  Future<double> predictPrice(
    double area,
    int rooms,
    int bathrooms,
    int garage,
    int yearBuilt,
    String location,
  ) async {
    final body = {
      "sq_meters": area,
      "rooms": rooms,
      "bathrooms": bathrooms,
      "garage": garage,
      "year_built": yearBuilt,
      "location": location,
    };

    final data = await _client.post('/api/predict/', body);

    return (data['estimated_price'] as num).toDouble();
  }
}
