class PredictionModel {
  final int id;
  final double meters;
  final int rooms;
  final int bathrooms;
  final double predictedPrice;
  final String date;

  PredictionModel({
    required this.id,
    required this.meters,
    required this.rooms,
    required this.bathrooms,
    required this.predictedPrice,
    required this.date,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      meters: (json['sq_meters'] as num).toDouble(),
      rooms: json['rooms'],
      // Ajusta los nombres de las claves según tu BD
      bathrooms: json['bathrooms'] ?? 0, 
      predictedPrice: (json['estimated_price'] ?? 0).toDouble(), // Revisa cómo lo guardaste en Django
      date: json['created_at'] ?? '',
    );
  }
}