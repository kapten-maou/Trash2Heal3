// ============================================================
// FILE: admin_web/lib/features/event_items/presentation/event_item_form_screen.dart
// DESCRIPTION: Add/Edit form for event items
// FEATURES:
// - Item name input
// - Description textarea
// - Cost (points) input
// - Stock quantity input
// - Form validation
// - Create/Update functionality
// - Image upload (TODO)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class EventItemFormScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String? itemId;

  const EventItemFormScreen({
    super.key,
    required this.eventId,
    this.itemId,
  });

  @override
  ConsumerState<EventItemFormScreen> createState() =>
      _EventItemFormScreenState();
}

class _EventItemFormScreenState extends ConsumerState<EventItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isLoading = false;

  bool get isEdit => widget.itemId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _loadItemData();
    }
  }

  void _loadItemData() {
    // TODO: Load existing item data from Firebase
    // For now, set dummy data
    _nameController.text = 'Sample Item';
    _descriptionController.text = 'This is a sample item description';
    _costController.text = '500';
    _stockController.text = '50';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _stockController.dispose();
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
          content: Text(isEdit ? 'Item updated!' : 'Item created!'),
          backgroundColor: AdminTheme.successColor,
        ),
      );

      context.go('/events/${widget.eventId}/items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        TextButton.icon(
          onPressed: () => context.go('/events/${widget.eventId}/items'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Items'),
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
                    isEdit ? 'Edit Event Item' : 'Add New Event Item',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Item Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'e.g., Reusable Water Bottle',
                      helperText: 'Display name for the item',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Item name is required';
                      }
                      if (value.length < 3) {
                        return 'Item name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe the item',
                      helperText: 'Detailed information about the item',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      if (value.length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Cost & Stock
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _costController,
                          decoration: const InputDecoration(
                            labelText: 'Cost',
                            hintText: '100',
                            suffixText: 'points',
                            helperText: 'Points required to claim',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cost is required';
                            }
                            final cost = int.tryParse(value);
                            if (cost == null || cost <= 0) {
                              return 'Enter valid positive number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _stockController,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            hintText: '50',
                            suffixText: 'items',
                            helperText: 'Total available quantity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Stock is required';
                            }
                            final stock = int.tryParse(value);
                            if (stock == null || stock <= 0) {
                              return 'Enter valid positive number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AdminTheme.infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AdminTheme.infoColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AdminTheme.infoColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Users can claim these items during the event by redeeming their points. '
                            'Make sure to set appropriate costs and stock levels.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AdminTheme.infoColor.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
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
                              : () =>
                                  context.go('/events/${widget.eventId}/items'),
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
                              : Text(isEdit ? 'Update Item' : 'Create Item'),
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
}
