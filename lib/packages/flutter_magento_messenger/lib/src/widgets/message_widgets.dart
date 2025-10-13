import 'package:flutter/material.dart';
import '../models/message_models.dart';
import '../models/message_types.dart';

/// Chat bubble widget for displaying messages
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
    this.onTap,
    this.onLongPress,
    this.showTimestamp = true,
    this.showStatus = true,
  });

  final MagentoMessage message;
  final bool isFromCurrentUser;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showTimestamp;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                message.senderId.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isFromCurrentUser
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isFromCurrentUser ? 20 : 4),
                      bottomRight: Radius.circular(isFromCurrentUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.subject != null) ...[
                        Text(
                          message.subject!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isFromCurrentUser
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (message.hasAttachment) ...[
                        _buildAttachment(context),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        message.message,
                        style: TextStyle(
                          color: isFromCurrentUser
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showTimestamp || showStatus) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showTimestamp) ...[
                        Text(
                          message.formattedTimestamp,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        if (showStatus) const SizedBox(width: 8),
                      ],
                      if (showStatus && isFromCurrentUser) ...[
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 16,
                          color: message.isRead
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                message.senderId.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachment(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isFromCurrentUser
            ? Colors.white.withOpacity(0.2)
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getAttachmentIcon(),
            size: 20,
            color: isFromCurrentUser
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message.attachmentFileName ?? 'Attachment',
              style: TextStyle(
                color: isFromCurrentUser
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAttachmentIcon() {
    if (message.isImageAttachment) return Icons.image;
    if (message.isDocumentAttachment) return Icons.description;
    return Icons.attach_file;
  }
}

/// Message input widget for sending messages
class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.onSendMessage,
    this.onSendAttachment,
    this.hintText = 'Type a message...',
    this.enabled = true,
  });

  final Function(String message) onSendMessage;
  final VoidCallback? onSendAttachment;
  final String hintText;
  final bool enabled;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty && widget.enabled) {
      widget.onSendMessage(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (widget.onSendAttachment != null) ...[
              IconButton(
                onPressed: widget.enabled ? widget.onSendAttachment : null,
                icon: const Icon(Icons.attach_file),
                tooltip: 'Attach file',
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.enabled ? _sendMessage : null,
              icon: const Icon(Icons.send),
              tooltip: 'Send message',
            ),
          ],
        ),
      ),
    );
  }
}

/// Message list widget for displaying conversation
class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.onMessageTap,
    this.onMessageLongPress,
    this.showTimestamps = true,
    this.showStatus = true,
    this.reverse = false,
  });

  final List<MagentoMessage> messages;
  final int currentUserId;
  final Function(MagentoMessage)? onMessageTap;
  final Function(MagentoMessage)? onMessageLongPress;
  final bool showTimestamps;
  final bool showStatus;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: reverse,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isFromCurrentUser = message.isFromUser(currentUserId);

        return ChatBubble(
          message: message,
          isFromCurrentUser: isFromCurrentUser,
          onTap: onMessageTap != null ? () => onMessageTap!(message) : null,
          onLongPress: onMessageLongPress != null
              ? () => onMessageLongPress!(message)
              : null,
          showTimestamp: showTimestamps,
          showStatus: showStatus,
        );
      },
    );
  }
}

/// Typing indicator widget
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({
    super.key,
    required this.isTyping,
    this.userName,
  });

  final bool isTyping;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    if (!isTyping) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName != null ? '$userName is typing...' : 'Typing...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Message thread list tile
class MessageThreadTile extends StatelessWidget {
  const MessageThreadTile({
    super.key,
    required this.thread,
    required this.currentUserId,
    this.onTap,
    this.onLongPress,
    this.showUnreadCount = true,
  });

  final MessageThread thread;
  final int currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showUnreadCount;

  @override
  Widget build(BuildContext context) {
    final otherParticipantName = thread.getOtherParticipantName(currentUserId);
    final otherParticipantAvatar = thread.getOtherParticipantAvatar(currentUserId);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: otherParticipantAvatar != null
            ? NetworkImage(otherParticipantAvatar)
            : null,
        child: otherParticipantAvatar == null
            ? Text(
                otherParticipantName.isNotEmpty
                    ? otherParticipantName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        otherParticipantName,
        style: TextStyle(
          fontWeight: thread.hasUnreadMessages
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            thread.previewText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: thread.hasUnreadMessages
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          if (thread.lastMessage != null) ...[
            const SizedBox(height: 2),
            Text(
              thread.formattedLastMessageTime,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
      trailing: thread.hasUnreadMessages && showUnreadCount
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              child: Text(
                thread.unreadCount > 99 ? '99+' : thread.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}


