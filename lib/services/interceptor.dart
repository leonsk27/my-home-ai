import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_home/config/constants.dart';
import 'package:my_home/services/storageService.dart';

class ApiClient {
  final String baseUrl = 'https://server-python-supabase.onrender.com';
  final StorageService _storage = StorageService();

  // Método genérico para headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Manejador central de respuestas
  dynamic _processResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Éxito: Devolvemos el JSON decodificado
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // 🚨 ALERTA: TOKEN VENCIDO O INVÁLIDO 🚨
      
      print('⚠️ Token expirado. Cerrando sesión...');
      
      // 1. Borrar token sucio
      await _storage.deleteAll();

      // 2. Usar la Llave Maestra para redirigir al Login sin context
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      
      throw Exception('Sesión expirada');
    } else {
      // Otros errores (400, 500, etc)
      throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // GET
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    
    try {
      final response = await http.get(url, headers: headers);
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();

    try {
      final response = await http.post(
        url, 
        headers: headers, 
        body: jsonEncode(body)
      );
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}