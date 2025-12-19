import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';

class ChatState {
  final List<ChatThreadModel> threads;
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    this.threads = const [],
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatThreadModel>? threads,
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      threads: threads ?? this.threads,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepo;
  final Ref _ref;

  ChatNotifier(this._chatRepo, this._ref) : super(const ChatState());

  Future<void> loadThreads() async {
    final authState = _ref.read(authProvider);
    if (authState.user == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final threads = await _chatRepo.getUserThreads(authState.user!.uid);
      threads.sort((a, b) => (b.updatedAt ?? DateTime.now())
          .compareTo(a.updatedAt ?? DateTime.now()));
      state = state.copyWith(threads: threads, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMessages(String threadId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final messages = await _chatRepo.getThreadMessages(threadId);
      messages.sort((a, b) => (a.createdAt ?? DateTime.now())
          .compareTo(b.createdAt ?? DateTime.now()));
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String?> createOrGetAdminThread() async {
    final authState = _ref.read(authProvider);
    if (authState.user == null) return null;

    try {
      final uid = authState.user!.uid;
      final userName = authState.user!.name;

      final thread = ChatThreadModel(
        id: '',
        participantIds: [uid, 'admin'],
        participantDetails: ChatThreadHelper.createParticipantDetails(
          userId: uid,
          userName: userName,
          adminId: 'admin',
          adminName: 'Admin Support',
        ),
        type: ThreadType.userAdmin,
        unreadCount: ChatThreadHelper.initializeUnreadCount([uid, 'admin']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final threadId = await _chatRepo.createThread(thread);
      await loadThreads();
      return threadId;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  Future<bool> sendMessage(String threadId, String message) async {
    final authState = _ref.read(authProvider);
    if (authState.user == null) return false;

    try {
      final msg = ChatMessageHelper.createTextMessage(
        threadId: threadId,
        senderId: authState.user!.uid,
        senderName: authState.user!.name,
        senderPhotoUrl: authState.user!.photoUrl,
        message: message,
      );

      await _chatRepo.sendMessage(msg);
      await loadMessages(threadId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatRepository(), ref);
});
