import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary dev-only session flag to allow hard-coded admin login
/// without Firebase Auth. Replace with real auth once backend ready.
final devSessionProvider = StateProvider<bool>((ref) => false);
