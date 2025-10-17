import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MediaManagementScreen extends StatefulWidget {
  const MediaManagementScreen({super.key});

  @override
  State<MediaManagementScreen> createState() => _MediaManagementScreenState();
}

class _MediaManagementScreenState extends State<MediaManagementScreen> {
  List<MediaItem> _mediaItems = [];
  String _selectedFilter = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMediaItems();
  }

  void _loadMediaItems() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading media items
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _mediaItems = [
          MediaItem(
            id: '1',
            title: 'Property Photos',
            type: MediaType.photo,
            size: '2.5 MB',
            dateAdded: DateTime.now().subtract(const Duration(days: 1)),
            thumbnail: '🏠',
          ),
          MediaItem(
            id: '2',
            title: 'Virtual Tour',
            type: MediaType.video,
            size: '15.2 MB',
            dateAdded: DateTime.now().subtract(const Duration(days: 2)),
            thumbnail: '🎥',
          ),
          MediaItem(
            id: '3',
            title: 'Property Documents',
            type: MediaType.document,
            size: '1.8 MB',
            dateAdded: DateTime.now().subtract(const Duration(days: 3)),
            thumbnail: '📄',
          ),
          MediaItem(
            id: '4',
            title: 'Drone Footage',
            type: MediaType.video,
            size: '45.7 MB',
            dateAdded: DateTime.now().subtract(const Duration(days: 4)),
            thumbnail: '🚁',
          ),
        ];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.mediaManagement ?? 'Media Management'),
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMediaDialog,
            tooltip: l10n?.addMedia ?? 'Add Media',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _buildFilterChips(),
          
          // Media grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _mediaItems.isEmpty
                    ? _buildEmptyState()
                    : _buildMediaGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final l10n = AppLocalizations.of(context);
    final filters = [
      {'key': 'all', 'label': l10n?.all ?? 'All'},
      {'key': 'photo', 'label': l10n?.photos ?? 'Photos'},
      {'key': 'video', 'label': l10n?.videos ?? 'Videos'},
      {'key': 'document', 'label': l10n?.documents ?? 'Documents'},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter['label']!),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['key']!;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n?.noMediaFound ?? 'No media found',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.addMediaToGetStarted ?? 'Add media to get started',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddMediaDialog,
            icon: const Icon(Icons.add),
            label: Text(l10n?.addMedia ?? 'Add Media'),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    final filteredItems = _selectedFilter == 'all'
        ? _mediaItems
        : _mediaItems.where((item) => item.type.name == _selectedFilter).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildMediaCard(item);
      },
    );
  }

  Widget _buildMediaCard(MediaItem item) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showMediaDetails(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surfaceVariant,
                child: Center(
                  child: Text(
                    item.thumbnail,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
            
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.size,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          _getMediaTypeIcon(item.type),
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getMediaTypeLabel(item.type),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMediaTypeIcon(MediaType type) {
    switch (type) {
      case MediaType.photo:
        return Icons.photo;
      case MediaType.video:
        return Icons.videocam;
      case MediaType.document:
        return Icons.description;
    }
  }

  String _getMediaTypeLabel(MediaType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case MediaType.photo:
        return l10n?.photo ?? 'Photo';
      case MediaType.video:
        return l10n?.video ?? 'Video';
      case MediaType.document:
        return l10n?.document ?? 'Document';
    }
  }

  void _showMediaDetails(MediaItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_getMediaTypeLabel(item.type)}'),
            Text('Size: ${item.size}'),
            Text('Date Added: ${_formatDate(item.dateAdded)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMedia(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddMediaDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.addMedia ?? 'Add Media'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(l10n?.addPhoto ?? 'Add Photo'),
              onTap: () {
                Navigator.pop(context);
                _addMedia(MediaType.photo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l10n?.addVideo ?? 'Add Video'),
              onTap: () {
                Navigator.pop(context);
                _addMedia(MediaType.video);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(l10n?.addDocument ?? 'Add Document'),
              onTap: () {
                Navigator.pop(context);
                _addMedia(MediaType.document);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }

  void _addMedia(MediaType type) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_getMediaTypeLabel(type)} ${l10n?.uploadComingSoon ?? 'upload coming soon!'}'),
      ),
    );
  }

  void _deleteMedia(MediaItem item) {
    setState(() {
      _mediaItems.removeWhere((media) => media.id == item.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} ${AppLocalizations.of(context)?.deleted ?? 'deleted'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class MediaItem {
  final String id;
  final String title;
  final MediaType type;
  final String size;
  final DateTime dateAdded;
  final String thumbnail;

  MediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.size,
    required this.dateAdded,
    required this.thumbnail,
  });
}

enum MediaType {
  photo,
  video,
  document,
}
