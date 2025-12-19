import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class EventItemsState {
  final List<EventItemModel> items;
  final bool isLoading;
  final String? error;
  final EventItemModel? selectedItem;

  const EventItemsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.selectedItem,
  });

  EventItemsState copyWith({
    List<EventItemModel>? items,
    bool? isLoading,
    String? error,
    EventItemModel? selectedItem,
    bool clearSelectedItem = false,
  }) {
    return EventItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedItem:
          clearSelectedItem ? null : (selectedItem ?? this.selectedItem),
    );
  }
}

class EventItemsNotifier extends StateNotifier<EventItemsState> {
  final EventItemRepository _repository;

  EventItemsNotifier(this._repository) : super(const EventItemsState());

  Future<void> loadItems({String? eventId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      List<EventItemModel> items;

      if (eventId != null) {
        items = await _repository.getItemsByEvent(eventId);
      } else {
        items = await _repository.getItemsByEvent('');
      }

      items.sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);

      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load event items: $e',
      );
    }
  }

  Future<void> loadItemById(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final item = await _repository.getEventItemById(id);

      if (item == null) {
        throw Exception('Event item not found');
      }

      state = state.copyWith(
        selectedItem: item,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load event item: $e',
      );
    }
  }

  List<EventItemModel> getLowStockItems() {
    return state.items
        .where((item) => item.status == EventItemStatus.lowStock)
        .toList();
  }

  List<EventItemModel> getOutOfStockItems() {
    return state.items
        .where((item) => item.status == EventItemStatus.outOfStock)
        .toList();
  }

  Future<bool> createItem(EventItemModel item) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.createEventItem(item);
      await loadItems(eventId: item.eventId);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create event item: $e',
      );
      return false;
    }
  }

  Future<bool> updateItem(String itemId, EventItemModel item) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updates = item.toFirestore();
      updates.remove('id');
      await _repository.updateEventItem(itemId, updates);

      await loadItems(eventId: item.eventId);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update event item: $e',
      );
      return false;
    }
  }

  Future<bool> toggleItemActive(String itemId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final item = state.items.firstWhere((i) => i.id == itemId);
      final newActiveStatus = !item.isActive;

      await _repository.updateEventItem(itemId, {
        'isActive': newActiveStatus,
      });

      final updatedItems = state.items.map((i) {
        return i.id == itemId ? i.copyWith(isActive: newActiveStatus) : i;
      }).toList();

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to toggle item status: $e',
      );
      return false;
    }
  }

  Future<bool> changeItemStatus(String itemId, EventItemStatus status) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.changeItemStatus(itemId, status);

      final updatedItems = state.items.map((i) {
        return i.id == itemId ? i.copyWith(status: status) : i;
      }).toList();

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to change item status: $e',
      );
      return false;
    }
  }

  Future<bool> incrementClaimedCount(String itemId) async {
    try {
      final success = await _repository.incrementClaimedCount(itemId);
      if (success) {
        await loadItems();
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to claim item: $e',
      );
      return false;
    }
  }

  Future<bool> reserveItem(String itemId, int quantity) async {
    try {
      final success = await _repository.reserveItem(itemId, quantity);
      if (success) {
        await loadItems();
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to reserve item: $e',
      );
      return false;
    }
  }

  Future<void> releaseReservation(String itemId, int quantity) async {
    try {
      await _repository.releaseReservation(itemId, quantity);
      await loadItems();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to release reservation: $e',
      );
    }
  }

  Future<bool> deleteItem(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deactivateEventItem(id);

      final updatedItems = state.items.where((i) => i.id != id).toList();

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete event item: $e',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSelectedItem() {
    state = state.copyWith(clearSelectedItem: true);
  }

  void selectItem(EventItemModel item) {
    state = state.copyWith(selectedItem: item);
  }
}

final eventItemRepositoryProvider = Provider<EventItemRepository>((ref) {
  return EventItemRepository();
});

final eventItemsProvider =
    StateNotifierProvider<EventItemsNotifier, EventItemsState>((ref) {
  final repository = ref.watch(eventItemRepositoryProvider);
  return EventItemsNotifier(repository);
});

final allEventItemsProvider = Provider<List<EventItemModel>>((ref) {
  return ref.watch(eventItemsProvider).items;
});

final activeEventItemsProvider = Provider<List<EventItemModel>>((ref) {
  return ref
      .watch(eventItemsProvider)
      .items
      .where((item) => item.isActive)
      .toList();
});

final availableEventItemsProvider = Provider<List<EventItemModel>>((ref) {
  return ref
      .watch(eventItemsProvider)
      .items
      .where((item) =>
          item.isActive && item.stock > item.claimed + item.reserved)
      .toList();
});

final lowStockItemsProvider = Provider<List<EventItemModel>>((ref) {
  final notifier = ref.watch(eventItemsProvider.notifier);
  return notifier.getLowStockItems();
});

final outOfStockItemsProvider = Provider<List<EventItemModel>>((ref) {
  final notifier = ref.watch(eventItemsProvider.notifier);
  return notifier.getOutOfStockItems();
});

final selectedEventItemProvider = Provider<EventItemModel?>((ref) {
  return ref.watch(eventItemsProvider).selectedItem;
});

final eventItemsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(eventItemsProvider).isLoading;
});

final eventItemsErrorProvider = Provider<String?>((ref) {
  return ref.watch(eventItemsProvider).error;
});
