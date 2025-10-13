import 'package:flutter/material.dart';
import '../models/message_models.dart';
import '../models/message_types.dart';
import 'message_widgets.dart';

/// Widget for displaying a list of messages in a thread
class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onLoadMore,
    this.showTimestamps = true,
    this.showStatus = true,
    this.reverse = false,
    this.isLoading = false,
    this.hasMore = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
  });

  final List<MagentoMessage> messages;
  final int currentUserId;
  final Function(MagentoMessage)? onMessageTap;
  final Function(MagentoMessage)? onMessageLongPress;
  final VoidCallback? onLoadMore;
  final bool showTimestamps;
  final bool showStatus;
  final bool reverse;
  final bool isLoading;
  final bool hasMore;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    if (widget.messages.isEmpty && !widget.isLoading) {
      return widget.emptyWidget ?? _buildEmptyWidget();
    }

    return Column(
      children: [
        if (widget.isLoading && widget.messages.isEmpty)
          widget.loadingWidget ?? _buildLoadingWidget(),
        Expanded(child: _buildMessageList()),
        if (widget.isLoading && widget.messages.isNotEmpty)
          widget.loadingWidget ?? _buildLoadingWidget(),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? 'Failed to load messages',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Retry logic would be handled by parent
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      reverse: widget.reverse,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isFromCurrentUser = message.isFromUser(widget.currentUserId);

        return ChatBubble(
          message: message,
          isFromCurrentUser: isFromCurrentUser,
          onTap: () => widget.onMessageTap?.call(message),
          onLongPress: () => widget.onMessageLongPress?.call(message),
          showTimestamp: widget.showTimestamps,
          showStatus: widget.showStatus,
        );
      },
    );
  }
}

/// Widget for displaying a list of message threads
class ThreadList extends StatefulWidget {
  const ThreadList({
    super.key,
    required this.threads,
    required this.currentUserId,
    this.onThreadTap,
    this.onThreadLongPress,
    this.onLoadMore,
    this.showUnreadCount = true,
    this.isLoading = false,
    this.hasMore = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
  });

  final List<MessageThread> threads;
  final int currentUserId;
  final Function(MessageThread)? onThreadTap;
  final Function(MessageThread)? onThreadLongPress;
  final VoidCallback? onLoadMore;
  final bool showUnreadCount;
  final bool isLoading;
  final bool hasMore;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;

  @override
  State<ThreadList> createState() => _ThreadListState();
}

class _ThreadListState extends State<ThreadList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    if (widget.threads.isEmpty && !widget.isLoading) {
      return widget.emptyWidget ?? _buildEmptyWidget();
    }

    return Column(
      children: [
        if (widget.isLoading && widget.threads.isEmpty)
          widget.loadingWidget ?? _buildLoadingWidget(),
        Expanded(child: _buildThreadList()),
        if (widget.isLoading && widget.threads.isNotEmpty)
          widget.loadingWidget ?? _buildLoadingWidget(),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? 'Failed to load threads',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Retry logic would be handled by parent
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.threads.length,
      itemBuilder: (context, index) {
        final thread = widget.threads[index];
        return MessageThreadTile(
          thread: thread,
          currentUserId: widget.currentUserId,
          onTap: () => widget.onThreadTap?.call(thread),
          onLongPress: () => widget.onThreadLongPress?.call(thread),
          showUnreadCount: widget.showUnreadCount,
        );
      },
    );
  }
}

/// Widget for displaying a searchable list of messages
class SearchableMessageList extends StatefulWidget {
  const SearchableMessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onLoadMore,
    this.showTimestamps = true,
    this.showStatus = true,
    this.reverse = false,
    this.isLoading = false,
    this.hasMore = false,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.hasError = false,
    this.errorMessage,
  });

  final List<MagentoMessage> messages;
  final int currentUserId;
  final Function(MagentoMessage)? onMessageTap;
  final Function(MagentoMessage)? onMessageLongPress;
  final VoidCallback? onLoadMore;
  final bool showTimestamps;
  final bool showStatus;
  final bool reverse;
  final bool isLoading;
  final bool hasMore;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool hasError;
  final String? errorMessage;

  @override
  State<SearchableMessageList> createState() => _SearchableMessageListState();
}

class _SearchableMessageListState extends State<SearchableMessageList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<MagentoMessage> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredMessages = widget.messages;
  }

  @override
  void didUpdateWidget(SearchableMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messages != widget.messages) {
      _filteredMessages = widget.messages;
      _applySearch();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applySearch();
    });
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredMessages = widget.messages;
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredMessages = widget.messages.where((message) {
        return message.message.toLowerCase().contains(query) ||
            (message.subject?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: MessageList(
            messages: _filteredMessages,
            currentUserId: widget.currentUserId,
            onMessageTap: widget.onMessageTap,
            onMessageLongPress: widget.onMessageLongPress,
            onLoadMore: widget.onLoadMore,
            showTimestamps: widget.showTimestamps,
            showStatus: widget.showStatus,
            reverse: widget.reverse,
            isLoading: widget.isLoading,
            hasMore: widget.hasMore,
            emptyWidget: widget.emptyWidget,
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            hasError: widget.hasError,
            errorMessage: widget.errorMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search messages...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
