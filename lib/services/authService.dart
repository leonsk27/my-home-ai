
import 'dart:convert';

import 'package:my_home/config/constants.dart';
import 'package:my_home/services/storageService.dart';
import "package:http/http.dart" as http;

class AuthService {
  final StorageService _storage =  StorageService();

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password})
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.saveToken(data["access"]);
        await _storage.saveUsername(data["username"]);
        print("LOGIN SUCCESS: $data");

        return true;
      }
      throw Exception("Credenciales incorrectas");
    } catch (err) {
      print("ERROR LOGIN: $err");
      rethrow;
    }
  }
  Future<bool> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // Mejorar manejo de errores (ej: usuario ya existe)
        final errorData = jsonDecode(response.body);
        throw Exception(errorData.toString());
      }
    } catch (err) {
      print("ERROR REGISTER: $err");
      rethrow;
    }
  }
}