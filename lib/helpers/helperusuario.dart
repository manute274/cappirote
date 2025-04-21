import 'dart:convert';
import 'package:CAPPirote/config/config.dart';
import 'package:http/http.dart' as http;


// Método para obtener los datos del perfil desde la API
Future<Map<String, dynamic>> getProfile(int idUser, Future<String?> token) async {
  final url = Uri.parse('${Config.apiUrl}usuarios/$idUser');
  final resolvedtoken = await token;

  try {
    if (resolvedtoken != null) {
      final response = await http.get(url,
      headers: {'Authorization': 'Bearer $resolvedtoken'},);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener los datos del perfil');
      }
    } else {
      throw Exception('No hay token');
    }
    

  } catch (e) {
    throw Exception('Error en el servidor: $e');
  } 
}

Future<Map<String, dynamic>> registerUser(String nombre, String correo, String contrasena) async {
  final url = Uri.parse('${Config.apiUrl}register');

  try {
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode({
        "nombre": nombre,
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    Map<String, dynamic> responseData;
    if (response.statusCode == 200 || response.statusCode == 201) {
      responseData = json.decode(response.body);
      return responseData;
    } else {
      responseData = jsonDecode(response.body);
      return responseData;
    }
  } catch (e) {
    throw Exception("Excepción al registrar usuario: $e");
  }
}

