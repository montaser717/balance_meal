import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../UI/profile/profile_view.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pop(context);
                // Öffne später z.B. SettingsView()
              },
            ),
          ],
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index != navigationShell.currentIndex) {
            navigationShell.goBranch(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Tagebuch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Fortschritt'),
        ],
      ),
    );
  }
}
