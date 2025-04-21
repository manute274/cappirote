import 'package:CAPPirote/components/miappbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectDiaScreen extends StatelessWidget {
  const SelectDiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MiAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardWidget(
                title: 'Viernes de Dolores',
                content: 'Hermandades del Viernes de Dolores',
                color: Colors.blueAccent,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Sábado de Pasión',
                  content: 'Hermandades del Sábado de Pasión',
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Domingo de Ramos',
                  content: 'Hermandades del Domingo de Ramos',
                  color: Colors.redAccent,
              ),
              SizedBox(height: 8),
              CardWidget(
                title: 'Lunes Santo',
                content: 'Hermandades del Lunes Santo',
                color: Colors.green,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Martes Santo',
                  content: 'Hermandades del Martes Santo',
                  color: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              CardWidget(
                title: 'Miércoles Santo',
                content: 'Hermandades del Miércoles Santo',
                color: Colors.blueAccent,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Jueves Santo',
                  content: 'Hermandades del Jueves Santo',
                  color: Color.fromARGB(255, 97, 16, 10),
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Madrugá',
                  content: 'Hermandades de la Madrugá',
                  color: Colors.purple,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Viernes Santo',
                  content: 'Hermandades del Viernes Santo',
                  color: Colors.black,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Sábado Santo',
                  content: 'Hermandades del Sábado Santo',
                  color: Colors.yellow,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Domingo de Resurrección',
                  content: 'Hermandades del Domingo de Resurrección',
                  color: Color.fromARGB(255, 71, 179, 201),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String content;
  final int numhdades;
  final Color color;

  const CardWidget(
      {super.key,
      required this.title,
      required this.content,
      this.numhdades = 0,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color,
            width: 8,
          )
        )
      ),
      child: GestureDetector(
        onTap: () => {
          context.push('/hermandades/$title')
          /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectHdadScreen(
                  dia: title,
                )
              )
            ),*/
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //side: const BorderSide(color: Colors.blue)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
