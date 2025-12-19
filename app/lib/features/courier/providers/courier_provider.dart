import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';

/// Proof upload state
class ProofUploadState {
  final List<XFile> photos;
  final double actualWeight;
  final String otp;
  final Map<int, double> uploadProgress; // index -> progress 0..1

  const ProofUploadState({
    this.photos = const [],
    this.actualWeight = 0,
    this.otp = '',
    this.uploadProgress = const {},
  });

  bool get canSubmit =>
      photos.length >= 2 && actualWeight > 0 && otp.length == 6;

  ProofUploadState copyWith({
    List<XFile>? photos,
    double? actualWeight,
    String? otp,
    Map<int, double>? uploadProgress,
  }) {
    return ProofUploadState(
      photos: photos ?? this.photos,
      actualWeight: actualWeight ?? this.actualWeight,
      otp: otp ?? this.otp,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

/// Courier state
class CourierState {
  final List<PickupRequestModel> todayTasks;
  final List<PickupRequestModel> upcomingTasks;
  final List<PickupRequestModel> completedTasks;
  final PickupRequestModel? selectedTask;
  final ProofUploadState proofState;
  final bool isLoading;
  final String? errorMessage;

  const CourierState({
    this.todayTasks = const [],
    this.upcomingTasks = const [],
    this.completedTasks = const [],
    this.selectedTask,
    this.proofState = const ProofUploadState(),
    this.isLoading = false,
    this.errorMessage,
  });

  CourierState copyWith({
    List<PickupRequestModel>? todayTasks,
    List<PickupRequestModel>? upcomingTasks,
    List<PickupRequestModel>? completedTasks,
    PickupRequestModel? selectedTask,
    ProofUploadState? proofState,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CourierState(
      todayTasks: todayTasks ?? this.todayTasks,
      upcomingTasks: upcomingTasks ?? this.upcomingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      selectedTask: selectedTask ?? this.selectedTask,
      proofState: proofState ?? this.proofState,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Courier notifier
class CourierNotifier extends StateNotifier<CourierState> {
  final Ref _ref;
  final FirebaseService _firebase;
  final PickupRepository _pickupRepository;
  final PointLedgerRepository _ledgerRepository;
  final UserRepository _userRepository;

  CourierNotifier(this._ref)
      : _firebase = FirebaseService(),
        _pickupRepository = PickupRepository(),
        _ledgerRepository = PointLedgerRepository(),
        _userRepository = UserRepository(),
        super(const CourierState()) {
    _init();
  }

  Future<void> _init() async {
    final authState = _ref.read(authProvider);
    if (authState.isCourier) {
      await loadTasks();
    }
  }

  String _statusValue(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return 'pending';
      case PickupStatus.assigned:
        return 'assigned';
      case PickupStatus.onTheWay:
        return 'on_the_way';
      case PickupStatus.arrived:
        return 'arrived';
      case PickupStatus.pickedUp:
        return 'picked_up';
      case PickupStatus.completed:
        return 'completed';
      case PickupStatus.cancelled:
        return 'cancelled';
    }
  }

  /// Load all tasks
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);

    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final courierId = authState.user!.uid;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
      final activeStatuses = [
        _statusValue(PickupStatus.pending),
        _statusValue(PickupStatus.assigned),
        _statusValue(PickupStatus.onTheWay),
        _statusValue(PickupStatus.arrived),
        _statusValue(PickupStatus.pickedUp),
      ];

      // Today's tasks
      final todayQuery = await _firebase.firestore
          .collection('pickupRequests')
          .where('courierId', isEqualTo: courierId)
          .where('pickupDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('pickupDate',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('status', whereIn: activeStatuses)
          .get();

      // Unassigned pending tasks (self-assign). Ambil tanpa filter tanggal, lalu
      // akan dipilah menjadi today/upcoming di sisi klien.
      final unassignedPending = await _firebase.firestore
          .collection('pickupRequests')
          .where('status', isEqualTo: _statusValue(PickupStatus.pending))
          .where('courierId', isNull: true)
          .limit(50)
          .get();

      // Upcoming tasks
      final upcomingQuery = await _firebase.firestore
          .collection('pickupRequests')
          .where('courierId', isEqualTo: courierId)
          .where('pickupDate', isGreaterThan: Timestamp.fromDate(endOfDay))
          .where('status', isEqualTo: _statusValue(PickupStatus.assigned))
          .orderBy('pickupDate')
          .limit(20)
          .get();

      // Completed tasks
      final completedQuery = await _firebase.firestore
          .collection('pickupRequests')
          .where('courierId', isEqualTo: courierId)
          .where('status', isEqualTo: _statusValue(PickupStatus.completed))
          .orderBy('updatedAt', descending: true)
          .limit(20)
          .get();

      List<PickupRequestModel> _safeMap(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
        return docs
            .map((doc) {
              try {
                return PickupRequestModel.fromFirestore(doc);
              } catch (_) {
                return null;
              }
            })
            .whereType<PickupRequestModel>()
            .toList();
      }

      // Pisahkan unassigned ke today vs upcoming berdasarkan pickupDate
      final unassignedList = _safeMap(unassignedPending.docs);
      final todayUnassigned = unassignedList.where((p) {
        final d = p.pickupDate;
        return d.isAfter(startOfDay.subtract(const Duration(milliseconds: 1))) &&
            d.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
      }).toList();
      final upcomingUnassigned = unassignedList.where((p) {
        final d = p.pickupDate;
        return d.isAfter(endOfDay);
      }).toList();

      state = state.copyWith(
        todayTasks: [
          ..._safeMap(todayQuery.docs),
          ...todayUnassigned,
        ],
        upcomingTasks: [
          ..._safeMap(upcomingQuery.docs),
          ...upcomingUnassigned,
        ],
        completedTasks: _safeMap(completedQuery.docs),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Select task
  Future<void> selectTask(String taskId) async {
    try {
      final task = await _pickupRepository.getPickupRequestById(taskId);
      if (task != null) {
        state = state.copyWith(selectedTask: task);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Update task status
  Future<bool> updateTaskStatus(String taskId, PickupStatus newStatus) async {
    state = state.copyWith(isLoading: true);

    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) {
        throw 'Tidak ada akun kurir aktif';
      }

      // Build update payload: status + timestamps + (if belum ada) data kurir
      final data = <String, dynamic>{
        'status': _statusValue(newStatus),
      };

      // Tambahkan data kurir jika belum terisi (self-assign)
      final currentTask = state.selectedTask;
      if (currentTask == null || currentTask.courierId == null) {
        data['courierId'] = authState.user!.uid;
        data['courierName'] = authState.user!.name;
        data['courierPhone'] = authState.user!.phone;
        data['assignedAt'] = FieldValue.serverTimestamp();
      }

      // Capai timestamp status
      if (newStatus == PickupStatus.onTheWay) {
        data['onTheWayAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == PickupStatus.arrived) {
        data['arrivedAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == PickupStatus.pickedUp) {
        data['pickedUpAt'] = FieldValue.serverTimestamp();
      } else if (newStatus == PickupStatus.completed) {
        data['completedAt'] = FieldValue.serverTimestamp();
      }

      await _pickupRepository.updatePickupRequest(taskId, data);

      // Reload task
      await selectTask(taskId);
      await loadTasks();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // Proof upload methods
  void addPhoto(XFile photo) {
    if (state.proofState.photos.length >= 4) return;

    final newPhotos = [...state.proofState.photos, photo];
    final newProgress = Map<int, double>.from(state.proofState.uploadProgress);
    newProgress[newPhotos.length - 1] = 0; // seed progress to show state

    state = state.copyWith(
      proofState: state.proofState.copyWith(
        photos: newPhotos,
        uploadProgress: newProgress,
      ),
    );
  }

  void removePhoto(int index) {
    final newPhotos = [...state.proofState.photos];
    newPhotos.removeAt(index);
    state = state.copyWith(
      proofState: state.proofState.copyWith(photos: newPhotos),
    );
  }

  void setActualWeight(double weight) {
    state = state.copyWith(
      proofState: state.proofState.copyWith(actualWeight: weight),
    );
  }

  void setOTP(String otp) {
    state = state.copyWith(
      proofState: state.proofState.copyWith(otp: otp),
    );
  }

  void _setUploadProgress(int index, double progress) {
    final newMap = Map<int, double>.from(state.proofState.uploadProgress)
      ..[index] = progress;
    state = state.copyWith(
      proofState: state.proofState.copyWith(uploadProgress: newMap),
    );
  }

  /// Submit proof and complete task
  Future<ProofSubmitResult?> submitProof(String taskId) async {
    if (!state.proofState.canSubmit) return null;

    state = state.copyWith(isLoading: true);

    try {
      final task =
          state.selectedTask ?? await _pickupRepository.getPickupRequestById(taskId);
      if (task == null) throw 'Tugas tidak ditemukan';

      final otpValid =
          await _pickupRepository.verifyOtp(taskId, state.proofState.otp);
      if (!otpValid) {
        throw 'Kode OTP salah';
      }

      // Upload photos to Firebase Storage
      final photoUrls = await Future.wait(
        state.proofState.photos.asMap().entries.map((entry) async {
          final idx = entry.key;
          final file = File(entry.value.path);
          final path = 'proof_photos/$taskId/${DateTime.now().millisecondsSinceEpoch}_$idx.jpg';
          return _firebase.uploadFile(
            file: file,
            path: path,
            contentType: 'image/jpeg',
            onProgress: (p) => _setUploadProgress(idx, p),
          );
        }),
      );

      final actualPoints = (state.proofState.actualWeight * 50).round();

      // Tandai sudah diambil sebelum selesai untuk konsistensi status
      await _pickupRepository.updateStatus(taskId, _statusValue(PickupStatus.pickedUp));

      await _pickupRepository.completePickup(
        requestId: taskId,
        actualWeightKg: state.proofState.actualWeight,
        actualPoints: actualPoints,
        proofPhotoUrls: photoUrls,
      );

      final user = await _userRepository.getById(task.userId);
      final newBalance = (user?.pointBalance ?? 0) + actualPoints;
      await _userRepository.updatePointBalance(task.userId, newBalance);
      await _ledgerRepository.recordEarn(
        userId: task.userId,
        amount: actualPoints,
        description: 'Pickup #${taskId.substring(0, 8)}',
        relatedId: taskId,
        relatedCollection: 'pickupRequests',
      );

      // Reset proof state
      state = state.copyWith(
        proofState: const ProofUploadState(),
        isLoading: false,
      );

      await loadTasks();
      return ProofSubmitResult(
        actualWeight: state.proofState.actualWeight,
        actualPoints: actualPoints,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void resetProofState() {
    state = state.copyWith(proofState: const ProofUploadState());
  }
}

/// Provider
final courierProvider =
    StateNotifierProvider<CourierNotifier, CourierState>((ref) {
  return CourierNotifier(ref);
});

class ProofSubmitResult {
  final double actualWeight;
  final int actualPoints;

  ProofSubmitResult({required this.actualWeight, required this.actualPoints});
}
