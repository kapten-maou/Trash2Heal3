// ============================================================
// FILE: admin_web/lib/features/events/presentation/events_list_screen.dart
// DESCRIPTION: Grid view for events management
// FEATURES:
// - Grid cards layout for events
// - Search functionality
// - Filter by status
// - Status badges display
// - Attendees count
// - Date range display
// - Edit event action
// - View event items action
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Actions
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AdminTheme.surfaceColor,
                ),
                onChanged: (value) {
                  // TODO: Implement search filtering
                },
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Show filter dialog
              },
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => context.go('/events/add'),
              icon: const Icon(Icons.add),
              label: const Text('Create Event'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Events Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _EventCard(
              title: 'Event ${index + 1}',
              description: 'Join us for an exciting eco-friendly event',
              startDate: DateTime.now().add(Duration(days: index * 7)),
              endDate: DateTime.now().add(Duration(days: index * 7 + 3)),
              status: index % 3 == 0
                  ? 'active'
                  : index % 3 == 1
                      ? 'upcoming'
                      : 'ended',
              attendees: (index + 1) * 45,
              onTap: () => context.go('/events/edit/event_$index'),
              onViewItems: () => context.go('/events/event_$index/items'),
            );
          },
        ),
      ],
    );
  }
}

// Event Card Widget
class _EventCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int attendees;
  final VoidCallback onTap;
  final VoidCallback onViewItems;

  const _EventCard({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.attendees,
    required this.onTap,
    required this.onViewItems,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AdminTheme.statusChip(status),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AdminTheme.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Date Range
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AdminTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AdminTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Attendees and Actions
              Row(
                children: [
                  const Icon(
                    Icons.people,
                    size: 16,
                    color: AdminTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$attendees attendees',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onViewItems,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text('View Items'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
