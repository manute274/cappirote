import 'dart:convert';
import 'package:CAPPirote/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:CAPPirote/entities/hermandad.dart';

Future<Hermandad> getHermandad(int id) async {
  final url = Uri.parse('${Config.apiUrl}hermandades/$id');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Hermandad.fromJson(data);
    } else {
      throw Exception('Error al cargar datos de la hermandad');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}

Future<List<Hermandad>> getHdadesbyDia(String dia) async {
  final url = Uri.parse('${Config.apiUrl}hermandades/dia/$dia');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Hermandad.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar hermandades');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  } 
}