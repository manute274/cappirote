import 'package:CAPPirote/presentation/providers/theme_provider.dart';
//import 'package:CAPPirote/presentation/screens/addimageshdad_screen.dart';
//import 'package:CAPPirote/presentation/screens/createnoticia_screen.dart';
//import 'package:CAPPirote/presentation/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 182, 85, 199),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text('CAPPirote', style: TextStyle(color: Colors.white))),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: const Text('Noticias'),
                  onTap: () { 
                    context.push('/');
                  },
                ),
                ListTile(
                  title: const Text('Hermandades'),
                  onTap: () {
                    context.push('/hermandades');
                  },
                ),
                ListTile(
                  title: const Text('Eventos'),
                  onTap: () {
                    context.push('/eventos');
                  },
                ),
/*                 ListTile(
                  title: const Text('Test'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AddImageScreen(idHdad: 18,)));
                  },
                ),
                ListTile(
                  title: const Text('add noticia'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const CreateNoticiaScreen()));
                  },
                ),
                ListTile(
                  title: const Text('scroll'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const HomePage()));
                  },
                ),
 */

              ],
            ),
          ),
          
          // Botón para cambiar de modo claro/oscuro
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              tooltip: 'Cambiar modo',
              icon: Icon(
                (Theme.of(context).brightness == Brightness.dark)
                    ? Icons.brightness_7_outlined
                    : Icons.brightness_2_outlined,
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
