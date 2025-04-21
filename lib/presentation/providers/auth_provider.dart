import 'package:CAPPirote/config/config.dart';
import 'package:CAPPirote/entities/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  Usuario? user;
  bool isAuthenticated = false;
  
  Future<String> get token async => await recuperarToken();
  

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${Config.apiUrl}login/');

    try {
      _logger.i('Intentando login para $email');

      final response = await http.post(
        url,
        body: json.encode({
          'correo': email,
          'contrasena': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Map<String, dynamic> responseData;

      if (response.statusCode == 200) {
        responseData = json.decode(response.body);
        
        await guardarToken(responseData['token']);
        user = Usuario(
          id: responseData['id'], 
          nombre: responseData['nombre'], 
          correo: responseData['correo'], 
          avatar: responseData['avatar'],
          rol: responseData['rol'] ?? 'Usuario'
        );
        notifyListeners();
        isAuthenticated = true;
        _logger.i('Login exitoso para $email');
        return responseData;

      } else {
        _logger.w('Login fallido con código ${response.statusCode}');
        responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (error) {
      _logger.e('Error en el login: $error');
      throw Exception(error);
    }
  }
  

  // Cerrar sesión
  Future<void> logout() async {
    eliminarToken();
    isAuthenticated = false;
    notifyListeners();
    _logger.i('Usuario desconectado');
  }

  // Comprobar si el token ya está almacenado al iniciar la app
  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      notifyListeners();
    }
  }

  bool comprobarRol(String rol) {
    if (isAuthenticated == true && user!.rol == rol) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<String> recuperarToken() async {
    return (await _storage.read(key: 'auth_token') ?? '');
  }
  
  Future<void> guardarToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> eliminarToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
