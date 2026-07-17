import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/global.dart';
import '../models/farmacia_model.dart';
import '../models/clima_model.dart';


class ApiService {
  static const String baseUrl = 'https://api.sebastian.cl/cmutem';

  // Headers con token
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      };

  // Farmacias
  static Future<dynamic> getFarmacias(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/v1/farmacias/$lat/$lng');
    print('🔹 [getFarmacias] URL: $url');
    print('🔹 [getFarmacias] Token: $token');
    print('🔹 [getFarmacias] Headers: $headers');

    final response = await http.get(url, headers: headers);
    print('🔹 [getFarmacias] Status: ${response.statusCode}');
    print('🔹 [getFarmacias] Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Farmacia.fromJson(data);
    } else {
      throw Exception('Error farmacias: ${response.statusCode}');
    }
  }

  // El Clima
  static Future<dynamic> getClima(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/v1/clima/$lat/$lng');
    print('🔹 [getClima] URL: $url');
    print('🔹 [getClima] Token: $token');
    print('🔹 [getClima] Headers: $headers');

    final response = await http.get(url, headers: headers);
    print('🔹 [getClima] Status: ${response.statusCode}');
    print('🔹 [getClima] Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Clima.fromJson(data);
    } else {
      throw Exception('Error clima: ${response.statusCode}');
    }
  }
}
// Excepción específica: la API respondió 404 porque no hay ninguna
// farmacia de turno cerca de esa ubicación a esta hora. No es un error
// de red/servidor, es una respuesta de negocio válida.
class FarmaciaNoEncontradaException implements Exception {}

// Service
class FarmaciaService {
  static const String baseUrl = 'https://api.sebastian.cl/cmutem';
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      };
  static Future<Map<String, dynamic>> getFarmacia(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/v1/farmacias/$lat/$lng');
    print('🔹 [FarmaciaService.getFarmacia] URL: $url');
    print('🔹 [FarmaciaService.getFarmacia] Token: $token');
    print('🔹 [FarmaciaService.getFarmacia] Headers: $headers');

    final response = await http.get(url, headers: headers);
    print('🔹 [FarmaciaService.getFarmacia] Status: ${response.statusCode}');
    print('🔹 [FarmaciaService.getFarmacia] Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw FarmaciaNoEncontradaException();
    } else {
      throw Exception('Error farmacia: ${response.statusCode}');
    }
  }
}