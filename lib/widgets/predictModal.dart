import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en pubspec.yaml
import 'package:my_home/services/predictionService.dart';

class PredictModal extends StatefulWidget {
  const PredictModal({super.key});

  @override
  State<PredictModal> createState() => _PredictModalState();
}

class _PredictModalState extends State<PredictModal> {
  final _formKey = GlobalKey<FormState>();
  final _service = PredictionService();
  
  bool _isLoading = false;

  // Variables de Estado (Inputs)
  double _sqMeters = 80;
  int _rooms = 2;
  int _bathrooms = 1;
  int _garage = 1;
  String _location = 'Centro'; // Valor por defecto
  final TextEditingController _yearCtrl = TextEditingController(text: '2010');

  // LISTA DE UBICACIONES (Deben coincidir con tu Backend/Modelo IA)
  final List<String> _locations = [
    'Centro',
    'Norte',
    'Sur',
    'Este',
    'Oeste',
    'Residencial',
    // Agrega aquí las zonas que tu modelo conoce
  ];

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final price = await _service.predictPrice(
        _sqMeters,
        _rooms,
        _bathrooms,
        _garage,
        int.parse(_yearCtrl.text),
        _location,
      );

      if (mounted) {
        Navigator.pop(context); // Cerramos el modal
        _showResultDialog(price); // Mostramos el resultado bonito
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showResultDialog(double price) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🏠 Precio Estimado', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Según nuestra IA, esta propiedad vale:', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text(
              currency.format(price),
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: Colors.green
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Genial', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos el padding inferior para cuando sale el teclado
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% de la pantalla
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Barrita superior
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            
            const Text('Nueva Predicción', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  
                  // 1. AREA (Slider)
                  _buildLabel('Superficie: ${_sqMeters.toInt()} m²'),
                  Slider(
                    value: _sqMeters,
                    min: 20, max: 500, divisions: 480,
                    activeColor: Colors.blueAccent,
                    label: _sqMeters.round().toString(),
                    onChanged: (val) => setState(() => _sqMeters = val),
                  ),

                  const SizedBox(height: 10),

                  // 2. HABITACIONES (Chips)
                  _buildLabel('Habitaciones'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final val = index + 1;
                      return _buildSelectChip(val, _rooms, (v) => setState(() => _rooms = v));
                    }),
                  ),

                  const SizedBox(height: 20),

                  // 3. BAÑOS (Chips)
                  _buildLabel('Baños'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(4, (index) {
                      final val = index + 1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildSelectChip(val, _bathrooms, (v) => setState(() => _bathrooms = v)),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // 4. GARAJE (Dropdown pequeño o Switch)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Garaje'),
                            DropdownButtonFormField<int>(
                              value: _garage,
                              decoration: _inputDecoration(),
                              items: [0, 1, 2, 3, 4].map((e) => DropdownMenuItem(value: e, child: Text('$e autos'))).toList(),
                              onChanged: (val) => setState(() => _garage = val!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 5. AÑO CONSTRUCCIÓN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Año Const.'),
                            TextFormField(
                              controller: _yearCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Requerido';
                                final year = int.tryParse(value);
                                if (year == null || year < 1900 || year > 2030) return 'Año inválido';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 6. UBICACIÓN (Dropdown)
                  _buildLabel('Ubicación'),
                  DropdownButtonFormField<String>(
                    value: _location,
                    decoration: _inputDecoration(),
                    items: _locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                    onChanged: (val) => setState(() => _location = val!),
                  ),
                ],
              ),
            ),

            // BOTÓN DE ACCIÓN
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitPrediction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Calcular Precio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildSelectChip(int value, int groupValue, Function(int) onTap) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onTap(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 45, height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          value.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}