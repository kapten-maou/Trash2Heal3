import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/voucher_scan_model.dart';
import '../services/firebase_service.dart';

class VoucherScanRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('voucherScans');

  // CREATE - Record scan
  Future<String> recordScan(VoucherScanModel scan) async {
    try {
      final now = DateTime.now();
      final data = scan
          .copyWith(
            scannedAt: now,
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      _firebase.logEvent('voucher_scanned');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to record scan',
        );
      }
      rethrow;
    }
  }

  // READ - Get by ID
  Future<VoucherScanModel?> getScanById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return VoucherScanModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scan by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get scan by voucher code
  Future<VoucherScanModel?> getScanByVoucherCode(String voucherCode) async {
    try {
      final snapshot = await _collection
          .where('voucherCode', isEqualTo: voucherCode)
          .orderBy('scannedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return VoucherScanModel.fromFirestore(snapshot.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scan by voucher code: $voucherCode',
        );
      }
      rethrow;
    }
  }

  // READ - Check if voucher is already used
  Future<bool> isVoucherUsed(String voucherCode) async {
    try {
      final snapshot = await _collection
          .where('voucherCode', isEqualTo: voucherCode)
          .where('status', isEqualTo: 'valid')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to check if voucher is used: $voucherCode',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by user
  Future<List<VoucherScanModel>> getScansByUser(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by user: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by event
  Future<List<VoucherScanModel>> getScansByEvent(String eventId) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by event: $eventId',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by item
  Future<List<VoucherScanModel>> getScansByItem(String itemId) async {
    try {
      final snapshot = await _collection
          .where('itemId', isEqualTo: itemId)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by item: $itemId',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by scanner
  Future<List<VoucherScanModel>> getScansByScanner(String scannerId) async {
    try {
      final snapshot = await _collection
          .where('scannedBy', isEqualTo: scannerId)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by scanner: $scannerId',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by status
  Future<List<VoucherScanModel>> getScansByStatus(ScanStatus status) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by status: ${status.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get fraudulent scans
  Future<List<VoucherScanModel>> getFraudulentScans() async {
    try {
      final snapshot = await _collection
          .where('isFraudulent', isEqualTo: true)
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get fraudulent scans',
        );
      }
      rethrow;
    }
  }

  // READ - Get scans by date range
  Future<List<VoucherScanModel>> getScansByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _collection
          .where('scannedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('scannedAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('scannedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get scans by date range',
        );
      }
      rethrow;
    }
  }

  // READ - Get scan statistics for event
  Future<Map<String, int>> getEventScanStatistics(String eventId) async {
    try {
      final snapshot =
          await _collection.where('eventId', isEqualTo: eventId).get();

      final scans = snapshot.docs
          .map((doc) => VoucherScanModel.fromFirestore(doc))
          .toList();

      return {
        'total': scans.length,
        'valid': scans.where((s) => s.status == ScanStatus.valid).length,
        'used': scans.where((s) => s.status == ScanStatus.used).length,
        'expired': scans.where((s) => s.status == ScanStatus.expired).length,
        'invalid': scans.where((s) => s.status == ScanStatus.invalid).length,
        'fraud': scans.where((s) => s.status == ScanStatus.fraud).length,
      };
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get event scan statistics: $eventId',
        );
      }
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateScan(String id, Map<String, dynamic> updates) async {
    try {
      await _collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('voucher_scan_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update scan: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Verify scan
  Future<void> verifyScan(String id, String verifierId) async {
    try {
      await _collection.doc(id).update({
        'verifiedAt': FieldValue.serverTimestamp(),
        'verifiedBy': verifierId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('voucher_scan_verified');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to verify scan: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark as fraudulent
  Future<void> markAsFraudulent(String id, String reason) async {
    try {
      await _collection.doc(id).update({
        'isFraudulent': true,
        'fraudReason': reason,
        'status': 'fraud',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('voucher_scan_fraud_detected');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark scan as fraudulent: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Change status
  Future<void> changeScanStatus(String id, ScanStatus status,
      {String? reason}) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (reason != null) {
        updates['invalidReason'] = reason;
      }

      await _collection.doc(id).update(updates);

      _firebase.logEvent('voucher_scan_status_changed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to change scan status: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteScan(String id) async {
    try {
      await _collection.doc(id).delete();

      _firebase.logEvent('voucher_scan_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete scan: $id',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch scan
  Stream<VoucherScanModel?> watchScan(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return VoucherScanModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch scans by event
  Stream<List<VoucherScanModel>> watchScansByEvent(String eventId) {
    return _collection
        .where('eventId', isEqualTo: eventId)
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VoucherScanModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch scans by user
  Stream<List<VoucherScanModel>> watchScansByUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VoucherScanModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch recent scans (last 24 hours)
  Stream<List<VoucherScanModel>> watchRecentScans() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _collection
        .where('scannedAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(yesterday))
        .orderBy('scannedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VoucherScanModel.fromFirestore(doc))
            .toList());
  }
}
