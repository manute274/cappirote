import 'package:CAPPirote/config/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendLocationToServer(Position position, int hdadid, Future<String> token) async {
  final url = Uri.parse('${Config.apiUrl}hermandades/updatelocation');
  final resolvedtoken = await token;

  try {
    final body = jsonEncode({
      'id': hdadid,
      'latitud': position.latitude,
      'longitud': position.longitude,
    });

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $resolvedtoken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Error al enviar la ubicación: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    throw Exception('Error en la solicitud: $e');
  }
}

Future<Map<String, double>> getLocationHdad(int id) async {
  final url = Uri.parse('${Config.apiUrl}hermandades/location/$id');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      double latitud = double.parse(data['latitud']);
      double longitud = double.parse(data['longitud']);
      return {'latitud': latitud, 'longitud': longitud};
    } else {
      throw Exception('Error al obtener latitud y longitud');
    }
  } catch (error) {
    throw Exception('Error al obtener latitud y longitud');
  }
}
