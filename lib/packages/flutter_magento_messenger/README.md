# Flutter Magento Messenger

[![Latest Stable Version](https://pub.dev/packages/flutter_magento_messenger/badge)](https://pub.dev/packages/flutter_magento_messenger)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Total Downloads](https://img.shields.io/pub/total_downloads/flutter_magento_messenger.svg)](https://pub.dev/packages/flutter_magento_messenger)

A comprehensive Flutter library for Magento 2 messaging with universal messaging system. This library provides a complete solution for handling messaging in Flutter applications integrated with Magento e-commerce platforms.

## 🚀 Features

### 💬 **Universal Messaging System**
- **Direct Messaging** - Send messages between any users
- **Thread Management** - Organized conversation threads
- **Message Types** - Support for text, attachments, and system messages
- **Read Receipts** - Track message read status
- **Message Search** - Full-text search across all messages

### 🔧 **Advanced Features**
- **Attachment Support** - File uploads with type validation
- **Real-time Updates** - Live message streaming
- **Typing Indicators** - Show when users are typing
- **Message Moderation** - Admin approval for messages (optional)
- **Anonymous Messages** - Allow anonymous users to send messages
- **Archiving** - Archive and unarchive conversations

### 🎯 **User Experience**
- **Message History** - Complete conversation history
- **Unread Counts** - Track unread messages per thread
- **Mobile Responsive** - Works on all devices
- **Offline Support** - Works offline with sync when online
- **Performance** - Optimized for mobile performance

### 🎨 **UI Components**
- **Chat Bubbles** - Beautiful message bubbles
- **Message Input** - Rich message input with attachments
- **Thread List** - Conversation thread list
- **Typing Indicator** - Real-time typing status
- **Message List** - Customizable message list

## 📋 Requirements

- **Flutter**: >=3.24.0
- **Dart**: >=3.8.0
- **Magento**: 2.4.x (for backend integration)

## 🛠️ Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_magento_messenger: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🔧 Setup

### 1. Initialize the Messaging Service

```dart
import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessengerApp(),
    );
  }
}

class MessengerApp extends StatefulWidget {
  @override
  _MessengerAppState createState() => _MessengerAppState();
}

class _MessengerAppState extends State<MessengerApp> {
  late MagentoMessagingService _messagingService;

  @override
  void initState() {
    super.initState();
    _initializeMessaging();
  }

  Future<void> _initializeMessaging() async {
    _messagingService = MagentoMessagingService(
      enablePersistence: true,
      maxHistorySize: 1000,
    );
    
    await _messagingService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _sendTestMessage(),
              child: Text('Send Test Message'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showThreads(),
              child: Text('Show Threads'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendTestMessage() async {
    final message = await _messagingService.sendMessage(
      senderId: 123,
      recipientId: 456,
      message: 'Hello! This is a test message.',
      subject: 'Test Message',
    );
    print('Message sent: ${message.id}');
  }

  void _showThreads() {
    final threads = _messagingService.getThreads(limit: 10);
    // Show threads in a dialog or navigate to threads page
  }
}
```

### 2. Configure Providers (Optional)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the messaging service
final messagingServiceProvider = Provider<MagentoMessagingService>((ref) {
  return MagentoMessagingService(
    enablePersistence: true,
    maxHistorySize: 1000,
  );
});

// Use in your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagingService = ref.watch(messagingServiceProvider);
    
    return YourContent();
  }
}
```

## 📚 Usage

### Sending Messages

```dart
// Basic message
final message = await messagingService.sendMessage(
  senderId: 123,
  recipientId: 456,
  message: 'Hello! How can I help you?',
  subject: 'Product Inquiry',
);

// Message with attachment
final messageWithAttachment = await messagingService.sendMessage(
  senderId: 123,
  recipientId: 456,
  message: 'Please find the document attached.',
  subject: 'Document',
  attachmentUrl: 'https://example.com/document.pdf',
  attachmentType: 'pdf',
);

// Reply to message
final reply = await messagingService.replyToMessage(
  originalMessageId: 'message_123',
  message: 'Thank you for your inquiry!',
  subject: 'Re: Product Inquiry',
);
```

### Managing Messages

```dart
// Mark message as read
await messagingService.markAsRead('message_123');

// Mark thread as read
await messagingService.markThreadAsRead('thread_123');

// Delete message
await messagingService.deleteMessage('message_123');

// Get unread count
final unreadCount = messagingService.getUnreadCount(userId: 123);

// Get thread unread count
final threadUnreadCount = messagingService.getThreadUnreadCount('thread_123', 123);
```

### Thread Management

```dart
// Get all threads
final threads = messagingService.getThreads(limit: 20, offset: 0);

// Get thread messages
final messages = messagingService.getThreadMessages('thread_123', limit: 50);

// Archive thread
await messagingService.archiveThread('thread_123');

// Unarchive thread
await messagingService.unarchiveThread('thread_123');

// Get archived threads
final archivedThreads = messagingService.getArchivedThreads(limit: 20);
```

### Search Messages

```dart
// Search messages
final searchResults = messagingService.searchMessages(
  'product inquiry',
  limit: 20,
  offset: 0,
);

// Search with filters
final filteredResults = messagingService.searchMessages(
  'urgent',
  limit: 10,
);
```

### Typing Indicators

```dart
// Start typing
messagingService.startTyping('thread_123', 123);

