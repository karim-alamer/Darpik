// import 'dart:io';
// import 'package:darpik/controllers/advertisement_controller.dart';
// import 'package:darpik/models/advertisementsModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';

// class AdForm extends StatefulWidget {
//   final Advertisement? ad;
//   const AdForm({super.key, this.ad});

//   @override
//   State<AdForm> createState() => _AdFormState();
// }

// class _AdFormState extends State<AdForm> {
//   File? _selectedImage;
//  // final ImagePicker _picker = ImagePicker();
//   final AdvertisementController _controller = Get.find();
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameController;
//   late final TextEditingController _latController;
//   late final TextEditingController _lngController;
//     late final TextEditingController _imageController;
//   late final TextEditingController _categoryController;
//   late final TextEditingController _priceController;
//   late final TextEditingController _rateController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   void _initializeControllers() {
//     final ad = widget.ad;
//     _nameController = TextEditingController(text: ad?.name ?? '');
//     _latController = TextEditingController(
//         text: ad?.position.latitude.toStringAsFixed(6) ?? '');
//     _lngController = TextEditingController(
//         text: ad?.position.longitude.toStringAsFixed(6) ?? '');
//     _categoryController = TextEditingController(text: ad?.category ?? '');
//     _priceController = TextEditingController(text: ad?.price ?? '');
//     _rateController =
//         TextEditingController(text: ad?.rate.toStringAsFixed(1) ?? '');
//   }

//   // Future<void> _pickImage() async {
//   //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//   //   if (image != null) {
//   //     setState(() => _selectedImage = File(image.path));
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildNameField(),
//               const SizedBox(height: 16),
//               _buildImageSection(),
//               const SizedBox(height: 16),
//               _buildCoordinateFields(),
//               const SizedBox(height: 16),
//               _buildCategoryField(),
//               const SizedBox(height: 16),
//               _buildPriceField(),
//               const SizedBox(height: 16),
//               _buildRateField(),
//               const SizedBox(height: 24),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNameField() => TextFormField(
//         controller: _nameController,
//         decoration: const InputDecoration(labelText: 'اسم الإعلان'),
//         validator: (value) => value?.isEmpty ?? true ? 'حقل مطلوب' : null,
//       );

//   Widget _buildImageSection() => Column(
//         children: [
//           _buildImagePreview(),
//           const SizedBox(height: 10),
//           _buildImagePicker(),
//         ],
//       );

//   Widget _buildImagePreview() {
//     if (_selectedImage != null) {
//       return Image.file(_selectedImage!, height: 150, fit: BoxFit.cover);
//     }
//     if (widget.ad?.imagePath != null) {
//       return Image.network(widget.ad!.imagePath,
//           height: 150, fit: BoxFit.cover);
//     }
//     return Image.network(
//       'https://freeimage.host/i/3RewfPn',
//       height: 150,
//       fit: BoxFit.cover,
//     );
//   }

//   Widget _buildImagePicker() {
//     final defaultImageUrl = 'https://iili.io/30RK1rQ.jpg';
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.network(defaultImageUrl, height: 150),
//         const SizedBox(height: 8),
//         // ✅ حقل إدخال المسار أو الرابط
//         TextFormField(
//           controller: _imageController,
//           decoration: const InputDecoration(
//             labelText: 'Image Path or URL',
//           ),
//           onChanged: (_) => setState(() {}), // علشان نعيد بناء صورة المعاينة
//         ),

//         // ✅ عرض المعاينة
//       ],
//     );
//   }

//   Widget _buildCoordinateFields() => Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: _latController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'خط العرض'),
//               validator: (value) => _validateCoordinate(value, -90, 90),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: TextFormField(
//               controller: _lngController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'خط الطول'),
//               validator: (value) => _validateCoordinate(value, -180, 180),
//             ),
//           ),
//         ],
//       );

