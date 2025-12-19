// SCREEN 2: Proof Upload
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/courier_provider.dart';
import '../../widgets/photo_upload_grid.dart';
import '../../widgets/otp_input.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/loading_overlay.dart';

class CourierProofScreen extends ConsumerWidget {
  final String taskId;
  const CourierProofScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courierState = ref.watch(courierProvider);
    final proofState = courierState.proofState;

    return LoadingOverlay(
      isLoading: courierState.isLoading,
      message: 'Mengirim bukti...',
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('UPLOAD BUKTI SETORAN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoUploadGrid(
                photos: proofState.photos,
                progress: proofState.uploadProgress,
                isUploading: courierState.isLoading,
                onAddPhoto: (photo) =>
                    ref.read(courierProvider.notifier).addPhoto(photo),
                onRemovePhoto: (index) =>
                    ref.read(courierProvider.notifier).removePhoto(index),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Berat Aktual',
                hintText: '0.0',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  final weight = double.tryParse(value) ?? 0;
                  ref.read(courierProvider.notifier).setActualWeight(weight);
                },
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('kg',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                ),
              ),
              if (courierState.selectedTask != null) ...[
                const SizedBox(height: 8),
                Text(
                    'Estimasi: ${courierState.selectedTask!.estimatedWeight} kg',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
              ],
              const SizedBox(height: 24),
              OTPInput(
                onChanged: (otp) =>
                    ref.read(courierProvider.notifier).setOTP(otp),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Color(0xFF1E40AF), size: 18),
                        SizedBox(width: 8),
                        Text('Pastikan:',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF))),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text('• Foto jelas & terang',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E3A8A))),
                    Text('• Berat sesuai timbangan',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E3A8A))),
                    Text('• OTP benar dari customer',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E3A8A))),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2))
          ]),
          child: SafeArea(
            top: false,
              child: PrimaryButton(
                text: 'SELESAIKAN TUGAS',
                onPressed: proofState.canSubmit
                    ? () async {
                      final result = await ref
                          .read(courierProvider.notifier)
                          .submitProof(taskId);
                      if (result != null && context.mounted) {
                        context.go(
                            '/courier/task/$taskId/success?weight=${result.actualWeight}&points=${result.actualPoints}');
                      } else if (result == null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  courierState.errorMessage ?? 'Gagal submit'),
                              backgroundColor: const Color(0xFFEF4444)),
                        );
                      }
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
