import 'package:flutter/material.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  // En un MVP real, aquí irían los Controllers
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Propiedad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECCIÓN FOTOS
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.grey.withOpacity(0.5), style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 40, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  const Text('Toca para subir fotos', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FORMULARIO
            const Text('Información Básica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildInput('Título del anuncio', Icons.title, 'Ej. Casa hermosa en Sarco'),
            const SizedBox(height: 16),
            _buildInput('Precio (USD)', Icons.attach_money, '150000', isNumber: true),
            const SizedBox(height: 16),
            _buildInput('Ubicación', Icons.location_on_outlined, 'Selecciona el barrio...'),
            
            const SizedBox(height: 24),
            const Text('Detalles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _buildInput('Habitaciones', Icons.bed, '3', isNumber: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildInput('Baños', Icons.bathtub, '2', isNumber: true)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInput('Superficie (m²)', Icons.square_foot, '200', isNumber: true),

            const SizedBox(height: 32),
            
            // BOTÓN DE ACCIÓN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Acción simulada
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Propiedad publicada con éxito!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('PUBLICAR AHORA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, String hint, {bool isNumber = false}) {
    return TextField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        // fillColor se adaptará al tema si lo configuraste en theme.dart
      ),
    );
  }
}