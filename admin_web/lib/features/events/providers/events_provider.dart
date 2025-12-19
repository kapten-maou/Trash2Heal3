import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class EventsState {
  final List<EventModel> events;
  final List<EventModel> filteredEvents;
  final EventModel? selectedEvent;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  final String? filterStatus;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String searchQuery;

  const EventsState({
    this.events = const [],
    this.filteredEvents = const [],
    this.selectedEvent,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
    this.filterStatus,
    this.filterStartDate,
    this.filterEndDate,
    this.searchQuery = '',
  });

  EventsState copyWith({
    List<EventModel>? events,
    List<EventModel>? filteredEvents,
    EventModel? selectedEvent,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? searchQuery,
    bool clearSelectedEvent = false,
  }) {
    return EventsState(
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      selectedEvent:
          clearSelectedEvent ? null : (selectedEvent ?? this.selectedEvent),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
      filterStatus: filterStatus ?? this.filterStatus,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class EventsNotifier extends StateNotifier<EventsState> {
  final EventRepository _repository;

  EventsNotifier(this._repository) : super(const EventsState());

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final events = await _repository.getActiveEvents();

      events.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      state = state.copyWith(
        events: events,
        filteredEvents: events,
        isLoading: false,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load events: $e',
      );
    }
  }

  Future<void> loadEventById(String eventId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final event = await _repository.getEventById(eventId);

      if (event == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Event not found',
        );
        return;
      }

      state = state.copyWith(
        selectedEvent: event,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load event: $e',
      );
    }
  }

  Future<List<EventModel>> getActiveEvents() async {
    try {
      return await _repository.getActiveEvents();
    } catch (e) {
      print('Error getting active events: $e');
      return [];
    }
  }

  Future<bool> createEvent(EventModel event) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateEvent(event)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid event data',
        );
        return false;
      }

      await _repository.createEvent(event);
      await loadEvents();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Event created successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create event: $e',
      );
      return false;
    }
  }

  Future<bool> updateEvent(String eventId, EventModel event) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      if (!_validateEvent(event)) {
        state = state.copyWith(
          isSaving: false,
          error: 'Invalid event data',
        );
        return false;
      }

      final updates = event.toFirestore();
      updates.remove('id');
      await _repository.updateEvent(eventId, updates);

      await loadEvents();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Event updated successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update event: $e',
      );
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      await _repository.deleteEvent(eventId);

      final updatedEvents = state.events.where((e) => e.id != eventId).toList();

      state = state.copyWith(
        events: updatedEvents,
        isSaving: false,
        successMessage: 'Event deleted successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete event: $e',
      );
      return false;
    }
  }

  Future<bool> toggleEventActive(String eventId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final event = state.events.firstWhere((e) => e.id == eventId);
      final newActiveStatus = !event.isActive;

      await _repository.updateEvent(eventId, {
        'isActive': newActiveStatus,
      });

      await loadEvents();

      state = state.copyWith(
        isSaving: false,
        successMessage:
            newActiveStatus ? 'Event activated' : 'Event deactivated',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to toggle status: $e',
      );
      return false;
    }
  }

  Future<bool> changeEventStatus(String eventId, EventStatus status) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.changeEventStatus(eventId, status);
      await loadEvents();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Event status updated successfully',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to change event status: $e',
      );
      return false;
    }
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(filterStatus: status);
    _applyFilters();
  }

  void setDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      filterStartDate: startDate,
      filterEndDate: endDate,
    );
    _applyFilters();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void clearFilters() {
    state = state.copyWith(
      filterStatus: null,
      filterStartDate: null,
      filterEndDate: null,
      searchQuery: '',
      filteredEvents: state.events,
    );
  }

  void _applyFilters() {
    var filtered = state.events;

    if (state.filterStatus != null) {
      filtered = filtered.where((event) {
        return event.status.name == state.filterStatus;
      }).toList();
    }

    if (state.filterStartDate != null) {
      filtered = filtered.where((event) {
        return !event.startDate.isBefore(state.filterStartDate!);
      }).toList();
    }

    if (state.filterEndDate != null) {
      filtered = filtered.where((event) {
        return !event.endDate.isAfter(state.filterEndDate!);
      }).toList();
    }

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((event) {
        return event.title.toLowerCase().contains(query) ||
            (event.description.toLowerCase().contains(query));
      }).toList();
    }

    state = state.copyWith(filteredEvents: filtered);
  }

  bool _validateEvent(EventModel event) {
    if (event.title.isEmpty) return false;
    if (event.endDate.isBefore(event.startDate)) return false;
    return true;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void selectEvent(EventModel event) {
    state = state.copyWith(selectedEvent: event);
  }

  void clearSelectedEvent() {
    state = state.copyWith(clearSelectedEvent: true);
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventsProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventsNotifier(repository);
});

final allEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventsProvider).events;
});

final filteredEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventsProvider).filteredEvents;
});

final selectedEventProvider = Provider<EventModel?>((ref) {
  return ref.watch(eventsProvider).selectedEvent;
});

final eventsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(eventsProvider).isLoading;
});

final eventsSavingProvider = Provider<bool>((ref) {
  return ref.watch(eventsProvider).isSaving;
});

final eventsErrorProvider = Provider<String?>((ref) {
  return ref.watch(eventsProvider).error;
});

final eventsSuccessProvider = Provider<String?>((ref) {
  return ref.watch(eventsProvider).successMessage;
});
