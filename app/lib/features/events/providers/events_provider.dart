// ========== events_provider.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class EventsProviderNotifier extends ChangeNotifier {
  final EventRepository _eventRepo;
  final EventItemRepository _itemRepo;

  EventsProviderNotifier(this._eventRepo, this._itemRepo);

  List<EventModel> _events = [];
  List<EventItemModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  List<EventItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadActiveEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allEvents = await _eventRepo.getAll();
      _events = allEvents.where((e) => e.active).toList();
      _events.sort((a, b) => b.startDate.compareTo(a.startDate));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadEventItems(String eventId) async {
    try {
      _items = await _itemRepo.getByEventId(eventId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

final eventsProviderNotifier =
    ChangeNotifierProvider<EventsProviderNotifier>((ref) {
  return EventsProviderNotifier(EventRepository(), EventItemRepository());
});
