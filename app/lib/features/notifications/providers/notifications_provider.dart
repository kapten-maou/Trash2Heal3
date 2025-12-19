// ========== notifications_provider.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationRepository _notifRepo;

  NotificationsProvider(this._notifRepo);

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notifRepo.getNotificationsByUser(uid);
      _notifications.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notifRepo.markAsRead(notificationId);
      await loadNotifications();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _notifRepo.markAllAsRead(uid);
      await loadNotifications();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notifRepo.deleteNotification(notificationId);
      await loadNotifications();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

final notificationsProvider =
    ChangeNotifierProvider<NotificationsProvider>((ref) {
  return NotificationsProvider(NotificationRepository());
});
