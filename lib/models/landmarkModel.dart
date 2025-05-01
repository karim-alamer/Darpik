import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class Landmark {
  final String id;
  final String name;
  final LatLng position;
  final String imagePath;
  final String location;
  final double rating;
  final String category;
  final String price;
  final String description;
  final RxBool isFavorite;

  Landmark({
    required this.id,
    required this.name,
    required this.position,
    required this.imagePath,
    required this.location,
    required this.rating,
    required this.category,
    required this.price,
    required this.description,
    required bool isFavorite,
  }) : isFavorite = RxBool(isFavorite);

  Landmark copyWith({
    String? id,
    String? name,
    LatLng? position,
    String? imagePath,
    String? location,
    double? rating,
    String? category,
    String? price,
    String? description,
    bool? isFavorite,
  }) {
    return Landmark(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite.value,
    );
  }

  factory Landmark.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    if (data['position'] == null) {
      throw Exception('Missing position field in document ${doc.id}');
    }

    // استخدام مسار صورة افتراضي لو الصورة مش موجودة أو فارغة
    String imagePath = data['imagePath'] ?? 'https://iili.io/30RK1rQ.jpg';

    return Landmark(
      id: doc.id,
      name: data['name'],
      position: LatLng(data['position'].latitude, data['position'].longitude),
      imagePath:
          imagePath, // التأكد من استخدام رابط افتراضي لو الصورة مش موجودة
      location: data['location'],
      rating: data['rating'].toDouble(),
      category: data['category'],
      price: data['price'],
      description: data['description'],
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'position': GeoPoint(position.latitude, position.longitude),
      'imagePath': imagePath,
      'location': location,
      'rating': rating,
      'category': category,
      'price': price,
      'description': description,
      'isFavorite': isFavorite.value,
    };
  }
}
