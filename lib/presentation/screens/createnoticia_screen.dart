// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/entities/noticia.dart';
import 'package:CAPPirote/helpers/helpernoticias.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/utils/message_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateNoticiaScreen extends StatefulWidget {
  const CreateNoticiaScreen({super.key});

  @override
  CreateNoticiaScreenState createState() => CreateNoticiaScreenState();
}

class CreateNoticiaScreenState extends State<CreateNoticiaScreen> {
  final _titleController = TextEditingController(); 
  final _imageUrlController = TextEditingController(); 
  final _bodyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Método para crear la noticia
  Future<void> _createNews() async {
    if (_formKey.currentState?.validate() ?? false) {
      String title = _titleController.text;
      String body = _bodyController.text;
      String imageUrl = _imageUrlController.text;
      DateTime fecha = DateTime.now();

      var authdata = Provider.of<AuthProvider>(context, listen: false);
      try {
        Noticia noticia = Noticia(titulo: title, cuerpo: body, fecha: fecha, imagen: imageUrl);
        Map<String, dynamic> response = await createNoticia(noticia, authdata.token);
        
        if (response.containsKey('error')) {
          MessageManager.showCustomDialog(
            context, 
            'Error', 
            response['error']);
        }
        else {
          await MessageManager.showCustomDialog(
            context, 
            'Info', 
            'Noticia publicada con éxito'
          );
          context.pushReplacement('/');
        }
      } catch (error) {
        MessageManager.handleError(context, error);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título de la noticia
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un título';
                  }
                  return null;
                },
              ),

              // URL de la imagen
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen (opcional)'
                ),
              ),

              // Cuerpo
              TextFormField(
                controller: _bodyController,
                minLines: 5,
                maxLines: null,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Cuerpo de la noticia'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un texto';
                  }
                  return null;
                },
              ),

              // Botón para crear la noticia
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _createNews();
                  },
                  child: const Text('Crear Noticia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
