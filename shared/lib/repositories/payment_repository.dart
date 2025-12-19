import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';
import '../services/firebase_service.dart';
import 'dart:math';

class PaymentRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('payments');

  // CREATE - Create payment order
  Future<String> createPayment(PaymentModel payment) async {
    try {
      final now = DateTime.now();
      final orderId = _generateOrderId();
      final invoiceNumber = _generateInvoiceNumber();
      final qrImageUrl =
          _buildQrImageUrl(payment.qrCode ?? payment.vaNumber ?? '');

      final metadata = {
        if (payment.metadata != null) ...payment.metadata!,
        if (qrImageUrl != null) 'qrImageUrl': qrImageUrl,
      };

      final data = payment
          .copyWith(
            orderId: orderId,
            invoiceNumber: invoiceNumber,
            currency: payment.currency ?? 'IDR',
            createdAt: now,
            updatedAt: now,
            expiryDate: now.add(const Duration(hours: 24)),
            metadata: metadata.isEmpty ? payment.metadata : metadata,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      _firebase.logEvent('payment_created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to create payment',
        );
      }
      rethrow;
    }
  }

  String? _buildQrImageUrl(String code) {
    if (code.isEmpty) return null;
    // If backend already provides URL, keep it.
    if (code.startsWith('http')) return code;
    final data = Uri.encodeComponent(code);
    return 'https://api.qrserver.com/v1/create-qr-code/?size=280x280&data=$data';
  }

  // READ - Get by ID
  Future<PaymentModel?> getPaymentById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PaymentModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payment by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get by order ID
  Future<PaymentModel?> getPaymentByOrderId(String orderId) async {
    try {
      final snapshot =
          await _collection.where('orderId', isEqualTo: orderId).limit(1).get();

      if (snapshot.docs.isEmpty) return null;
      return PaymentModel.fromFirestore(snapshot.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payment by order id: $orderId',
        );
      }
      rethrow;
    }
  }

  // READ - Get payments by user
  Future<List<PaymentModel>> getPaymentsByUser(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payments by user: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get payments by membership
  Future<List<PaymentModel>> getPaymentsByMembership(
      String membershipId) async {
    try {
      final snapshot = await _collection
          .where('membershipId', isEqualTo: membershipId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payments by membership: $membershipId',
        );
      }
      rethrow;
    }
  }

  // READ - Get payments by status
  Future<List<PaymentModel>> getPaymentsByStatus(PaymentStatus status) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payments by status: ${status.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get payments by method
  Future<List<PaymentModel>> getPaymentsByMethod(PaymentMethod method) async {
    try {
      final snapshot = await _collection
          .where('method', isEqualTo: method.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payments by method: ${method.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get pending payments
  Future<List<PaymentModel>> getPendingPayments() async {
    try {
      final snapshot = await _collection
          .where('status', whereIn: ['pending', 'processing'])
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get pending payments',
        );
      }
      rethrow;
    }
  }

  // READ - Get unverified payments
  Future<List<PaymentModel>> getUnverifiedPayments() async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: 'paid')
          .where('isVerified', isEqualTo: false)
          .orderBy('paidAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get unverified payments',
        );
      }
      rethrow;
    }
  }

  // READ - Get payments by date range
  Future<List<PaymentModel>> getPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _collection
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payments by date range',
        );
      }
      rethrow;
    }
  }

  // READ - Get payment statistics
  Future<Map<String, dynamic>> getPaymentStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _collection;

      if (startDate != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final snapshot = await query.get();
      final payments =
          snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();

      final paidPayments =
          payments.where((p) => p.status == PaymentStatus.paid);

      return {
        'total': payments.length,
        'pending':
            payments.where((p) => p.status == PaymentStatus.pending).length,
        'paid': paidPayments.length,
        'failed':
            payments.where((p) => p.status == PaymentStatus.failed).length,
        'totalAmount':
            paidPayments.fold<int>(0, (sum, p) => sum + p.totalAmount),
        'averageAmount': paidPayments.isEmpty
            ? 0
            : paidPayments.fold<int>(0, (sum, p) => sum + p.totalAmount) ~/
                paidPayments.length,
        'byMethod': {
          'bank_transfer': payments
              .where((p) => p.method == PaymentMethod.bankTransfer)
              .length,
          'credit_card': payments
              .where((p) => p.method == PaymentMethod.creditCard)
              .length,
          'ewallet':
              payments.where((p) => p.method == PaymentMethod.ewallet).length,
          'qris': payments.where((p) => p.method == PaymentMethod.qris).length,
          'virtual_account': payments
              .where((p) => p.method == PaymentMethod.virtualAccount)
              .length,
        },
      };
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get payment statistics',
        );
      }
      rethrow;
    }
  }

  // UPDATE
  Future<void> updatePayment(String id, Map<String, dynamic> updates) async {
    try {
      await _collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('payment_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update payment: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Change status
  Future<void> changePaymentStatus(
    String id,
    PaymentStatus status, {
    String? transactionId,
    String? failureReason,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (status == PaymentStatus.paid) {
        updates['paidAt'] = FieldValue.serverTimestamp();
        if (transactionId != null) {
          updates['transactionId'] = transactionId;
        }
      } else if (status == PaymentStatus.failed && failureReason != null) {
        updates['failureReason'] = failureReason;
      }

      await _collection.doc(id).update(updates);

      _firebase.logEvent('payment_status_changed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to change payment status: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Verify payment (admin action)
  Future<void> verifyPayment(String id, String verifierId) async {
    try {
      await _collection.doc(id).update({
        'isVerified': true,
        'verifiedBy': verifierId,
        'verifiedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('payment_verified');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to verify payment: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Process refund
  Future<void> refundPayment(
    String id,
    String reason,
    int refundAmount,
    String refundedBy,
  ) async {
    try {
      await _collection.doc(id).update({
        'status': 'refunded',
        'refundReason': reason,
        'refundAmount': refundAmount,
        'refundedAt': FieldValue.serverTimestamp(),
        'refundedBy': refundedBy,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('payment_refunded');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to refund payment: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Cancel payment
  Future<void> cancelPayment(String id, String reason) async {
    try {
      await _collection.doc(id).update({
        'status': 'cancelled',
        'cancelReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('payment_cancelled');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to cancel payment: $id',
        );
      }
      rethrow;
    }
  }

  // BATCH - Expire payments (scheduled job)
  Future<int> expirePayments() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('status', whereIn: ['pending', 'processing'])
          .where('expiryDate', isLessThan: Timestamp.fromDate(now))
          .get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': 'expired',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      _firebase.logEvent('payments_expired');

      return snapshot.docs.length;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to expire payments',
        );
      }
      rethrow;
    }
  }

  // DELETE (Hard delete - admin only)
  Future<void> deletePayment(String id) async {
    try {
      await _collection.doc(id).delete();

      _firebase.logEvent('payment_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete payment: $id',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch payment
  Stream<PaymentModel?> watchPayment(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return PaymentModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch payments by user
  Stream<List<PaymentModel>> watchPaymentsByUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch pending payments
  Stream<List<PaymentModel>> watchPendingPayments() {
    return _collection
        .where('status', whereIn: ['pending', 'processing'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentModel.fromFirestore(doc))
            .toList());
  }

  // HELPER - Generate order ID
  String _generateOrderId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}$random';
  }

  // HELPER - Generate invoice number
  String _generateInvoiceNumber() {
    final now = DateTime.now();
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'INV/${now.year}/${now.month.toString().padLeft(2, '0')}/$random';
  }

  // Convenience method aliases
  Future<String> create(PaymentModel payment) => createPayment(payment);
  
  Future<void> update(PaymentModel payment) async {
    final data = payment.toFirestore();
    await _collection.doc(payment.id).update(data);
  }
}
