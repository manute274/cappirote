import 'package:CAPPirote/config/config.dart';
import 'package:CAPPirote/entities/evento.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//GET todos los eventos
Future<Map<DateTime, List<Evento>>> getEvents() async {
  final url = Uri.parse('${Config.apiUrl}eventos');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parsear la respuesta JSON
      List<dynamic> data = json.decode(response.body);
      Map<DateTime, List<Evento>> events = {};

      for (var event in data) {
        String dateString = event['fecha'];
        DateTime? eventDate;

        try {
          eventDate = DateTime.tryParse(dateString);
        } catch (e) {
          throw Exception('Error al parsear la fecha');
        }

        if (eventDate == null) {
          continue;
        }
        Evento evento = Evento.fromJson({
          'id': event['id'],
          'nombre': event['nombre'],
          'descripcion': event['descripcion'],
          'fecha': eventDate,
          'nombre_usuario': event['nombre_usuario'],
        });
        //Sin inicializacion falla
        if (events[eventDate] == null) {
          events[eventDate] = [];
        }

        events[eventDate]?.add(evento);
      }
      return events;
    } else {
      throw Exception('Error al cargar los eventos');
    }
  } catch (error) {
    throw Exception('Error de conexión: $error');
  }
}

Future<void> createEvent(Evento evento, int idUser, Future<String> token) async {
  final url = Uri.parse('${Config.apiUrl}eventos');
  final resolvedtoken = await token;
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $resolvedtoken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nombre': evento.nombre,
        'descripcion': evento.descripcion,
        'fecha': evento.fecha.toIso8601String(),
        'id_usuario': idUser,
      }),
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Error al crear el evento: ${response.body}');
    }
  } catch (error) {
    rethrow;
  }
}

Future<void> deleteEvento (int idEvento, Future<String> token) async {
  final url = Uri.parse('${Config.apiUrl}eventos/$idEvento');
  final resolvedtoken = await token;

  try {
    final response = await http.delete(url, 
      headers: {
        'Authorization': 'Bearer $resolvedtoken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error borrando el evento');
    }

  } catch (error) {
    throw Exception('Error');
  }
}
