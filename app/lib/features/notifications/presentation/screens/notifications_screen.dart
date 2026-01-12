// ========== notifications_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationsProvider).loadNotifications();
    });
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'pickup_assigned':
        return Icons.local_shipping;
      case 'pickup_completed':
        return Icons.check_circle;
      case 'points_earned':
        return Icons.stars;
      case 'redeem_success':
        return Icons.card_giftcard;
      case 'membership_upgraded':
        return Icons.workspace_premium;
      case 'event_reminder':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'pickup_assigned':
        return Colors.blue;
      case 'pickup_completed':
        return Colors.green;
      case 'points_earned':
        return Colors.amber;
      case 'redeem_success':
        return Colors.purple;
      case 'membership_upgraded':
        return Colors.orange;
      case 'event_reminder':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _handleNotificationTap(notif) {
    // Mark as read
    if (!notif.isRead) {
      ref.read(notificationsProvider).markAsRead(notif.id);
    }

    // Navigate based on type
    if (notif.relatedId != null) {
      switch (notif.type) {
        case 'pickup_assigned':
        case 'pickup_completed':
          context.push('/history/${notif.relatedId}');
          break;
        case 'points_earned':
        case 'redeem_success':
          context.push('/points');
          break;
        case 'event_reminder':
          context.push('/events/${notif.relatedId}');
          break;
      }
    }
  }

  void _confirmDelete(String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Notifikasi'),
        content:
            const Text('Apakah Anda yakin ingin menghapus notifikasi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(notificationsProvider)
                  .deleteNotification(notificationId);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(notificationsProvider);
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        elevation: 0,
        actions: [
          if (provider.unreadCount > 0)
            TextButton.icon(
              onPressed: () => ref.read(notificationsProvider).markAllAsRead(),
              icon: const Icon(Icons.done_all, color: Colors.white, size: 18),
              label: const Text('Tandai Semua',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada notifikasi',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Notifikasi akan muncul di sini',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(notificationsProvider).loadNotifications(),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _buildNotificationCard(notif);
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationCard(notif) {
    final icon = _getNotificationIcon(notif.type);
    final color = _getNotificationColor(notif.type);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hapus Notifikasi'),
            content: const Text('Apakah Anda yakin?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(notificationsProvider).deleteNotification(notif.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : Colors.blue.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notif.title,
                  style: TextStyle(
                    fontWeight:
                        notif.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              ),
              if (!notif.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notif.body),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(notif.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () => _handleNotificationTap(notif),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              if (!notif.isRead)
                const PopupMenuItem(
                  value: 'read',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read, size: 18),
                      SizedBox(width: 8),
                      Text('Tandai Dibaca'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'read') {
                ref.read(notificationsProvider).markAsRead(notif.id);
              } else if (value == 'delete') {
                _confirmDelete(notif.id);
              }
            },
          ),
        ),
      ),
    );
  }
}
