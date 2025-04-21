import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/entities/hermandad.dart';
import 'package:CAPPirote/helpers/helperhdad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectHdadScreen extends StatefulWidget {
  final String dia;

  const SelectHdadScreen(
      {super.key, required this.dia});

  @override
  SelectHdadScreenState createState() => SelectHdadScreenState();
}

class SelectHdadScreenState extends State<SelectHdadScreen> {
  late Future<List<Hermandad>> hdades;

  @override
  void initState() {
    super.initState();
    hdades = getHdadesbyDia(widget.dia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MiAppBar(),
      body: Center(
        child: FutureBuilder<List<Hermandad>>(
          future: hdades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No se encontraron Hermandades.'));
            } else {
              final hdades = snapshot.data!;
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: GridView.builder(
                    itemCount: hdades.length,
                    padding: const EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (hdades.length == 1) ? 1 : 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                    itemBuilder: (context, index) {
                      final hdad = hdades[index];
                      return HdadCard(hdad: hdad);
                    },
                  ),
                ),
              );
            }
          },
        ),
      )
    );
  }
}

class HdadCard extends StatelessWidget {
  final Hermandad hdad;

  const HdadCard({
    super.key,
    required this.hdad,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        context.push('/hermandades/hdad/${hdad.id}'),
      },
      child: Card(
        elevation: 4.0,
        color: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LayoutBuilder(builder: (context, constraints) {
                double height = constraints.maxWidth * 0.75;
                return Image.asset(
                  hdad.escudo,
                  fit: BoxFit.cover,
                  height: height,
                  width: double.infinity,
                );
              }),
            ),
            const SizedBox(height: 8.0),
            Text(
              hdad.apelativo,
              overflow: TextOverflow.fade,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
