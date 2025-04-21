import 'dart:convert';
import 'package:CAPPirote/config/config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getImagesHdad(int idHdad) async {
  final url = Uri.parse('${Config.apiUrl}images/$idHdad');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 404) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar datos de la hermandad');
    }
  } catch (e) {
    throw Exception('Excepcion no controlada: $e');
  }
}

Future<Map<String, dynamic>> deleteImageHdad(int idHdad, String imageUrl,
 Future<String> token) async {
  String encodedImageUrl = Uri.encodeComponent(imageUrl);

  final url = Uri.parse('${Config.apiUrl}images/$idHdad/$encodedImageUrl');
  final resolvedtoken = await token;

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $resolvedtoken',
        'Content-Type': 'application/json',
        },
      //body: json.encode({'image_url': imageUrl}),
      );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al borrar imagen');
    }
  } catch (e) {
    throw Exception('Excepcion no controlada: $e');
  }
}

Future<Map<String, dynamic>> addImagesHdad(int idHdad, List<String> imageUrls,
  Future<String> token) async {
    final url = Uri.parse('${Config.apiUrl}images/$idHdad');
    final resolvedtoken = await token;

    try {
      final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $resolvedtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "id_hdad": idHdad,
          "image_urls": imageUrls,}),
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 409) {
        var data = json.decode(response.body);
        return data;
      }
      else {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Excepcion no controlada: $e');
    }
}