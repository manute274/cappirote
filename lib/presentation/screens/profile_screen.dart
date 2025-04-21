import 'package:CAPPirote/helpers/helperdevoto.dart';
import 'package:CAPPirote/helpers/helperusuario.dart';
import 'package:CAPPirote/presentation/screens/hdad_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileData;
  late Future<List<dynamic>> _hdadesFavoritas;

  @override
  void initState() {
    super.initState();
    var authdata = Provider.of<AuthProvider>(context, listen: false);
    _profileData = getProfile(authdata.user!.id, authdata.token);
    _hdadesFavoritas = getFavoriteHermandades(authdata.user!.id, authdata.token);
  }

  // Método para alternar entre modo editable y no editable
  void toggleEdit() {
    setState(() {
      //isEditable = !isEditable;
      //if (!isEditable) {
      //  username = usernameController.text;
      //  email = emailController.text;
      //}
    });
  }

  Widget buildHermandadCard(dynamic hermandad) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                hermandad['escudo'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  hermandad['nombre'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => HermandadScreen(
            hdadId: hermandad['id'],
            )
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 182, 85, 199),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: toggleEdit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profile['avatar']),
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(height: 16),

                    // Nombre
                    Text(
                      'Nombre: ${profile['nombre']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Correo electrónico
                    Text(
                      'Correo: ${profile['correo'] }',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: _hdadesFavoritas,
                        builder: (context, favSnapshot) {
                          if (favSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (favSnapshot.hasError) {
                            return Center(child: Text('Error: ${favSnapshot.error}'));
                          } else if (favSnapshot.hasData) {
                            final hermandades = favSnapshot.data!;
                            return SingleChildScrollView(
                              child: ExpansionTile(
                                title: const Text(
                                  'Hermandades favoritas',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                children: hermandades.map((hermandad) {
                                  return buildHermandadCard(hermandad);
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(child: Text('No se pudo cargar la información.'));
                          }
                        },
                      ),
                    ),

                    // Botón para cerrar sesión
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false).logout();
                        context.go('/');
                      },
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No se pudo cargar el perfil.'));
          }
        },
        ),
      ),
    );
  }
}
