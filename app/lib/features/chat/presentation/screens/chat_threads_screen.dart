import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../providers/chat_provider.dart';

class ChatThreadsScreen extends ConsumerStatefulWidget {
  const ChatThreadsScreen({super.key});

  @override
  ConsumerState<ChatThreadsScreen> createState() => _ChatThreadsScreenState();
}

class _ChatThreadsScreenState extends ConsumerState<ChatThreadsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatProvider.notifier).loadThreads();
    });
  }

  Future<void> _startAdminChat() async {
    final threadId = await ref.read(chatProvider.notifier).createOrGetAdminThread();
    if (threadId != null && mounted) {
      context.push('/chat/$threadId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final threads = chatState.threads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
        elevation: 0,
      ),
      body: chatState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : threads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada percakapan',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mulai chat dengan admin',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _startAdminChat,
                        icon: const Icon(Icons.chat),
                        label: const Text('Chat dengan Admin'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: threads.length,
                  itemBuilder: (context, index) {
                    final thread = threads[index];
                    return _buildThreadCard(thread);
                  },
                ),
      floatingActionButton: threads.isNotEmpty
          ? FloatingActionButton(
              onPressed: _startAdminChat,
              child: const Icon(Icons.chat),
              heroTag: 'new_chat',
            )
          : null,
    );
  }

  Widget _buildThreadCard(ChatThreadModel thread) {
    final dateFormat = DateFormat('dd MMM, HH:mm');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final otherParticipantName = ChatThreadHelper.getOtherParticipantName(
      thread,
      currentUserId ?? '',
    );
    final isAdminThread = thread.type == ThreadType.userAdmin;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: Icon(
          isAdminThread ? Icons.support_agent : Icons.person,
          color: Colors.green,
        ),
      ),
      title: Text(
        otherParticipantName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(thread.lastMessage ?? 'Tap untuk buka chat'),
      trailing: Text(
        thread.updatedAt != null
            ? dateFormat.format(thread.updatedAt!)
            : '',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      onTap: () => context.push('/chat/${thread.id}'),
    );
  }
}
