// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/helpers/helperdevoto.dart';
import 'package:CAPPirote/helpers/helperhdad_images.dart';
import 'package:CAPPirote/helpers/helperproxy.dart';
import 'package:CAPPirote/presentation/screens/location_screen.dart';
import 'package:CAPPirote/presentation/screens/map_screen.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/entities/hermandad.dart';
import 'package:CAPPirote/helpers/helperhdad.dart';
import 'package:CAPPirote/utils/message_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class HermandadScreen extends StatefulWidget {
  final int hdadId;

  const HermandadScreen({super.key, required this.hdadId});

  @override
  HermandadScreenState createState() => HermandadScreenState();
}

class HermandadScreenState extends State<HermandadScreen> {
  late Future<Hermandad> futureHermandad;
  late int hdadId;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    hdadId = widget.hdadId;
    futureHermandad = getHermandad(widget.hdadId);
    comprobarFavorito();
  }
  
  Future<void> comprobarFavorito() async {
    var authdata = Provider.of<AuthProvider>(context, listen: false);
    if (authdata.isAuthenticated) {
      try {
        isFavorite = await checkDevoto(authdata.user!.id, hdadId, authdata.token);
        setState(() {
          isFavorite;
        });
      } catch (error) {
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error.toString()),
            );
          }
        );
      }
    }
  }

  Future<void> marcarfavorito() async {
    try {
      var authdata = Provider.of<AuthProvider>(context, listen: false);
      
      if (!authdata.isAuthenticated) {
        throw Exception();
      }
      await toggleFavorite(hdadId, authdata.user!.id, isFavorite, authdata.token);
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      throw Exception("Error al marcar como favorita");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (Provider.of<AuthProvider>(context).isAuthenticated) ...[
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
              ),
              onPressed: marcarfavorito,
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'Editar') {

                } else if (value == 'Eliminar') {

                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Editar',
                    child: Text('Editar Hermandad'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Eliminar',
                    child: Text('Eliminar Hermandad'),
                  ),
                ];
              },
            ),
          ]
        ],
      ),
      body: FutureBuilder<Hermandad>(
        future: futureHermandad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final hermandad = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [

                  //Escudo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      hermandad.escudo,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Nombre Hdad
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        hermandad.nombre,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Apelativo
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.label, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            'Apelativo: ${hermandad.apelativo}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Fundación
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.history, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            'Fundación: ${hermandad.fundacion}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Titulares
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.newspaper, color: Colors.deepPurple,),
                          const SizedBox(width: 10),
                          /*RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                  text: 'Titulares: ', 
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                  text: hermandad.titulares,
                                ),
                              ]
                            )
                          )*/
                          Expanded(
                            child: Text(
                              'Titulares: ${hermandad.titulares}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sede
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                            color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Sede: ${hermandad.sede}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Día
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.deepPurple
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Día: ${hermandad.dia}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Itinerario
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Itinerario: ${hermandad.itinerario}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Galeria imagenes
                  HdadGallery(hdadId: hdadId,),

                  // Espacio adicional
                  const SizedBox(height: 20),
                ],
              ),
            );

            } else {
              return const Center(
                child: Text(
                  'No se encontraron datos',
                  style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold)
                )
              );
            }
          },
        ),
        bottomNavigationBar: BottomAppBarHdad(hdadId: hdadId,)
    );
  }
}

class HdadGallery extends StatefulWidget {
  final int hdadId;

  const HdadGallery({
    super.key,
    required this.hdadId
  });

  @override
  State<HdadGallery> createState() => _HdadGalleryState();
}

class _HdadGalleryState extends State<HdadGallery> {
  List<String> imageUrls = [];
  bool _error = false;
  

  @override
  void initState() {
    super.initState();
    _loadimages();
  }

  Future<void> _loadimages() async {
    _error = false;
    try {
      Map<String, dynamic> response = await getImagesHdad(widget.hdadId);
      if (response.entries.first.key == 'error') {
        setState(() {
          _error = true;
        });
      } else {
        if (response.entries.first.key != 'message') {
          setState(() {
            imageUrls = List<String>.from(response['urls']);
            _error = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        _error = true;
      });
      MessageManager.showCustomDialog(
        context,
        'Error',
        'Hubo un error al cargar las imágenes: $error'
      );
    }
  }

  void _showImageDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            child: PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black54),
              pageController: PageController(initialPage: index),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteImageDialog(int index, String imageUrl) {
    var authdata = Provider.of<AuthProvider>(context, listen:false);

    if (authdata.isAuthenticated && authdata.user!.rol != 'Usuario') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Menú contextual'),
            content: const Text('¿Desea eliminar la imagen?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await deleteImageHdad(widget.hdadId, imageUrl, authdata.token);
                  setState(() { 
                    imageUrls.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var authdata = Provider.of<AuthProvider>(context, listen:false);

    if (imageUrls.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: _error 
        ? const Center(child: Text('Hubo un error al cargar las imágenes.'))
        : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: (authdata.isAuthenticated && 
            (authdata.user!.rol == 'Colaborador' || authdata.user!.rol == 'Admin'))
            ? imageUrls.length + 1 
            : imageUrls.length,
          itemBuilder: (context, index) {
            if (index != imageUrls.length) {
              String imageUrl = imageUrls[index];

              return GestureDetector(
                onTap: () => _showImageDialog(index,),
                onLongPress: () => _showDeleteImageDialog(index, imageUrl),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: proxifyImage(imageUrls[index]),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ]
                ),
              );
            }

            else {
              return GestureDetector(
                onTap: () {
                  context.push('/hermandades/hdad/${widget.hdadId}/images/add');
                },
                child: Container(
                  color: Colors.transparent,
                  child: const Icon(
                    Icons.add_circle,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              );
            }

          }
        ),
      );
    }
    else {
      return Column(
        children: [
          const Center(child: Text('No hay imagenes para esta hermandad')),
          const SizedBox(height: 8.0,),
          if (authdata.comprobarRol('Colaborador') || authdata.comprobarRol('Admin') )
            GestureDetector(
              onTap: () {
                context.push('/hermandades/hdad/${widget.hdadId}/images/add');
              },
              child: Container(
                color: Colors.transparent,
                child: const Icon(
                  Icons.add_circle,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            )
        ],
      );
    }
  }
}

class BottomAppBarHdad extends StatelessWidget {
  final int hdadId;
  
  const BottomAppBarHdad({
    super.key, required this.hdadId,
  });

  @override
  Widget build(BuildContext context) {
    var authdata = Provider.of<AuthProvider>(context, listen: false);
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(hdadId: hdadId,)
                  )
                );
              },
              icon: const Icon(Icons.map),
              label: const Text(
                'Consultar\nUbicación',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),

            //Si es colaborador o admin, muestra el boton
            if(authdata.comprobarRol('Colaborador') || authdata.comprobarRol('Admin')) 
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationScreen(hdadId: hdadId,)));
                },
                icon: const Icon(Icons.location_city),
                label: const Text('Informar\nUbicación'),
              )
          ],
        ),
      ),
    );
  }
}
