import 'package:CAPPirote/helpers/helpergeolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final int hdadId;
  const MapScreen({super.key, required this.hdadId});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _location;

  late final int hdadId;
  bool _isLoading = true;
  bool _error = false;
  

  @override
  void initState() {
    super.initState();
    hdadId = widget.hdadId;
    _loadLocation();
  }

  // Cargar las coordenadas desde la API
  void _loadLocation() async {
    try {
      var location = await getLocationHdad(hdadId);
      setState(() {
        _location = LatLng(location['latitud']!, location['longitud']!);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geolocalización")),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _error
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Error al cargar la ubicación. Puede que no haya datos para esta hermandad.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _loadLocation,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
            : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _location!,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.manuelrodriguez.cappirote',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _location!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    )
                  ]
                )
              ],
            ),
    );
  }
}