// Stop typing
messagingService.stopTyping('thread_123');
```

### Statistics

```dart
// Get messaging statistics
final stats = messagingService.getStats(userId: 123);

print('Total messages: ${stats.totalMessages}');
print('Unread messages: ${stats.unreadMessages}');
print('Sent messages: ${stats.sentMessages}');
print('Received messages: ${stats.receivedMessages}');
print('Active threads: ${stats.activeThreads}');
print('Archived threads: ${stats.archivedThreads}');
```

## 🎨 UI Components

### Chat Screen

```dart
class ChatScreen extends StatefulWidget {
  final String threadId;
  final int currentUserId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MagentoMessagingService _messagingService;
  List<MagentoMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagingService = context.read<MagentoMessagingService>();
    _loadMessages();
  }

  void _loadMessages() {
    final messages = _messagingService.getThreadMessages(widget.threadId);
    setState(() {
      _messages = messages;
    });
  }

  void _sendMessage(String message) async {
    final thread = _messagingService.getThreads().firstWhere(
      (t) => t.id == widget.threadId,
    );
    
    await _messagingService.sendMessage(
      senderId: widget.currentUserId,
      recipientId: thread.getOtherParticipantId(widget.currentUserId),
      message: message,
    );
    
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              messages: _messages,
              currentUserId: widget.currentUserId,
              onMessageTap: (message) => _handleMessageTap(message),
              onMessageLongPress: (message) => _handleMessageLongPress(message),
            ),
          ),
          MessageInput(
            onSendMessage: _sendMessage,
            onSendAttachment: () => _sendAttachment(),
            hintText: 'Type a message...',
          ),
        ],
      ),
    );
  }

  void _handleMessageTap(MagentoMessage message) {
    // Handle message tap
  }

  void _handleMessageLongPress(MagentoMessage message) {
    // Show message options
  }

  void _sendAttachment() {
    // Handle attachment sending
  }

  void _showOptions() {
    // Show chat options
  }
}
```

### Thread List

```dart
class ThreadListScreen extends StatefulWidget {
  final int currentUserId;

  @override
  _ThreadListScreenState createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen> {
  late MagentoMessagingService _messagingService;
  List<MessageThread> _threads = [];

  @override
  void initState() {
    super.initState();
    _messagingService = context.read<MagentoMessagingService>();
    _loadThreads();
  }

  void _loadThreads() {
    final threads = _messagingService.getThreads(limit: 50);
    setState(() {
      _threads = threads;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearch(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _threads.length,
        itemBuilder: (context, index) {
          final thread = _threads[index];
          return MessageThreadTile(
            thread: thread,
            currentUserId: widget.currentUserId,
            onTap: () => _openThread(thread),
            onLongPress: () => _showThreadOptions(thread),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewConversation(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _openThread(MessageThread thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          threadId: thread.id,
          currentUserId: widget.currentUserId,
        ),
      ),
    );
  }

  void _showThreadOptions(MessageThread thread) {
    // Show thread options
  }

  void _showSearch() {
    // Show search
  }

  void _startNewConversation() {
    // Start new conversation
  }
}
```

### Typing Indicator

```dart
class TypingIndicatorWidget extends StatelessWidget {
  final String threadId;
  final int currentUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TypingStatus>(
      stream: context.read<MagentoMessagingService>().getTypingStream(threadId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        
        return TypingIndicator(
          isTyping: snapshot.data == TypingStatus.typing,
          userName: 'User', // Get actual user name
        );
      },
    );
  }
}
```

## 🔧 Configuration

### MessagingConfig

```dart
final config = MessagingConfig(
  enableMessaging: true,
  allowAnonymousMessages: false,
  moderateMessages: false,
  maxMessageLength: 5000,
  maxSubjectLength: 255,
  enableAttachments: true,
  maxAttachmentSize: 10485760, // 10MB
  allowedAttachmentTypes: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx'],
  enableReadReceipts: true,
  enableTypingIndicators: true,
  typingTimeout: Duration(minutes: 30),
);
```

## 🧪 Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magento_messenger/flutter_magento_messenger.dart';

void main() {
  group('MagentoMessagingService', () {
    late MagentoMessagingService service;

    setUp(() {
      service = MagentoMessagingService(
        enablePersistence: false, // Disable for testing
      );
    });

    test('should send message', () async {
      final message = await service.sendMessage(
        senderId: 123,
        recipientId: 456,
        message: 'Test message',
      );

      expect(message.message, 'Test message');
      expect(message.senderId, 123);
      expect(message.recipientId, 456);
    });

    test('should get thread messages', () {
      // Add test messages first
      final messages = service.getThreadMessages('thread_123');
      expect(messages, isA<List<MagentoMessage>>());
    });

    test('should handle typing indicators', () {
      service.startTyping('thread_123', 123);
      service.stopTyping('thread_123');
      // Test typing indicator logic
    });
  });
}
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- **Documentation**: [https://docs.nativemind.net](https://docs.nativemind.net)
- **Issues**: [GitHub Issues](https://github.com/nativemind/flutter_magento_messenger/issues)
- **Email**: support@nativemind.net

## 🔗 Related Packages

- [flutter_magento](https://pub.dev/packages/flutter_magento) - Core Magento integration
- [flutter_magento_notifications](https://pub.dev/packages/flutter_magento_notifications) - Notification functionality
- [flutter_magento_marketplace](https://pub.dev/packages/flutter_magento_marketplace) - Marketplace features

