import '../models/pickup_request_model.dart';
import '../models/membership_model.dart';
import '../models/point_ledger_model.dart';

/// Centralized labels for statuses across app and admin_web to avoid drift.
const Map<PickupStatus, String> pickupStatusLabelId = {
  PickupStatus.pending: 'Menunggu',
  PickupStatus.assigned: 'Ditugaskan',
  PickupStatus.onTheWay: 'Dalam Perjalanan',
  PickupStatus.arrived: 'Tiba',
  PickupStatus.pickedUp: 'Diambil',
  PickupStatus.completed: 'Selesai',
  PickupStatus.cancelled: 'Dibatalkan',
};

const Map<PickupStatus, String> pickupStatusLabelEn = {
  PickupStatus.pending: 'Pending',
  PickupStatus.assigned: 'Assigned',
  PickupStatus.onTheWay: 'On The Way',
  PickupStatus.arrived: 'Arrived',
  PickupStatus.pickedUp: 'Picked Up',
  PickupStatus.completed: 'Completed',
  PickupStatus.cancelled: 'Cancelled',
};

const Map<MembershipStatus, String> membershipStatusLabelId = {
  MembershipStatus.active: 'Aktif',
  MembershipStatus.expired: 'Kedaluwarsa',
  MembershipStatus.cancelled: 'Dibatalkan',
  MembershipStatus.pending: 'Menunggu',
};

const Map<MembershipStatus, String> membershipStatusLabelEn = {
  MembershipStatus.active: 'Active',
  MembershipStatus.expired: 'Expired',
  MembershipStatus.cancelled: 'Cancelled',
  MembershipStatus.pending: 'Pending',
};

const Map<PointTransactionType, String> pointTypeLabelId = {
  PointTransactionType.earn: 'Dapat',
  PointTransactionType.redeem: 'Tukar',
  PointTransactionType.refund: 'Refund',
  PointTransactionType.bonus: 'Bonus',
  PointTransactionType.penalty: 'Penalti',
};

const Map<PointTransactionType, String> pointTypeLabelEn = {
  PointTransactionType.earn: 'Earn',
  PointTransactionType.redeem: 'Redeem',
  PointTransactionType.refund: 'Refund',
  PointTransactionType.bonus: 'Bonus',
  PointTransactionType.penalty: 'Penalty',
};
