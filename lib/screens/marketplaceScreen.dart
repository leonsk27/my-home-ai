import 'package:flutter/material.dart';
import '../models/listHouseModel.dart';
import '../widgets/listingCard.dart';
import 'publishScreen.dart'; // Importamos la pantalla de formulario

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propiedades en Venta', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Navegar al formulario
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PublishScreen()));
            },
            icon: const Icon(Icons.add_circle_outline, size: 28,),
            tooltip: 'Publicar Propiedad',
          ),
          const SizedBox(width: 8,)
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ListingModel.dummyData.length,
        itemBuilder: (context, index) {
          final house = ListingModel.dummyData[index];
          return ListingCard(listing: house);
        },
      ),
    );
  }
}