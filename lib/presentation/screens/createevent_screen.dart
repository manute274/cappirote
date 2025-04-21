// ignore_for_file: use_build_context_synchronously

import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/helpers/helpereventos.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:CAPPirote/entities/evento.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime? _fecha;
  TimeOfDay? _hora;
  //final _idUsuarioController = TextEditingController();

  // Combinar fecha y hora seleccionadas en un DateTime
  DateTime? get _fechaCompleta {
    if (_fecha != null && _hora != null) {
      return DateTime(
        _fecha!.year,
        _fecha!.month,
        _fecha!.day,
        _hora!.hour,
        _hora!.minute,
      );
    }
    return null;
  }

  void _crearEvento() async {
    final authdata = Provider.of<AuthProvider>(context, listen: false);
    final nuevoEvento = Evento(
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      fecha: _fechaCompleta!,
      nombreUsuario: authdata.user!.nombre,
    );
    await createEvent(nuevoEvento, authdata.user!.id, authdata.token);
    Navigator.pop(context, nuevoEvento);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Evento'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final fechaSeleccionada = await showDatePicker(
                        context: context,
                        initialDate: _fecha,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (fechaSeleccionada != null) {
                        setState(() {
                          _fecha = fechaSeleccionada;
                        });
                      }
                    },
                    child: Text(
                      _fecha !=null
                      ? 'Fecha: ${DateFormat('dd-MM-yyyy').format(_fecha!)}'
                      : 'Seleccionar Fecha'
                    )
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final horaSeleccionada = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (horaSeleccionada != null) {
                        setState(() {
                          _hora = horaSeleccionada;
                        });
                      }
                    },
                    child: Text(
                      _hora != null
                          ? 'Hora: ${_hora!.format(context)}'
                          : 'Seleccionar Hora',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              //BOTON DE GUARDAR
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && 
                  _fecha != null && _hora != null) {
                    _crearEvento();
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor seleccione fecha y hora'))
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
