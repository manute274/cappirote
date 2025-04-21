// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:CAPPirote/utils/message_manager.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool visiblepassword = false;
  //final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _cargarDatosLogin();
  }
  
  Future<void> _cargarDatosLogin() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    
    setState(() {
      _emailController.text = email ?? '';
      _passwordController.text = password ?? '';
    });
  }

  Future<void> guardarLogin(String email, String password) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
  }

  Future<void> _login() async {
    var authdata = Provider.of<AuthProvider>(context, listen: false);

    try {
      Map<String, dynamic> response = await authdata.login(
        _emailController.text, 
        _passwordController.text
      );
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
          'Login exitoso'
        );
        context.go('/');
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
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    "Accede para continuar",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Color(0xffa29b9b),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: NetworkImage(
                          "https://i.imgur.com/ebYE6Ki.jpeg"),
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: emailDecoration(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !visiblepassword,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: passwordDecoration(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: const Text(
                      "¿Olvidaste la contraseña?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                    onTap: () {
                      forgetPassword(context);
                    },
                  ),
                ),
                const SizedBox(height: 30),

                //LOGIN BUTTON
                MaterialButton(
                  onPressed: () async {
                    await guardarLogin(_emailController.text, _passwordController.text);
                    await _login();
                  },
                  color: const Color(0xff3a57e8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Acceder",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                //REGISTER BUTTON
                MaterialButton(
                  onPressed: () {
                    context.push('/register');
                  },
                  color: const Color(0x2d3a57e8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xff3a57e8),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Registrate",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> forgetPassword(BuildContext context) {
    return showDialog(context: context, builder: (context) => 
      AlertDialog(
        title: const Text('¿Olvidaste la contraseña?'),
        content: const Text(
          'Contacta con un Administrador',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Volver'),
          ),
        ],
      )
    );
  }

  InputDecoration emailDecoration() {
    return InputDecoration(
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: Color(0xff000000), width: 1),
      ),

      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: Color(0xff000000), width: 1),
      ),

      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: Color(0xff000000), width: 1),
      ),

      labelText: "Email",
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 16,
        color: Color(0xff7c7878),
      ),
      filled: true,
      fillColor: const Color(0x00ffffff),
      isDense: false,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  InputDecoration passwordDecoration() {
    return InputDecoration(
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Color(0xff000000), width: 1),
        ),

        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Color(0xff000000), width: 1),
        ),

        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Color(0xff000000), width: 1),
        ),
        
        labelText: "Contraseña",
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 16,
          color: Color(0xff7c7878),
        ),
        filled: true,
        fillColor: const Color(0x00ffffff),
        isDense: false,
        contentPadding: const EdgeInsets.all(0),
        suffixIcon: GestureDetector(
          child: const Icon(Icons.visibility,
            color: Color(0xff7b7c82), 
            size: 24,
          ),
          onTap: () => {
            setState(() {
              visiblepassword = !visiblepassword;
            })
          },
        )
        
    );
  }
}
