import 'package:CAPPirote/helpers/helperproxy.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

import 'package:CAPPirote/components/hamburger_menu.dart';
import 'package:CAPPirote/entities/noticia.dart';
import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/helpers/helpernoticias.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Noticia> events = [];
  late ScrollController _scrollController;
  int _page = 1; 
  int _totalpages = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cargarNoticias();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Cuando llegamos al final, cargamos más noticias
        _loadMoreNoticias();
      }
    });
  }

  Future<void> cargarNoticias() async {
    var jsonNoticias = await getNoticias(page: _page);
    List<dynamic> noticiasJson = jsonNoticias['data'];
    _totalpages = jsonNoticias['totalPages'];
    events = 
      noticiasJson.map((item) => Noticia.fromJson(item)).toList();
    setState(() {
      _isLoading = false; // Finaliza la carga
    });
  }

  
  Future<void> _loadMoreNoticias() async {
  if (_isLoading || _page >= _totalpages) return; // Evitar carga si ya está en proceso o no hay más páginas

  setState(() {
    _isLoading = true;
  });

  var jsonNoticias = await getNoticias(page: _page + 1);
  List<dynamic> noticiasJson = jsonNoticias['data'];

  setState(() {
    events.addAll(noticiasJson.map((item) => Noticia.fromJson(item)).toList());
    _page += 1;
    _isLoading = false;
  });
}

  //Para ver si hay noticias nuevas
  Future<void> _refreshNoticias() async {
    setState(() {
      events.clear();
      _page = 1;
    });
    await cargarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    var authdata = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: const MiAppBar(),
      body: Center(
        child: events.isEmpty 
        ? (_isLoading 
              ? const CircularProgressIndicator() 
              : const Text("No hay noticias disponibles"))
        : RefreshIndicator(
          onRefresh: _refreshNoticias,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: events.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == events.length) {
                // Indicador de carga al final de la lista
                return const Center(child: CircularProgressIndicator());
              }
              Noticia event = events[index];
              return GestureDetector(
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(event.titulo),
                    subtitle: Text(
                      event.cuerpo,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: event.imagen.isNotEmpty
                      ? SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CachedNetworkImage(
                            imageUrl: proxifyImage(event.imagen),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  ),
                ),
                onTap: () {
                  context.push('/noticias/${event.id}');
                },
              );
            },
          ),
        )
      ),
      drawer: const HamburgerMenu(),
      floatingActionButton: 
        (authdata.isAuthenticated && authdata.user?.rol == 'Admin') 
        ? FloatingActionButton(
            onPressed: () {
              context.push('/noticias/add');
            },
            tooltip: 'Añadir noticia',
            child: const Icon(Icons.add),
          )
        : null
    );
  }
  
  
  
}
