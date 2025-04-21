import 'dart:convert';
import 'package:CAPPirote/config/config.dart';
import 'package:http/http.dart' as http;

Future<void> toggleFavorite(int idHdad, int idUser, bool isFavorite, Future<String?> token) async {
  var url = Uri.parse('${Config.apiUrl}devotos');
  final resolvedtoken = await token;
  //Si no es favorita la marcamos
  if (isFavorite == false) {
    try {
      final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $resolvedtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id_hdad': idHdad, 'id_usuario': idUser}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Ha habido un error');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  // Si es favorita, elimino la relacion
  } else {
    try {
      url = Uri.parse('${Config.apiUrl}devotos/$idHdad/usuario/$idUser');
      final response = await http.delete(url,
        headers: {
          'Authorization': 'Bearer $resolvedtoken',
          //'Content-Type': 'application/json',
        },
        //body: json.encode({'id_hdad': idHdad, 'id_usuario': idUser}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Ha habido un error');
      }

    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }  
}

Future<List<dynamic>> getFavoriteHermandades(int idUser, Future<String?> token) async {
  final url = Uri.parse('${Config.apiUrl}devotos/user/$idUser');
  final resolvedtoken = await token;

  try {
    if (resolvedtoken != null) {
      final response = await http.get(url,
      headers: {'Authorization': 'Bearer $resolvedtoken'},);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) => item['hermandades']).toList();
      } else {
        throw Exception('${response.statusCode} No tienes hermandades favoritas.');
      }
    } else {
      throw Exception('No hay token');
    }
  } catch (error) {
    throw Exception('Escepcion inesperada: $error');
  }
}

Future<bool> checkDevoto(int idUser, int idHdad, Future<String?> token) async {
  final url = Uri.parse('${Config.apiUrl}devotos/comprobarrelacion');
  final resolvedtoken = await token;

  try {
    if (resolvedtoken != null) {
      final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $resolvedtoken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id_hdad': idHdad, 'id_usuario': idUser})
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        return data['existe'];
      } else {
        throw Exception('Error al obtener las hermandades favoritas: ${response.statusCode}');
      }
    } else {
      throw Exception('No hay token');
    }
  } catch (error) {
    throw Exception('Error en el servidor');
  }

}
