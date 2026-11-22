
import 'package:flutter/material.dart';

import 'screens/register_screen.dart';
import 'screens/consulta_usuarios_busqueda_screen.dart';
import 'screens/actualizar_usuario_screen.dart';
import 'screens/eliminar_usuario_screen.dart';

void main() {
  runApp(const AG12App());
}

class AG12App extends StatelessWidget {
  const AG12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AG12 - Gestión de Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const InicioScreen(),
    );
  }
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  void abrirPantalla(BuildContext context, Widget pantalla) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pantalla,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        centerTitle: true,
      ),

      // MENÚ LATERAL
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.storage,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AG12 - SQLite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Gestión de usuarios',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => Navigator.pop(context),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Insertar usuario'),
              onTap: () => abrirPantalla(
                context,
                const RegisterScreen(),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Consultar usuarios'),
              onTap: () => abrirPantalla(
                context,
                const ConsultaUsuariosBusquedaScreen(),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Actualizar usuario'),
              onTap: () => abrirPantalla(
                context,
                const ActualizarUsuarioScreen(),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Eliminar usuario'),
              onTap: () => abrirPantalla(
                context,
                const EliminarUsuarioScreen(),
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.storage,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),

              const Text(
                'AG12 - Bases de datos con SQLite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Selecciona una opción del menú lateral '
                    'para gestionar los usuarios.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Registrar usuario'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Consultar usuarios'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const ConsultaUsuariosBusquedaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
