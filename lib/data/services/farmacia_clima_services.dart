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
    print('🔹 URL: $url');
    print('🔹 Token: $token');
    print('🔹 Headers: $headers');

    final response = await http.get(url, headers: headers);
    print('🔹 Status: ${response.statusCode}');
    print('🔹 Body: ${response.body}');

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
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Clima.fromJson(data);
    } else {
      throw Exception('Error clima: ${response.statusCode}');
    }
  }
}
// Service
class FarmaciaService {
  static const String baseUrl = 'https://api.sebastian.cl/cmutem';
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      };
  static Future<Map<String, dynamic>> getFarmacia(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/v1/farmacias/$lat/$lng');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error farmacia');
    }
  }
}