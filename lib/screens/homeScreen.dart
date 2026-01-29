import 'package:flutter/material.dart';
import 'package:my_home/screens/historyScreen.dart';
import 'package:my_home/screens/marketplaceScreen.dart';
import 'package:my_home/screens/profileScreen.dart';
import 'package:my_home/widgets/predictModal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 1. CORRECCIÓN DE ORDEN:
  // Lo estándar es: Historial (Izquierda) - Ventas (Centro) - Perfil (Derecha)
  final List<Widget> _pages = [
    const HistoryScreen(),      // index 0
    const MarketplaceScreen(),  // index 1 (Cambiamos Perfil por Marketplace aquí)
    const ProfileScreen(),      // index 2
  ];

  final PageStorageBucket _bucket = PageStorageBucket();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openPredictionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const PredictModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantiene el estado de las páginas (scroll, inputs, etc.)
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),

      // BOTÓN FLOTANTE (IA)
      // Lo ponemos "centerFloat" para que flote ENCIMA de la barra, no incrustado
      // así no choca con el botón del medio.
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
      floatingActionButton: FloatingActionButton(
        onPressed: _openPredictionModal,
        elevation: 4,
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
        ),
      ),

      // BARRA DE NAVEGACIÓN ESTÁNDAR
      // Es más limpia para 3 items y evita colisiones visuales
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelTextStyle: MaterialStateProperty.all(
             const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 65,
          backgroundColor: Theme.of(context).cardColor,
          selectedIndex: _currentIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history, color: Colors.blue),
              label: 'Historial',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: Colors.blue),
              label: 'Ventas',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Colors.blue),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}