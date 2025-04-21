import 'package:CAPPirote/helpers/helperusuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late Future<Map<String, dynamic>> _profileData;
  bool _isEditing = false;

  // Controladores para los campos editables
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _profileData = getProfile(
      authProvider.user!.id,
      authProvider.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color.fromARGB(255, 182, 85, 199),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;

            // Si estamos editando, asignamos los datos a los controladores
            if (_isEditing) {
              _nombreController.text = profile['nombre'] ?? authProvider.user!.nombre;
              _correoController.text = profile['correo'] ?? authProvider.user!.correo;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profile['avatar'] ?? authProvider.user!.avatar),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 16),

                    // Nombre con ícono de lápiz para editar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nombreController,
                            readOnly: !_isEditing, // Si no estamos editando, el campo es solo lectura
                            decoration: InputDecoration(
                              labelText: profile['nombre'],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Correo con ícono de lápiz para editar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _correoController,
                            readOnly: !_isEditing,
                            decoration: InputDecoration(
                              labelText: profile['correo'],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Botón para cerrar sesión
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            authProvider.logout();
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.red,
                          ),
                          child: const Text('Cerrar sesión'),
                        ),
                        if (_isEditing) 
                          ElevatedButton(
                            onPressed: () {
                              authProvider.logout();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              iconColor: Colors.red,
                            ),
                            child: const Text('Ac'),
                          ),
                      ],
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
    );
  }
}
