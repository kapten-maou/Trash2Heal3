// ========== history_provider.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class HistoryProvider extends ChangeNotifier {
  final PickupRepository _pickupRepo;

  HistoryProvider(this._pickupRepo);

  List<PickupRequestModel> _requests = [];
  bool _isLoading = false;
  String? _error;
  String _statusFilter = 'all';

  List<PickupRequestModel> get requests {
    if (_statusFilter == 'all') return _requests;
    return _requests.where((r) => r.status.name == _statusFilter).toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get statusFilter => _statusFilter;

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _pickupRepo.getByUserId(uid);
      _requests.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelRequest(String requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = _requests.firstWhere((r) => r.id == requestId);
      await _pickupRepo.update(request.id, PickupStatus.cancelled.name);
      await loadHistory();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

final historyProvider = ChangeNotifierProvider<HistoryProvider>((ref) {
  return HistoryProvider(PickupRepository());
});
