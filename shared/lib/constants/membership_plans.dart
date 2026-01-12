import '../models/membership_model.dart';
import '../repositories/membership_repository.dart';

/// Canonical membership plan definitions shared by app & admin.
class MembershipPlans {
  MembershipPlans._();

  /// Display name per tier.
  static const Map<MembershipTier, String> names = {
    MembershipTier.basic: 'Basic',
    MembershipTier.gold: 'Gold',
    MembershipTier.platinum: 'Platinum',
  };

  /// Duration in days per tier (align with repository logic).
  static const Map<MembershipTier, int> durationDays = {
    MembershipTier.basic: 0,
    MembershipTier.gold: 365,
    MembershipTier.platinum: 365,
  };

  /// Price per tier (IDR) using repository helper.
  static int price(MembershipTier tier) =>
      MembershipRepository.getTierPriceStatic(tier);

  /// Benefit map per tier (from MembershipBenefits).
  static Map<String, dynamic> benefits(MembershipTier tier) {
    switch (tier) {
      case MembershipTier.basic:
        return MembershipBenefits.basic();
      case MembershipTier.gold:
        return MembershipBenefits.gold();
      case MembershipTier.platinum:
        return MembershipBenefits.platinum();
    }
  }
}
