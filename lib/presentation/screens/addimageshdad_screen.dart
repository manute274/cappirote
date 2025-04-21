// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/helpers/helperhdad_images.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/utils/message_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddImageScreen extends StatefulWidget {
  final int idHdad;
  const AddImageScreen({super.key, required this.idHdad});

  @override
  AddImageScreenState createState() => AddImageScreenState();
}

class AddImageScreenState extends State<AddImageScreen> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  Future<void> _addImages() async {
    List<String> imageUrls = _controllers
      .map((controller) => controller.text)
      .where((url) => url.isNotEmpty)
      .toList();

    if (imageUrls.isEmpty) {
      MessageManager.showSnackBar(context, "Por favor, ingresa al menos una URL");
      return;
    }

    try {
      var authdata = Provider.of<AuthProvider>(context, listen: false);
      Map<String, dynamic> response = await addImagesHdad(widget.idHdad, 
        imageUrls, authdata.token);
      if (response.entries.first.key == 'error') {
        MessageManager.showCustomDialog(
          context, 
          'Error', 
          response.entries.first.value);
      }
      else {
        await MessageManager.showCustomDialog(
          context, 
          'Info', 
          'Imagenes añadidas con éxito'
        );
        context.pop();
      }
    } catch (error) {
      MessageManager.handleError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir URLs de Imágenes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        // Cuadro de texto
                        Expanded(
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: 'Imagen ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        // Icono + para agregar otro cuadro de texto
                        if (index == _controllers.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addTextField,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addImages();
              },
              child: const Text("Enviar URLs"),
            ),
          ],
        ),
      ),
    );
  }
}
