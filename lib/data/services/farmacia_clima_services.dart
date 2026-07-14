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

    final response = await http.get(url, headers: headers);

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