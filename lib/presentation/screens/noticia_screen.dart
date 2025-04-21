import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/helpers/helperproxy.dart';
import 'package:flutter/material.dart';
import 'package:CAPPirote/entities/noticia.dart';
import 'package:CAPPirote/helpers/helpernoticias.dart';
import 'package:intl/intl.dart';

class NoticiaScreen extends StatefulWidget {
  final int noticiaId;
  const NoticiaScreen({super.key, required this.noticiaId});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  late Future<Noticia> _noticia;

  @override
  void initState() {
    super.initState();
    _noticia = getNoticia(widget.noticiaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MiAppBar(),
      body: FutureBuilder<Noticia>(
        future: _noticia,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final noticia = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Imagen
                  if (noticia.imagen != '') ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        proxifyImage(noticia.imagen),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  //Titulo
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  //Fecha
                  Text(
                    'Publicado: ${DateFormat('dd-MM-yyyy').format(noticia.fecha)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Cuerpo
                  Text(
                    noticia.cuerpo,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Sin datos'));
          }
        },
      ),
    );
  }
}
