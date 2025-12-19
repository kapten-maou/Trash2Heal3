// ============================================================
// FILE: admin_web/lib/features/settings/presentation/settings_screen.dart
// DESCRIPTION: System settings and configuration
// FEATURES:
// - General settings (app name, contact info)
// - System settings (maintenance mode, registration)
// - Notification settings (email, push)
// - Membership plans display
// - Point conversion rates
// - Save/Reset functionality
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/admin_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _appNameController = TextEditingController(text: 'TRASH2HEAL');
  final _supportEmailController =
      TextEditingController(text: 'support@trash2heal.com');
  final _supportPhoneController =
      TextEditingController(text: '+62 812-3456-7890');

  bool _maintenanceMode = false;
  bool _allowRegistration = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _appNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement save logic to Firebase
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: AdminTheme.successColor,
        ),
      );
    }
  }

  Future<void> _handleReset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.errorColor,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _appNameController.text = 'TRASH2HEAL';
        _supportEmailController.text = 'support@trash2heal.com';
        _supportPhoneController.text = '+62 812-3456-7890';
        _maintenanceMode = false;
        _allowRegistration = true;
        _emailNotifications = true;
        _pushNotifications = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            backgroundColor: AdminTheme.infoColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App Name
                  TextFormField(
                    controller: _appNameController,
                    decoration: const InputDecoration(
                      labelText: 'Application Name',
                      hintText: 'Enter app name',
                      helperText: 'Display name for the application',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'App name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Support Contact
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _supportEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Support Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _supportPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Support Phone',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // System Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Maintenance Mode'),
                  subtitle: const Text(
                      'Temporarily disable app access for all users'),
                  value: _maintenanceMode,
                  onChanged: (value) =>
                      setState(() => _maintenanceMode = value),
                  tileColor: AdminTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Allow New Registrations'),
                  subtitle: const Text('Enable user sign-ups'),
                  value: _allowRegistration,
                  onChanged: (value) =>
                      setState(() => _allowRegistration = value),
                  tileColor: AdminTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Notification Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Send email notifications to users'),
                  value: _emailNotifications,
                  onChanged: (value) =>
                      setState(() => _emailNotifications = value),
                  tileColor: AdminTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle:
                      const Text('Send push notifications to mobile devices'),
                  value: _pushNotifications,
                  onChanged: (value) =>
                      setState(() => _pushNotifications = value),
                  tileColor: AdminTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Membership Plans
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Membership Plans',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Show edit plans dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Edit plans functionality coming soon'),
                            backgroundColor: AdminTheme.infoColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Plans'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(
                      child: _MembershipPlanCard(
                        name: 'Basic',
                        price: 'Free',
                        benefits: ['1x Points', 'Standard Support'],
                        color: AdminTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _MembershipPlanCard(
                        name: 'Silver',
                        price: 'Rp 50K/month',
                        benefits: [
                          '1.5x Points',
                          'Priority Support',
                          'Monthly Rewards'
                        ],
                        color: Color(0xFF757575),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _MembershipPlanCard(
                        name: 'Gold',
                        price: 'Rp 100K/month',
                        benefits: [
                          '2x Points',
                          'Priority Support',
                          'Exclusive Events',
                          'Free Shipping'
                        ],
                        color: Color(0xFFFFA726),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Point Conversion Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Point Conversion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(
                      child: _ConversionRateCard(
                        title: 'Points to Coupon',
                        rate: '100 Points = 1 Coupon',
                        icon: Icons.card_giftcard,
                        color: AdminTheme.warningColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _ConversionRateCard(
                        title: 'Points to Balance',
                        rate: '100 Points = Rp 1,000',
                        icon: Icons.account_balance_wallet,
                        color: AdminTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Save Button
        Row(
          children: [
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Defaults'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleSave,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Membership Plan Card Widget
class _MembershipPlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> benefits;
  final Color color;

  const _MembershipPlanCard({
    required this.name,
    required this.price,
    required this.benefits,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.card_membership, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Conversion Rate Card Widget
class _ConversionRateCard extends StatelessWidget {
  final String title;
  final String rate;
  final IconData icon;
  final Color color;

  const _ConversionRateCard({
    required this.title,
    required this.rate,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Show edit rate dialog
            },
            tooltip: 'Edit Rate',
          ),
        ],
      ),
    );
  }
}
