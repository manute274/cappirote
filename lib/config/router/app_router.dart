import 'package:CAPPirote/presentation/screens/addimageshdad_screen.dart';
import 'package:CAPPirote/presentation/screens/createnoticia_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:CAPPirote/presentation/screens.dart';

// GoRouter configuration
final appRouter = GoRouter(
  debugLogDiagnostics: true,
  
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/noticias/add',
      builder: (context, state) => const CreateNoticiaScreen(),
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/noticias/:id',
      builder: (context, state) {
        final int id = int.parse(state.pathParameters['id']!);
        return NoticiaScreen(noticiaId: id);
      },
    ),

    GoRoute(
      path: '/hermandades',
      builder: (context, state) => const SelectDiaScreen(),
    ),

    GoRoute(
      path: '/hermandades/:dia',
      builder: (context, state) {
        final String dia = state.pathParameters['dia']!;
        return SelectHdadScreen(dia: dia);
      },
    ),

    GoRoute(
      path: '/hermandades/hdad/:id',
      builder: (context, state) {
        final int id = int.parse(state.pathParameters['id']!);
        return HermandadScreen(hdadId: id);
      },
      routes: [
        GoRoute(
        path: 'images/add',
        builder: (context, state) {
          final int hdadId = int.parse(state.pathParameters['id']!);
          return AddImageScreen(idHdad: hdadId);
        }
      ),
      ]
    ),

    GoRoute(
      path: '/eventos',
      builder: (context, state) => const CalendarScreen(),
    ),

    GoRoute(
      path: '/eventos/crear',
      builder: (context, state) => const CreateEventScreen(),
    ),



  ],
);