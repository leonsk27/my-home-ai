import 'package:flutter/material.dart';
import 'package:my_home/config/theme.dart';
import 'package:my_home/services/storageService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "Cargando...";
  String _email = "usuario@email.com"; // Puedes guardar esto también en login
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Sincronizar el switch con el estado actual del tema
    final currentMode = ThemeManager().themeNotifier.value;
    _isDarkMode = currentMode == ThemeMode.dark;
  }

  // Cargar datos guardados en el Login
  Future<void> _loadUserData() async {
    final storage = StorageService();
    final storedName = await storage.getUsername();
    setState(() {
      _username = storedName ?? 'Invitado'; 
    });
  }

  Future<void> _logout() async {
    final storage = StorageService();
    await storage.deleteAll();

    if (mounted) {
      // Navegar al Login y eliminar todo el historial de navegación
      Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. HEADER DEL PERFIL
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent.shade100,
                    child: Text(
                      _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 40, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _username,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // 2. SECCIÓN DE AJUSTES
            _buildSectionHeader('Configuración'),
            
            // Switch de Tema
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: SwitchListTile(
                title: const Text('Modo Oscuro', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Cambiar apariencia de la app'),
                secondary: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode, 
                  color: Colors.blueAccent
                ),
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                  ThemeManager().toggleTheme(val); // <--- Mágia aquí
                },
              ),
            ),

            const SizedBox(height: 24),

            // 3. SECCIÓN DE CUENTA
            _buildSectionHeader('Cuenta'),
            
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: _logout,
              ),
            ),
             const SizedBox(height: 24),
              Text(
                'Versión 1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}