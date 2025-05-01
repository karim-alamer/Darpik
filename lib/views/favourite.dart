// import 'package:darpik/controllers/landmark_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FavouriteView extends GetView<LandmarkController> {
//   const FavouriteView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildFavoritesContent(),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: const Text('المفضلة'),
//       centerTitle: true,
//       backgroundColor: Colors.white,
//       elevation: 0.5,
//     );
//   }

//   Widget _buildFavoritesContent() {
//     return Obx(() {
//       final favorites = controller.favoriteLandmarks;
//       if (favorites.isEmpty) {
//         return const Center(child: Text('لا توجد معالم في المفضلة'));
//       }
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: favorites.length,
//         itemBuilder: (context, index) => _buildLandmarkItem(favorites[index]),
//       );
//     });
//   }

//   Widget _buildLandmarkItem(Landmark landmark) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: InkWell(
//         onTap: () => controller.showLandmarkDetails(landmark),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.asset(
//                     landmark.imagePath,
//                     height: 180,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: IconButton(
//                     icon: Icon(
//                       landmark.isFavorite
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                       color: Colors.red,
//                     ),
//                     onPressed: () => controller.toggleFavorite(landmark),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(landmark.name,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_pin, color: Color(0xFF006D2B)),
//                       const SizedBox(width: 4),
//                       Text(landmark.location,
//                           style: TextStyle(color: Colors.grey[600])),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber, size: 16),
//                       Text('${landmark.rating}',
//                           style: const TextStyle(color: Colors.amber)),
//                       const Spacer(),
//                       Text('ر.س${landmark.price}',
//                           style: const TextStyle(
//                               color: Color(0xFF006D2B),
//                               fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }