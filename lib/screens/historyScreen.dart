import 'package:flutter/material.dart';
import '../services/predictionService.dart';
import '../models/predictionHistoryModel.dart';
import '../widgets/predictionCard.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PredictionService _service = PredictionService();
  late Future<List<PredictionModel>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = _service.getHistory();
  }

  // Permite recargar jalando hacia abajo
  Future<void> _refresh() async {
    setState(() {
      _futureHistory = _service.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Mis Predicciones',
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<PredictionModel>>(
          future: _futureHistory,
          builder: (context, snapshot) {
            // 1. Estado de Carga
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Estado de Error (Layout Elástico)
            if (snapshot.hasError) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody:
                        false, // <--- LA CLAVE: Permite centrar si sobra espacio
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centra verticalmente
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            '¡Ups! Algo salió mal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Contenedor seguro para el texto del error
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Detalle: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Envolvemos en ListView para permitir el gesto de Refresh
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ), // Empujamos hacia abajo
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aún no has hecho predicciones',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          'Desliza hacia abajo para actualizar',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // 4. Estado de Éxito (Lista)
            final predictions = snapshot.data!;

            return ListView.builder(
              // IMPORTANTE: Física para que siempre rebote bonito
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final item = predictions[index];
                return PredictionCard(
                  price: item
                      .predictedPrice, // Asegúrate que tu modelo use el nombre correcto
                  area: item.meters, // Verifica nombres en tu modelo
                  rooms: item.rooms,
                  date: item.date, // Verifica nombres en tu modelo
                );
              },
            );
          },
        ),
      ),
    );
  }
}
