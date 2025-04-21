import 'package:CAPPirote/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MiAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 182, 85, 199),
      title: Center(
        child: Text(
          "CAPPirote",
          style: GoogleFonts.rubikWetPaint(color: Colors.white, fontSize: 24),
        ),
      ),
      actions: [
        /*Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: IconButton(
            icon: const Icon(Icons.search,),
            onPressed: () {  },
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                onPressed: () {
                  if (authProvider.isAuthenticated) {
                    context.push('/profile');
                  } else {
                    context.push('/login');
                  }
                },
                icon: (authProvider.isAuthenticated) 
                ? (authProvider.user!.avatar.isNotEmpty) 
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(authProvider.user!.avatar),
                    radius: 12.0,
                  )
                  : const Icon(Icons.account_circle)
                : const Icon(Icons.account_circle)
              );
            }
          ),
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
