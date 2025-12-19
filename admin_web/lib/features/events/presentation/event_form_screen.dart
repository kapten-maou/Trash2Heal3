// ============================================================
// FILE: admin_web/lib/features/events/presentation/event_form_screen.dart
// DESCRIPTION: Add/Edit form for events
// FEATURES:
// - Event name input
// - Description textarea
// - Location input
// - Date range pickers (start/end date)
// - Status dropdown
// - Form validation
// - Create/Update functionality
// - Image upload (TODO)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final String? eventId;

  const EventFormScreen({super.key, this.eventId});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'upcoming';
  bool _isLoading = false;

  bool get isEdit => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _loadEventData();
    }
  }

  void _loadEventData() {
    // TODO: Load existing event data from Firebase
    // For now, set dummy data
    _nameController.text = 'Sample Event';
    _descriptionController.text = 'This is a sample event description';
    _locationController.text = 'Jakarta Convention Center';
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 3));
    _status = 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
          backgroundColor: AdminTheme.errorColor,
        ),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date must be after start date'),
          backgroundColor: AdminTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement save logic to Firebase
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Event updated!' : 'Event created!'),
          backgroundColor: AdminTheme.successColor,
        ),
      );

      context.go('/events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        TextButton.icon(
          onPressed: () => context.go('/events'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Events'),
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
                    isEdit ? 'Edit Event' : 'Create New Event',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Event Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter event name',
                      helperText: 'Display name for the event',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event name is required';
                      }
                      if (value.length < 3) {
                        return 'Event name must be at least 3 characters';
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
                      hintText: 'Enter event description',
                      helperText: 'Detailed information about the event',
                    ),
                    maxLines: 4,
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

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'Enter event location',
                      prefixIcon: Icon(Icons.location_on),
                      helperText: 'Physical or virtual location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Location is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date Range
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start Date'),
                          subtitle: Text(
                            _startDate?.toString().split(' ')[0] ??
                                'Select date',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _startDate = date);
                            }
                          },
                          tileColor: AdminTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ListTile(
                          title: const Text('End Date'),
                          subtitle: Text(
                            _endDate?.toString().split(' ')[0] ?? 'Select date',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  _endDate ?? _startDate ?? DateTime.now(),
                              firstDate: _startDate ?? DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _endDate = date);
                            }
                          },
                          tileColor: AdminTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      helperText: 'Current status of the event',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'upcoming',
                        child: Row(
                          children: [
                            Icon(Icons.schedule, size: 20),
                            SizedBox(width: 8),
                            Text('Upcoming'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'active',
                        child: Row(
                          children: [
                            Icon(Icons.play_circle, size: 20),
                            SizedBox(width: 8),
                            Text('Active'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'ended',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 8),
                            Text('Ended'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'cancelled',
                        child: Row(
                          children: [
                            Icon(Icons.cancel, size: 20),
                            SizedBox(width: 8),
                            Text('Cancelled'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isLoading ? null : () => context.go('/events'),
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
                              : Text(isEdit ? 'Update Event' : 'Create Event'),
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
