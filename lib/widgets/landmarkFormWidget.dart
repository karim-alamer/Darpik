import 'dart:io';
import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/models/landmarkModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class LandmarkForm extends StatefulWidget {
  final Landmark? landmark;

  const LandmarkForm({super.key, this.landmark});

  @override
  State<LandmarkForm> createState() => _LandmarkFormState();
}

class _LandmarkFormState extends State<LandmarkForm> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  final LandmarkService _landmarkService = Get.find();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _imageController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _locationController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final TextEditingController _ratingController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final landmark = widget.landmark;
    _nameController = TextEditingController(text: landmark?.name ?? '');
    _imageController = TextEditingController(
        text: landmark?.imagePath.replaceAll('file://', '').trim() ?? '');
    _latController = TextEditingController(
        text: landmark?.position.latitude.toStringAsFixed(6) ?? '');
    _lngController = TextEditingController(
        text: landmark?.position.longitude.toStringAsFixed(6) ?? '');
    _locationController = TextEditingController(text: landmark?.location ?? '');
    _categoryController = TextEditingController(text: landmark?.category ?? '');
    _priceController = TextEditingController(text: landmark?.price ?? '');
    _ratingController =
        TextEditingController(text: landmark?.rating.toStringAsFixed(1) ?? '');
    _descriptionController =
        TextEditingController(text: landmark?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // ✅ ضبط الاتجاه للغة الإنجليزية
      textDirection: TextDirection.ltr,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // ✅ محاذاة جميع العناصر لليسار
                children: [
                  _buildNameField(),
                  const SizedBox(height: 8),
                  _buildImagePicker(),
                  const SizedBox(height: 8),
                  _buildCoordinateFields(),
                  const SizedBox(height: 8),
                  _buildLocationField(),
                  const SizedBox(height: 8),
                  _buildCategoryField(),
                  const SizedBox(height: 8),
                  _buildPriceField(),
                  const SizedBox(height: 8),
                  _buildRatingField(),
                  const SizedBox(height: 8),
                  _buildDescriptionField(),
                  const SizedBox(height: 12),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Landmark Name'),
      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
    );
  }

  Widget _buildCoordinateFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _latController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Latitude'),
            validator: (value) =>
                _validateCoordinate(value, 'Latitude', -90, 90),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lngController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Longitude'),
            validator: (value) =>
                _validateCoordinate(value, 'Longitude', -180, 180),
          ),
        ),
      ],
    );
  }

  String? _validateCoordinate(
      String? value, String field, double min, double max) {
    if (value?.isEmpty ?? true) return 'Required field';
    final number = double.tryParse(value!);
    if (number == null) return 'Invalid number';
    if (number < min || number > max) return 'Must be between $min and $max';
    return null;
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(labelText: 'Location'),
      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      value:
          _categoryController.text.isNotEmpty ? _categoryController.text : null,
      decoration: const InputDecoration(labelText: 'Category'),
      items: _landmarkService.categories.keys.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Row(
            children: [
              Icon(_landmarkService.categories[category], size: 20),
              const SizedBox(width: 2),
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
      validator: (value) => value == null ? 'Required field' : null,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(labelText: 'Price'),
      validator: (value) => _validateNumber(value, 'Price'),
    );
  }

  Widget _buildRatingField() {
    return TextFormField(
      controller: _ratingController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Rating (0-5)'),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Required field';
        final rating = double.tryParse(value!);
        if (rating == null) return 'Invalid number';
        if (rating < 0 || rating > 5) return 'Must be between 0 and 5';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
    );
  }

  String? _validateNumber(String? value, String field) {
    if (value?.isEmpty ?? true) return 'Required field';
    if (double.tryParse(value!) == null) return 'Invalid number';
    return null;
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: const Text('Save Landmark'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String imagePath = widget.landmark?.imagePath ?? '';

      // if (_selectedImage != null) {
      //   // استخراج اسم الصورة فقط من المسار
      //   imagePath = "assets/images/${_selectedImage!.path.split('/').last}";
      // }

      final landmark = Landmark(
        id: widget.landmark?.id ?? '',
        name: _nameController.text,
        position: LatLng(
          double.parse(_latController.text),
          double.parse(_lngController.text),
        ),
        imagePath: _imageController.text.trim().isNotEmpty
            ? _imageController.text.trim()
            : widget.landmark?.imagePath ?? '', 
        location: _locationController.text,
        rating: double.parse(_ratingController.text),
        category: _categoryController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        isFavorite: widget.landmark?.isFavorite.value ?? false,
      );

      if (widget.landmark == null) {
        _landmarkService.addLandmark(landmark, _selectedImage);
      } else {
        _landmarkService.updateLandmark(landmark);
      }
      Get.back();
    }
  }

  Widget _buildImagePicker() {
    final defaultImageUrl = 'https://iili.io/30RK1rQ.jpg';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(defaultImageUrl, height: 150),
        const SizedBox(height: 8),
        // ✅ حقل إدخال المسار أو الرابط
        TextFormField(
          controller: _imageController,
          decoration: const InputDecoration(
            labelText: 'Image Path or URL',
          ),
          onChanged: (_) => setState(() {}), // علشان نعيد بناء صورة المعاينة
        ),

        // ✅ عرض المعاينة
      ],
    );
  }
}
