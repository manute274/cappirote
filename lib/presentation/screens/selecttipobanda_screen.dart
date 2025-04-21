import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/presentation/screens/selecthdad_screen.dart';
import 'package:flutter/material.dart';

class SelectTipoBandaScreen extends StatelessWidget {
  const SelectTipoBandaScreen({super.key});

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
                title: 'Cornetas y Tambores',
                content: 'Bandas de Cornetas y Tambores',
                color: Colors.blueAccent,
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Agrupaciones Musicales',
                  content: 'Agrupaciones musicales',
              ),
              SizedBox(height: 8),
              CardWidget(
                  title: 'Bandas de Música',
                  content: 'Bandas de música.',
                  color: Colors.redAccent,
              ),
              SizedBox(height: 8),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectHdadScreen(
                  dia: title,
                )
              )
            ),
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
