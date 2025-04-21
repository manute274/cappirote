import 'package:flutter/material.dart';

class MessageManager {

  static void handleError(BuildContext context, dynamic error) {
    
    if (error is FormatException) {
      showCustomDialog(context, 'Error de formato', 'Hubo un problema con los datos recibidos.');
    } 
    else if (error is NoSuchMethodError) {
      showCustomDialog(context, 'Error de red', 'No se pudo conectar al servidor. Intenta de nuevo más tarde.');
    } 
    else {
      showCustomDialog(context, 'Error desconocido', 'Ocurrió un error inesperado. Intenta de nuevo.');
    }
  }

  static Future<void> showCustomDialog(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