//   Widget _buildCategoryField() {
//     return DropdownButtonFormField<String>(
//       value:
//           _categoryController.text.isNotEmpty ? _categoryController.text : null,
//       decoration: const InputDecoration(labelText: 'Category'),
//       items: _controller.categories.keys.map((String category) {
//         return DropdownMenuItem<String>(
//           value: category,
//           child: Row(
//             children: [
//               Icon(_controller.categories[category], size: 20),
//               const SizedBox(width: 8),
//               Text(category),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           _categoryController.text = newValue!;
//         });
//       },
//       validator: (value) => value == null ? 'Required field' : null,
//     );
//   }

//   Widget _buildPriceField() => TextFormField(
//         controller: _priceController,
//         decoration: const InputDecoration(labelText: 'السعر'),
//         validator: (value) => value?.isEmpty ?? true ? 'حقل مطلوب' : null,
//       );

//   Widget _buildRateField() => TextFormField(
//         controller: _rateController,
//         keyboardType: TextInputType.number,
//         decoration: const InputDecoration(labelText: 'التقييم (0-5)'),
//         validator: (value) {
//           if (value?.isEmpty ?? true) return 'حقل مطلوب';
//           final rating = double.tryParse(value!);
//           if (rating == null) return 'رقم غير صحيح';
//           if (rating < 0 || rating > 5) return 'يجب أن يكون بين 0 و 5';
//           return null;
//         },
//       );

//   Widget _buildSubmitButton() => ElevatedButton(
//         onPressed: _submitForm,
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: Text(widget.ad == null ? 'إضافة إعلان' : 'تحديث الإعلان'),
//       );

//   String? _validateCoordinate(String? value, double min, double max) {
//     if (value?.isEmpty ?? true) return 'حقل مطلوب';
//     final number = double.tryParse(value!);
//     if (number == null) return 'رقم غير صحيح';
//     if (number < min || number > max) return 'يجب أن يكون بين $min و $max';
//     return null;
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       String imagePath =
//           widget.ad?.imagePath ?? 'https://freeimage.host/i/3RewfPn';

//       if (_selectedImage != null) {
//         // استخراج اسم الصورة فقط من المسار
//         imagePath = "assets/images/${_selectedImage!.path.split('/').last}";
//       }

//       final newAd = Advertisement(
//         id: widget.ad?.id ?? '',
//         name: _nameController.text,
//         position: LatLng(
//           double.parse(_latController.text),
//           double.parse(_lngController.text),
//         ),
//         category: _categoryController.text,
//         price: _priceController.text,
//         rate: double.parse(_rateController.text),
//         imagePath: imagePath,
//         isActive: widget.ad?.isActive ?? true,
//       );

//       if (widget.ad == null) {
//         await _controller.addAdvertisement(newAd, _selectedImage);
//       } else {
//         await _controller.updateAdvertisement(newAd);
//       }

//       Get.back();
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل في حفظ الإعلان: ${e.toString()}');
//     }
//   }
// }

