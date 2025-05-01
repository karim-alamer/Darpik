import 'package:darpik/controllers/advertisement_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darpik/widgets/AdsForm.dart';
import 'package:darpik/models/advertisementsModel.dart';
import 'package:latlong2/latlong.dart';

class AdDashboard extends StatelessWidget {
  final AdvertisementController _controller =
      Get.put(AdvertisementController());

  AdDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure filtering is applied on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.filterByCategory(
          'الكل'); // This should match your controller's default
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads Dashboard'),
        actions: [
          _ResponsiveFilterButton(),
        ],
      ),
      body: _buildResponsiveLayout(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAdDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildAdsList(),
              ),
              Expanded(
                flex: 3,
                child: _buildAdDetails(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(child: _buildAdsList()),
              const Divider(),
              Expanded(child: _buildAdDetails()),
            ],
          );
        }
      },
    );
  }

  Widget _buildAdsList() {
    return Obx(() => ListView.builder(
          itemCount: _controller.advertisements.length,
          itemBuilder: (context, index) {
            final ad = _controller.advertisements[index];
            return _AdListItem(
              ad: ad,
              onTap: () => _controller.currentIndex.value = index,
            );
          },
        ));
  }

  Widget _buildAdDetails() {
    return Obx(() {
      if (_controller.advertisements.isEmpty) {
        return const Center(child: Text('لا توجد إعلانات متاحة'));
      }
      int index = _controller.currentIndex.value;
      if (index >= _controller.advertisements.length) {
        _controller.currentIndex.value = 0;
        index = 0;
      }

      final ad = _controller.advertisements[index];
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _AdDetailCard(ad: ad),
      );
    });
  }

  void _showAddAdDialog() {
    Get.dialog(
    const  AlertDialog(
        title:  Center(child: Text('إضافة إعلان جديد')),
        content: AdForm(),
      ),
    );
  }
}

class _ResponsiveFilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return DropdownButton<String>(
            items: ['All', 'Museums', 'Restaurants', 'Store']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                Get.find<AdvertisementController>().filterByCategory(value!),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          );
        }
      },
    );
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select category'),
            ...['All', 'Museums', 'Restaurants', 'Store']
                .map((e) => ListTile(
                      title: Text(e),
                      onTap: () {
                        Get.find<AdvertisementController>().filterByCategory(e);
                        Get.back();
                      },
                    ))
                .toList(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
class _AdListItem extends StatelessWidget {
  final Advertisement ad;
  final VoidCallback onTap;

  const _AdListItem({required this.ad, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImageWidget(ad.imagePath),
      title: Text(ad.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ad.category),
          Text('السعر: ${ad.price}'),
          Text('التقييم: ${ad.rate}'),
        ],
      ),
      trailing: SizedBox(
        width: 60,
        child: Switch(
          value: ad.isActive,
          onChanged: (value) {
            Get.find<AdvertisementController>().toggleAdStatus(ad);
          },
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildErrorWidget('لا يوجد صورة');
    }

    // إذا كان الرابط من الإنترنت
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      // تحويل روابط freeimage.host إلى iili.io إذا لزم الأمر
      String directUrl = imagePath.contains('freeimage.host')
          ? imagePath.replaceAll('https://freeimage.host/i/', 'https://iili.io/') + '.jpg'
          : imagePath;

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image.network(
            directUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget('خطأ في التحميل'),
          ),
        ),
      );
    }

    // إذا كان مسار ملف محلي
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget('صورة غير موجودة'),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 20, color: Colors.red),
          Text(
            message,
            style: const TextStyle(fontSize: 8, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class _AdDetailCard extends StatelessWidget {
  final Advertisement ad;

  const _AdDetailCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ad.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildDetailImage(ad.imagePath),
            const SizedBox(height: 16),
            _buildDetailRow('التصنيف', ad.category),
            _buildDetailRow('السعر', ad.price),
            _buildDetailRow('التقييم', ad.rate.toString()),
            _buildDetailRow('الحالة', ad.isActive ? 'نشط' : 'غير نشط'),
            _buildPositionDetail(),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _showEditDialog(context),
                  child: const Text('تعديل'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _deleteAd(context),
                  child: const Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailImage(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return _buildErrorWidget('لا يوجد صورة', height: 200);
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      String directUrl = imagePath.contains('freeimage.host')
          ? imagePath.replaceAll('https://freeimage.host/i/', 'https://iili.io/') + '.jpg'
          : imagePath;

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          directUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget('خطأ في تحميل الصورة', height: 200),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget('صورة غير موجودة', height: 200),
      ),
    );
  }

  Widget _buildErrorWidget(String message, {double height = 50}) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: height * 0.2, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: height * 0.1, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPositionDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text('الموقع: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              '${ad.position.latitude.toStringAsFixed(4)}, '
              '${ad.position.longitude.toStringAsFixed(4)}'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Center(child: Text('تعديل الإعلان')),
        content: AdForm(ad: ad),
      ),
    );
  }

  void _deleteAd(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الإعلان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.find<AdvertisementController>().deleteAdvertisement(ad.id);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}