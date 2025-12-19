import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Photo upload grid (2x2) for proof submission
class PhotoUploadGrid extends StatelessWidget {
  final List<XFile> photos;
  final Map<int, double> progress;
  final bool isUploading;
  final ValueChanged<XFile> onAddPhoto;
  final ValueChanged<int> onRemovePhoto;

  const PhotoUploadGrid({
    super.key,
    required this.photos,
    this.progress = const {},
    this.isUploading = false,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Foto Bukti Setoran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            ...List.generate(photos.length, (index) {
              return _buildPhotoItem(context, photos[index], index);
            }),
            if (photos.length < 4) _buildAddButton(context),
          ],
        ),
        const SizedBox(height: 8),
        if (isUploading) ...[
          LinearProgressIndicator(
            value: _overallProgress(),
            backgroundColor: const Color(0xFFE5E7EB),
            color: Theme.of(context).colorScheme.primary,
            minHeight: 6,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          'Min. 2 foto, maks. 4 foto',
          style: TextStyle(
            fontSize: 12,
            color: photos.length >= 2
                ? const Color(0xFF10B981)
                : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, XFile photo, int index) {
    final currentProgress = progress[index];
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _showPreview(context, photo, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              image: DecorationImage(
                image: FileImage(File(photo.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Progress overlay
        if (currentProgress != null && currentProgress < 1)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: currentProgress,
                        color: Colors.white,
                        strokeWidth: 4,
                      ),
                      Text(
                        '${(currentProgress * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => onRemovePhoto(index),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPhotoSourceDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD1D5DB),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add_a_photo,
                size: 32,
                color: Color(0xFF6B7280),
              ),
              SizedBox(height: 8),
              Text(
                'Tambah Foto',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPhotoSourceDialog(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1920,
                    maxHeight: 1080,
                    imageQuality: 85,
                  );
                  if (photo != null) {
                    onAddPhoto(photo);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final photo = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1920,
                    maxHeight: 1080,
                    imageQuality: 85,
                  );
                  if (photo != null) {
                    onAddPhoto(photo);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context, XFile photo, int index) {
    showDialog(
      context: context,
      builder: (ctx) => Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              color: Colors.black,
              child: Center(
                child: InteractiveViewer(
                  child: Image.file(File(photo.path)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
          Positioned(
            top: 24,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
              onPressed: () {
                Navigator.pop(ctx);
                onRemovePhoto(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  double? _overallProgress() {
    if (progress.isEmpty) return null;
    final values = progress.values;
    if (values.isEmpty) return null;
    final avg = values.reduce((a, b) => a + b) / values.length;
    return avg.clamp(0.0, 1.0);
  }
}
