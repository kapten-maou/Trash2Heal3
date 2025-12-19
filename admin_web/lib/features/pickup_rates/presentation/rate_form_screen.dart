// ============================================================
// FILE: admin_web/lib/features/pickup_rates/presentation/rate_form_screen.dart
// DESCRIPTION: Add/Edit form for pickup rates
// FEATURES:
// - Waste type dropdown selection
// - Points per kg input
// - Weight range (min/max) inputs
// - Active status toggle
// - Form validation
// - Create/Update functionality
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../../core/theme/admin_theme.dart';

class WasteType {
  static const Map<String, String> labels = {
    'plastic': 'Plastik',
    'glass': 'Kaca',
    'can': 'Kaleng',
    'cardboard': 'Kardus',
    'fabric': 'Kain',
    'ceramicStone': 'Keramik/Batu',
  };
}

class RateFormScreen extends ConsumerStatefulWidget {
  final String? rateId;

  const RateFormScreen({super.key, this.rateId});

  @override
  ConsumerState<RateFormScreen> createState() => _RateFormScreenState();
}

class _RateFormScreenState extends ConsumerState<RateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();
  final _minWeightController = TextEditingController();
  final _maxWeightController = TextEditingController();

  String? _selectedWasteType;
  bool _isActive = true;
  bool _isLoading = false;

  bool get isEdit => widget.rateId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _loadRateData();
    }
  }

  void _loadRateData() {
    // TODO: Load existing rate data from Firebase
    // For now, set dummy data
    _selectedWasteType = widget.rateId;
    _pointsController.text = '50';
    _minWeightController.text = '0.5';
    _maxWeightController.text = '100';
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _minWeightController.dispose();
    _maxWeightController.dispose();
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
        SnackBar(
          content: Text(isEdit ? 'Rate updated!' : 'Rate created!'),
          backgroundColor: AdminTheme.successColor,
        ),
      );

      context.go('/pickup-rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        TextButton.icon(
          onPressed: () => context.go('/pickup-rates'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Rates'),
        ),
        const SizedBox(height: 16),

        // Form Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Edit Pickup Rate' : 'Add New Pickup Rate',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Waste Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedWasteType,
                    decoration: const InputDecoration(
                      labelText: 'Waste Type',
                      hintText: 'Select waste type',
                      helperText: 'Choose the type of waste for this rate',
                    ),
                    items: WasteType.labels.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(
                              _getWasteIcon(entry.key),
                              size: 20,
                              color: AdminTheme.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Text(entry.value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: isEdit
                        ? null // Disable if editing
                        : (value) {
                            setState(() => _selectedWasteType = value);
                          },
                    validator: (value) {
                      if (value == null) return 'Please select a waste type';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Points per Kg
                  TextFormField(
                    controller: _pointsController,
                    decoration: const InputDecoration(
                      labelText: 'Points per Kilogram',
                      hintText: 'e.g., 50',
                      suffixText: 'points',
                      helperText: 'Reward points per kg of waste',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Points per kg is required';
                      }
                      final points = int.tryParse(value);
                      if (points == null || points <= 0) {
                        return 'Enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Weight Range
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minWeightController,
                          decoration: const InputDecoration(
                            labelText: 'Minimum Weight',
                            hintText: '0.5',
                            suffixText: 'kg',
                            helperText: 'Min weight accepted',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final min = double.tryParse(value);
                            if (min == null || min < 0) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _maxWeightController,
                          decoration: const InputDecoration(
                            labelText: 'Maximum Weight',
                            hintText: '100',
                            suffixText: 'kg',
                            helperText: 'Max weight accepted',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final max = double.tryParse(value);
                            if (max == null || max <= 0) {
                              return 'Invalid number';
                            }
                            final min =
                                double.tryParse(_minWeightController.text);
                            if (min != null && max <= min) {
                              return 'Must be > min weight';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Active Status
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Enable this rate for pickups'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    tileColor: AdminTheme.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.go('/pickup-rates'),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(isEdit ? 'Update Rate' : 'Create Rate'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getWasteIcon(String type) {
    switch (type) {
      case 'plastic':
        return Icons.water_drop;
      case 'paper':
        return Icons.description;
      case 'metal':
        return Icons.build;
      case 'glass':
        return Icons.local_drink;
      case 'organic':
        return Icons.eco;
      case 'electronic':
        return Icons.computer;
      default:
        return Icons.delete;
    }
  }
}
