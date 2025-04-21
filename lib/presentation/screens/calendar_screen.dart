import 'package:CAPPirote/components/miappbar.dart';
import 'package:CAPPirote/entities/evento.dart';
import 'package:CAPPirote/helpers/helpereventos.dart';
import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Evento>> _selectedEvents;
  late Map<DateTime, List<Evento>> _events = {};
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  Future<void> _loadEvents() async {
    try {
      Map<DateTime, List<Evento>> events = await getEvents();
      setState(() {
        _events = events;
      });
      _selectedEvents.value = _getEventsForDay(_selectedDay);
    } catch (error) {
      throw Exception('Error al cargar eventos');
    }
  }

  DateTime normalizeDate(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  // Obtener eventos para un día específico
  List<Evento> _getEventsForDay(DateTime day) {
    //Del DateTime quito la parte de horas, min y segundos
    DateTime normalizedDay = normalizeDate(day);
    List<Evento> eventosDelDia = [];

    _events.forEach((key, value) {
      DateTime keyNormalizada = DateTime(key.year, key.month, key.day);

      if (keyNormalizada == normalizedDay) {
        eventosDelDia.addAll(value);
      }
    });
    return eventosDelDia;
  }
  void borrarEvento(BuildContext context, int idEvento) {
    var authdata = Provider.of<AuthProvider>(context, listen:false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este evento?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              deleteEvento(idEvento, authdata.token);
              context.pop();
              setState(() {
                _events.forEach((key, eventos) {
                  eventos.removeWhere((evento) => evento.id == idEvento);
                });
                _selectedEvents.value = _getEventsForDay(_selectedDay);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evento eliminado exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget? buildDeleteButton(BuildContext context, AuthProvider authdata, Evento evento) {
    //Si el usuario publico el evento o si es admin
    if (authdata.isAuthenticated && 
      (evento.nombreUsuario == authdata.user?.nombre || authdata.user!.rol == 'Admin')) {
      return IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          borrarEvento(context, evento.id);
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authdata = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: const MiAppBar(),
      body: Column(
        children: [
          TableCalendar(
            locale: 'es-ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mes',
              CalendarFormat.week: 'Semana',
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, 
              titleCentered: true
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents.value = _getEventsForDay(selectedDay);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
          ),
          const SizedBox(height: 8.0),
          // Mostrar los eventos del día seleccionado
          Expanded(
            child: ValueListenableBuilder<List<Evento>>(
              valueListenable: _selectedEvents,
              builder: (context, events, _) {
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final evento = events[index];
                    final fecha = DateFormat('dd-MM-yyyy HH:mm').format(evento.fecha);

                    return Card(
                      child: ListTile(
                        title: Text(evento.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: $fecha'),
                            Text('Descripción: ${evento.descripcion}'),
                            Text('\nPublicado por: ${evento.nombreUsuario}'),
                          ],
                        ),
                        trailing: buildDeleteButton(context, authdata, evento)
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Formulario para agregar un evento
          if(authdata.isAuthenticated == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.push('/eventos/crear');
              },
              child: const Text('Agregar Evento'),
            ),
          ),
        ],
      ),
    );
  }

}
