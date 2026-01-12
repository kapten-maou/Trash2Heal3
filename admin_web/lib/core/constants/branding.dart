/// Centralized branding assets and environment badge for the admin panel.
class Branding {
  Branding._();

  // Visuals (network to avoid bundling assets)
  static const String logoUrl =
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=400&q=80';
  static const String heroUrl =
      'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=800&q=80';

  // Environment name from compile-time env var; fallback to dev.
  static const String envName =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static String get envLabel {
    final name = envName.toLowerCase();
    if (name.contains('prod')) return 'PRODUCTION';
    if (name.contains('staging') || name.contains('stage')) return 'STAGING';
    if (name.contains('dev')) return 'DEVELOPMENT';
    return envName.toUpperCase();
  }

  static int get envColor {
    final name = envName.toLowerCase();
    if (name.contains('prod')) return 0xFFB91C1C; // red
    if (name.contains('staging') || name.contains('stage')) return 0xFFF59E0B; // amber
    return 0xFF2563EB; // blue for dev/default
  }
}
