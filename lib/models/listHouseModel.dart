class ListingModel {
  final String id;
  final String title;
  final String location;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String imageUrl;

  ListingModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.imageUrl,
  });

  // DATOS ESTÁTICOS DE EJEMPLO (MOCK DATA)
  static List<ListingModel> dummyData = [
    ListingModel(
      id: '1',
      title: 'Casa Minimalista en Zona Norte',
      location: 'Cala Cala, Cochabamba',
      price: 185000,
      bedrooms: 3,
      bathrooms: 2,
      area: 210,
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    ),
    ListingModel(
      id: '2',
      title: 'Departamento Céntrico',
      location: 'Av. Heroínas, Centro',
      price: 85000,
      bedrooms: 2,
      bathrooms: 1,
      area: 95,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
    ),
    ListingModel(
      id: '3',
      title: 'Chalet Clásico en Quillacollo',
      location: 'Zona El Paso, Quillacollo',
      price: 120000,
      bedrooms: 4,
      bathrooms: 3,
      area: 350,
      imageUrl: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=800&q=80',
    ),
  ];
}