import 'dart:io';
import 'package:darpik/controllers/advertisement_controller.dart';
import 'package:darpik/models/advertisementsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AdForm extends StatefulWidget {
  final Advertisement? ad;
  const AdForm({super.key, this.ad});

  @override
  State<AdForm> createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final AdvertisementController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final ad = widget.ad;
    _nameController = TextEditingController(text: ad?.name ?? '');
    _latController = TextEditingController(
        text: ad?.position.latitude.toStringAsFixed(6) ?? '');
    _lngController = TextEditingController(
        text: ad?.position.longitude.toStringAsFixed(6) ?? '');
    _categoryController = TextEditingController(text: ad?.category ?? '');
    _priceController = TextEditingController(text: ad?.price ?? '');
    _rateController =
        TextEditingController(text: ad?.rate.toStringAsFixed(1) ?? '');
    _imageController = TextEditingController(text: ad?.imagePath ?? '');
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _imageController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              const SizedBox(height: 16),
              _buildImageSection(),
              const SizedBox(height: 16),
              _buildCoordinateFields(),
              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildPriceField(),
              const SizedBox(height: 16),
              _buildRateField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() => TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'اسم الإعلان',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value?.isEmpty ?? true ? 'حقل مطلوب' : null,
      );

  Widget _buildImageSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('صورة الإعلان', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          _buildImagePreview(),
          const SizedBox(height: 10),
          _buildImageInputField(),
          const SizedBox(height: 10),
          _buildImagePickerButton(),
        ],
      );

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _getImageWidget(),
    );
  }

  Widget _getImageWidget() {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_selectedImage!, fit: BoxFit.cover),
      );
    }
    
    if (_imageController.text.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          _imageController.text,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / 
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        ),
      );
    }
    
    return _buildPlaceholderWidget();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text('خطأ في تحميل الصورة', style: TextStyle(color: Colors.red[700])),
        ],
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text('لا توجد صورة', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildImageInputField() => TextFormField(
        controller: _imageController,
        decoration: InputDecoration(
          labelText: 'رابط الصورة',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _imageController.clear();
                _selectedImage = null;
              });
            },
          ),
        ),
        onChanged: (value) => setState(() {}),
      );

  Widget _buildImagePickerButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('اختر صورة من المعرض'),
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );

  Widget _buildCoordinateFields() => Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _latController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'خط العرض',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateCoordinate(value, -90, 90),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _lngController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'خط الطول',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateCoordinate(value, -180, 180),
            ),
          ),
        ],
      );

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      value: _categoryController.text.isNotEmpty ? _categoryController.text : null,
      decoration: const InputDecoration(
        labelText: 'التصنيف',
        border: OutlineInputBorder(),
      ),
      items: _controller.categories.keys.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Row(
            children: [
              Icon(_controller.categories[category], size: 20),
              const SizedBox(width: 8),
              Text(category),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _categoryController.text = newValue!;
        });
      },
      validator: (value) => value == null ? 'حقل مطلوب' : null,
    );
  }

  Widget _buildPriceField() => TextFormField(
        controller: _priceController,
        decoration: const InputDecoration(
          labelText: 'السعر',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value?.isEmpty ?? true ? 'حقل مطلوب' : null,
      );

  Widget _buildRateField() => TextFormField(
        controller: _rateController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'التقييم (0-5)',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'حقل مطلوب';
          final rating = double.tryParse(value!);
          if (rating == null) return 'رقم غير صحيح';
          if (rating < 0 || rating > 5) return 'يجب أن يكون بين 0 و 5';
          return null;
        },
      );

  Widget _buildSubmitButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue[700],
          ),
          child: Text(
            widget.ad == null ? 'إضافة إعلان' : 'تحديث الإعلان',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );

  String? _validateCoordinate(String? value, double min, double max) {
    if (value?.isEmpty ?? true) return 'حقل مطلوب';
    final number = double.tryParse(value!);
    if (number == null) return 'رقم غير صحيح';
    if (number < min || number > max) return 'يجب أن يكون بين $min و $max';
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      String imagePath = _imageController.text.trim();
      
      if (_selectedImage != null) {
        imagePath = _selectedImage!.path;
      } else if (imagePath.isEmpty) {
        imagePath = 'https://iili.io/30RK1rQ.jpg'; // صورة افتراضية
      }

      final newAd = Advertisement(
        id: widget.ad?.id ?? '',
        name: _nameController.text,
        position: LatLng(
          double.parse(_latController.text),
          double.parse(_lngController.text),
        ),
        category: _categoryController.text,
        price: _priceController.text,
        rate: double.parse(_rateController.text),
        imagePath: imagePath,
        isActive: widget.ad?.isActive ?? true,
      );

      if (widget.ad == null) {
        await _controller.addAdvertisement(newAd, _selectedImage);
      } else {
        await _controller.updateAdvertisement(newAd);
      }
      Get.back();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ الإعلان: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _rateController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}