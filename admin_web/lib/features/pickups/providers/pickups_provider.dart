import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

/// Status filter for pickups (null = all).
final pickupStatusFilterProvider = StateProvider<String?>((ref) => null);

/// Search text (pickup id, userId, address).
final pickupSearchProvider = StateProvider<String>((ref) => '');

/// Stream of pickups from Firestore with client-side filter/search.
final pickupsStreamProvider =
    StreamProvider.autoDispose<List<PickupRequestModel>>((ref) {
  final statusFilter = ref.watch(pickupStatusFilterProvider);
  final search = ref.watch(pickupSearchProvider).toLowerCase().trim();

  return FirebaseFirestore.instance
      // Use the same collection name as the mobile app/shared repository
      .collection('pickupRequests')
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((snapshot) {
    final items = snapshot.docs
        .map((doc) => PickupRequestModel.fromFirestore(doc))
        .toList();

    final filtered = items.where((p) {
      final matchesStatus =
          statusFilter == null || p.status.name == statusFilter;

      if (!matchesStatus) return false;

      if (search.isEmpty) return true;

      final haystack = [
        p.id,
        p.userId,
        p.courierId ?? '',
        p.addressSnapshot['fullAddress']?.toString() ?? '',
        p.addressSnapshot['recipientName']?.toString() ?? '',
      ].join(' ').toLowerCase();

      return haystack.contains(search);
    }).toList();

    return filtered;
  });
});
