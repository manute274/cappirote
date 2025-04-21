import 'dart:async';
import 'package:CAPPirote/helpers/helpergeolocator.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:CAPPirote/utils/message_manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  final int hdadId;
  const LocationScreen({super.key, required this.hdadId});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  StreamSubscription<Position>? positionStream;
  int? hdadId;
  bool isTracking = false;
  String locationStatus = "Esperando ubicación...";
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    hdadId = widget.hdadId;
    checkPermisos();
  }

  Future<void> checkPermisos() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          locationStatus = "Permiso de ubicación denegado";
        });
        return;
      }
    }
    setState(() {
      locationStatus = "Permiso de ubicación concedido";
    });
  }


  /*void startLocationUpdates() async {
    // Inicio el stream
    positionStream = Geolocator.getPositionStream()
    .listen((Position position) {
      //print("Ubicación nueva: ${position.latitude}, ${position.longitude}");
      sendLocationToServer(position, hdadId!);
    });
    
    setState(() {
      isTracking = true;
    });
  }

  void stopLocationUpdates() {
    if (positionStream != null) {
      positionStream?.cancel();
      positionStream = null;
      setState(() {
        isTracking = false;
        locationStatus = "Envío de ubicación detenido";
      });
    }
  }*/
  
  Future<void> startLocationUpdates() async {
    var authdata = Provider.of<AuthProvider>(context, listen: false);
    try {
      locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        try {
          await sendLocationToServer(position, hdadId!, authdata.token);
        } catch (error) {
          // ignore: use_build_context_synchronously
          MessageManager.handleError(context, error);
        }
      });

      setState(() {
        isTracking = true;
        locationStatus = "Envío de ubicación activado";
      });

    } catch (error) {
       // ignore: use_build_context_synchronously
       MessageManager.handleError(context, error);
    }
  }

  void stopLocationUpdates() {
    locationTimer?.cancel();
    locationTimer = null;

    setState(() {
      isTracking = false;
      locationStatus = "Envío de ubicación detenido";
    });
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geolocalización en Tiempo Real")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationStatus),

            ElevatedButton(
              onPressed: isTracking ? null : startLocationUpdates,
              child: const Text("Iniciar Envío de Ubicación"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isTracking ? stopLocationUpdates : null,
              child: const Text("Detener Envío de Ubicación"),
            ),
            const SizedBox(height: 20),
            /*ElevatedButton(
              onPressed: isTracking ? stopLocationUpdates : null,
              child: const Text("Test"),
            ),*/
          ],
        ),
      ),
    );
  }
}
