// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/helpers/helperusuario.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/utils/message_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _error = false;

  Future<void> _registerAndLogin(String username, 
    String email, String password) async {
      _error = false;

      try {
        Map<String, dynamic> response = await registerUser(username, email, password);
        if (response.entries.first.key == 'error') {
          _error = true;
          MessageManager.showCustomDialog(
            context, 
            'Error', 
            response.entries.first.value
          );
        } 
        //El registro ha ido bien y procedo con el login
        else {
          var authdata = Provider.of<AuthProvider>(context, listen: false);
          response = await authdata.login(email, password);
          if (response.entries.first.key == 'error') {
            MessageManager.showCustomDialog(
              context, 
              'Error', 
              response.entries.first.value
            );
            _error = true;
          } 
        }
      } catch (error) {
        MessageManager.handleError(context, error);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const MiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Image(
                image: NetworkImage(
                    "https://i.imgur.com/0UK3jsG.png"),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "¡Empecemos!",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 22,
                    color: Color(0xffaa3ae8),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Crea una cuenta",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: TextField(
                  controller: _usernameController,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: registerDecoration('Nombre'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: _emailController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: registerDecoration('Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: registerDecoration('Contraseña'),
                ),
              ),
              //REGISTER BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () async {
                    await _registerAndLogin(
                      _usernameController.text, 
                      _passwordController.text, 
                      _passwordController.text
                    );
                    if (_error == false) {
                       await MessageManager.showCustomDialog(
                        context, 
                        'Info', 
                        'Registro y logueo exitoso. ¡Bienvenido!');
                      context.go('/');
                    }
                  },
                  color: const Color(0xffb655c7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "¿Ya tienes una cuenta?",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: GestureDetector(
                        child: const Text(
                          "Accede",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff3a57e8),
                          ),
                        ),
                        onTap: () {
                          context.push('login');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration registerDecoration(String campo) {
    return InputDecoration(
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xff3a57e8), width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xff3a57e8), width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xff3a57e8), width: 1),
      ),

      hintText: campo,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 14,
        color: Color(0xff000000),
      ),
      filled: true,
      fillColor: const Color(0xffffffff),
      isDense: false,
      contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      prefixIcon:
        const Icon(Icons.person, color: Color(0xff212435), size: 24),
    );
  }
}
