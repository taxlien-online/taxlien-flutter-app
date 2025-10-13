import 'package:flutter/material.dart';
import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Magento Messenger Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MessengerExamplePage(),
    );
  }
}

class MessengerExamplePage extends StatefulWidget {
  const MessengerExamplePage({super.key});

  @override
  State<MessengerExamplePage> createState() => _MessengerExamplePageState();
}

class _MessengerExamplePageState extends State<MessengerExamplePage> {
  late MagentoMessagingService _messagingService;
  late MessageManager _messageManager;
  late MessagingApi _api;

  List<MessageThread> _threads = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  int _currentUserId = 1; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _messagingService = MagentoMessagingService();
    _api = MessagingApi(baseUrl: 'https://your-magento-store.com');
    _messageManager = MessageManager(
      localService: _messagingService,
      api: _api,
      enableSync: true,
    );

    await _messageManager.initialize();
    await _loadThreads();
  }

  Future<void> _loadThreads() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final threads = await _messageManager.getThreads(
        userId: _currentUserId,
        limit: 50,
      );

      final unreadCount = await _messageManager.getUnreadCount(
        userId: _currentUserId,
      );

      setState(() {
        _threads = threads;
        _unreadCount = unreadCount;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading threads: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendTestMessage() async {
    try {
      await _messageManager.sendMessage(
        senderId: _currentUserId,
        recipientId: 2, // Replace with actual recipient ID
        message: 'Hello! This is a test message sent at ${DateTime.now()}',
        subject: 'Test Message',
        type: MessageType.customerToSeller,
      );

      await _loadThreads();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Test message sent!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      for (final thread in _threads) {
        await _messageManager.markThreadAsRead(
          threadId: thread.id,
          userId: _currentUserId,
        );
      }

      await _loadThreads();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All messages marked as read!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error marking as read: $e')));
      }
    }
  }

  void _openThread(MessageThread thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadDetailPage(
          thread: thread,
          currentUserId: _currentUserId,
          messageManager: _messageManager,
        ),
      ),
    ).then((_) {
      // Refresh threads when returning
      _loadThreads();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Magento Messenger Example'),
        actions: [
          NotificationIconBadge(
            count: _unreadCount,
            icon: Icons.message,
            onTap: () {
              // Handle message tap
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendTestMessage,
                    child: const Text('Send Test Message'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _markAllAsRead,
                    child: const Text('Mark All Read'),
                  ),
                ),
              ],
            ),
          ),

          // Thread list
          Expanded(
            child: ThreadList(
              threads: _threads,
              currentUserId: _currentUserId,
              isLoading: _isLoading,
              onThreadTap: _openThread,
              onThreadLongPress: (thread) {
                // Handle thread long press (e.g., show context menu)
                _showThreadContextMenu(thread);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showThreadContextMenu(MessageThread thread) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive Thread'),
              onTap: () {
                Navigator.pop(context);
                _archiveThread(thread);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Thread'),
              onTap: () {
                Navigator.pop(context);
                _deleteThread(thread);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _archiveThread(MessageThread thread) async {
    try {
      await _messageManager.archiveThread(threadId: thread.id);
      await _loadThreads();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Thread archived!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error archiving thread: $e')));
      }
    }
  }

  Future<void> _deleteThread(MessageThread thread) async {
    try {
      // Note: This would typically require a delete method in the API
      await _loadThreads();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Thread deleted!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting thread: $e')));
      }
    }
  }

  @override
  void dispose() {
    _messageManager.dispose();
    super.dispose();
  }
}

class ThreadDetailPage extends StatefulWidget {
  final MessageThread thread;
  final int currentUserId;
  final MessageManager messageManager;

  const ThreadDetailPage({
    super.key,
    required this.thread,
    required this.currentUserId,
    required this.messageManager,
  });

  @override
  State<ThreadDetailPage> createState() => _ThreadDetailPageState();
}

class _ThreadDetailPageState extends State<ThreadDetailPage> {
  List<MagentoMessage> _messages = [];
  bool _isLoading = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await widget.messageManager.getThreadMessages(
        threadId: widget.thread.id,
        limit: 100,
      );

      setState(() {
        _messages = messages;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading messages: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await widget.messageManager.sendMessage(
        senderId: widget.currentUserId,
        recipientId: widget.thread.participant1Id == widget.currentUserId
            ? widget.thread.participant2Id
            : widget.thread.participant1Id,
        message: _messageController.text.trim(),
        type: MessageType.customerToSeller,
      );

      _messageController.clear();
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread ${widget.thread.id}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: MessageList(
              messages: _messages,
              currentUserId: widget.currentUserId,
              isLoading: _isLoading,
              reverse: true,
              onMessageTap: (message) {
                // Handle message tap
                print('Tapped message: ${message.id}');
              },
              onMessageLongPress: (message) {
                // Handle message long press (e.g., show context menu)
                _showMessageContextMenu(message);
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageContextMenu(MagentoMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Message'),
              onTap: () {
                Navigator.pop(context);
                // Copy message to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Message'),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteMessage(MagentoMessage message) async {
    try {
      // Note: This would typically require a delete method in the API
      await _loadMessages();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Message deleted!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting message: $e')));
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
