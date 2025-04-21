import 'package:CAPPirote/entities/noticia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CAPPirote/config/config.dart';


Future<Map<String, dynamic>> getNoticias({int page = 1, int limit = 10}) async {
  final url = Uri.parse('${Config.apiUrl}noticias?page=$page&limit=$limit');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      //List<dynamic> noticiasJson = jsonResponse['data'];
      //List<Noticia> noticias =
      //  noticiasJson.map((item) => Noticia.fromJson(item)).toList();
      //return noticias;
      return jsonResponse;
    }
    else {
      throw Exception('Error al cargar las noticias');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }   
}

Future<Noticia> getNoticia(int idNoticia) async {
  final response =
      await http.get(Uri.parse("${Config.apiUrl}noticias/$idNoticia"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return Noticia.fromJson(data);
  } else {
    throw Exception('Fallo al cargar la noticia');
  }
}

Future<Map<String, dynamic>> createNoticia(Noticia noticia, Future<String> token) async {
  final url = Uri.parse('${Config.apiUrl}noticias');
  final resolvedtoken = await token;
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $resolvedtoken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'titulo': noticia.titulo,
        'cuerpo': noticia.cuerpo,
        'fecha': noticia.fecha.toIso8601String(),
        'imagen': noticia.imagen,
      }),
    );

    Map<String,dynamic> responseData;

    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Error al crear la noticia: ${response.body}');
    }
  } catch (error) {
    rethrow;
  }
}
