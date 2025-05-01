import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Advertisement {
  final String id;
  final String name;
  final LatLng position;
  final String imagePath;
  final bool isActive;
  final double rate;
  final String category;
  final String price;

  Advertisement({
    required this.id,
    required this.name,
    required this.position,
    this.imagePath = 'https://freeimage.host/i/3RewfPn',
    required this.rate,
    required this.category,
    required this.price,
    this.isActive = true,
  });

  Advertisement copyWith({
    String? id,
    String? name,
    LatLng? position,
    String? imagePath,
    double? rate,
    String? category,
    String? price,
    bool? isActive,
  }) {
    return Advertisement(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      imagePath: imagePath ?? this.imagePath,
      rate: rate ?? this.rate,
      category: category ?? this.category,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Advertisement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Validate required fields
    _validateField(data, 'name', doc.id);
    _validateField(data, 'position', doc.id);
    _validateField(data, 'category', doc.id);
    _validateField(data, 'price', doc.id);
    _validateField(data, 'rate', doc.id);

    // Handle image path with default
    String imagePath =
        data['imagePath'] as String? ?? 'https://freeimage.host/i/3RewfPn';

    return Advertisement(
      id: doc.id,
      name: data['name'] as String,
      position: _parseGeoPoint(data['position']),
      imagePath: imagePath,
      rate: (data['rate'] as num).toDouble(),
      category: data['category'] as String,
      price: data['price'] as String,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'position': GeoPoint(position.latitude, position.longitude),
      'imagePath': imagePath,
      'rate': rate,
      'category': category,
      'price': price,
      'isActive': isActive,
    };
  }

  static void _validateField(
      Map<String, dynamic> data, String field, String docId) {
    if (data[field] == null) {
      throw Exception('Missing $field field in document $docId');
    }
  }

  static LatLng _parseGeoPoint(dynamic geoData) {
    if (geoData is! GeoPoint) {
      throw Exception('Invalid GeoPoint format');
    }
    return LatLng(geoData.latitude, geoData.longitude);
  }
}
