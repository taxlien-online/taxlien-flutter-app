import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import '../services/server_connection_service.dart';
import '../services/media_library_service.dart';
import '../theme/app_colors.dart';
import 'playlist_editor_screen.dart';

class MediaLibraryScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;
  
  const MediaLibraryScreen({
    super.key, 
    required this.serverConnectionService,
  });

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> with TickerProviderStateMixin {
  late MediaLibraryService _mediaLibraryService;
  List<MediaFile> _mediaFiles = [];
  List<Playlist> _playlists = [];
  List<StreamingSource> _streamingSources = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  int _currentTabIndex = 0;
  
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _mediaLibraryService = MediaLibraryService(
      apiService: widget.serverConnectionService.apiService,
      configService: widget.serverConnectionService.configService,
    );
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _loadMediaFiles(),
        _loadPlaylists(),
        _loadStreamingSources(),
      ]);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _loadMediaFiles() async {
    try {
      final files = await _mediaLibraryService.getMediaFiles();
      setState(() {
        _mediaFiles = files;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load media files: $e';
      });
    }
  }

  Future<void> _loadPlaylists() async {
    try {
      final playlists = await _mediaLibraryService.getPlaylists();
      setState(() {
        _playlists = playlists;
      });
    } catch (e) {
      // Игнорируем ошибки плейлистов для совместимости
    }
  }

  Future<void> _loadStreamingSources() async {
    try {
      final sources = await _mediaLibraryService.getStreamingSources();
      setState(() {
        _streamingSources = sources;
      });
    } catch (e) {
      // Игнорируем ошибки стриминга для совместимости
    }
  }

  Future<void> _playMediaFile(MediaFile file) async {
    try {
      await _mediaLibraryService.playMediaFile(file.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing: ${file.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _playPlaylist(Playlist playlist) async {
    try {
      await _mediaLibraryService.playPlaylist(playlist.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing playlist: ${playlist.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing playlist: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _playStreamingSource(StreamingSource source) async {
    try {
      await _mediaLibraryService.playStreamingSource(source.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing stream: ${source.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing stream: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadMediaFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'jpg', 'jpeg', 'png', 'gif'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        
        setState(() {
          _isLoading = true;
        });

        try {
          await _mediaLibraryService.uploadMediaFile(file);
          await _loadMediaFiles();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteMediaFile(MediaFile file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media File'),
        content: Text('Are you sure you want to delete "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _mediaLibraryService.deleteMediaFile(file.id);
        await _loadMediaFiles();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createPlaylist() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistEditorScreen(
          mediaLibraryService: _mediaLibraryService,
        ),
      ),
    );

    if (result == true) {
      await _loadPlaylists();
    }
  }

  Future<void> _editPlaylist(Playlist playlist) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistEditorScreen(
          mediaLibraryService: _mediaLibraryService,
          playlist: playlist,
        ),
      ),
    );

    if (result == true) {
      await _loadPlaylists();
    }
  }

  Future<void> _deletePlaylist(Playlist playlist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _mediaLibraryService.deletePlaylist(playlist.id);
        await _loadPlaylists();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Playlist deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<MediaFile> get _filteredMediaFiles {
    List<MediaFile> files = _mediaFiles;

    // Фильтрация по типу
    if (_selectedFilter != 'all') {
      files = files.where((file) => file.type == _selectedFilter).toList();
    }

    // Поиск
    if (_searchQuery.isNotEmpty) {
      files = files.where((file) => 
        file.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Заголовок
          _buildHeader(l10n),
          
          // Поиск и фильтры
          _buildSearchAndFilters(l10n),
          
          // Табы
          _buildTabs(l10n),
          
          // Контент
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMediaFilesTab(l10n),
                _buildPlaylistsTab(l10n),
                _buildStreamingTab(l10n),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTabIndex == 0 
          ? FloatingActionButton(
              onPressed: _uploadMediaFile,
              child: const Icon(Icons.upload),
              tooltip: 'Upload Media File',
            )
          : _currentTabIndex == 1
              ? FloatingActionButton(
                  onPressed: _createPlaylist,
                  child: const Icon(Icons.add),
                  tooltip: 'Create Playlist',
                )
              : null,
    );
  }

  Widget _buildHeader(AppLocalizations? l10n) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.folder,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.mediaFiles ?? 'Media Library',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your media files, playlists and streaming sources',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations? l10n) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поиск
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search media files...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                ) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            // Фильтры
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All', Icons.all_inclusive),
                  _buildFilterChip('video', 'Videos', Icons.video_file),
                  _buildFilterChip('image', 'Images', Icons.image),
                  _buildFilterChip('audio', 'Audio', Icons.audiotrack),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildTabs(AppLocalizations? l10n) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        tabs: [
          Tab(
            icon: const Icon(Icons.video_file),
            text: 'Media Files',
          ),
          Tab(
            icon: const Icon(Icons.playlist_play),
            text: 'Playlists',
          ),
          Tab(
            icon: const Icon(Icons.stream),
            text: 'Streaming',
          ),
        ],
      ),
    );
  }

  Widget _buildMediaFilesTab(AppLocalizations? l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }

    if (_filteredMediaFiles.isEmpty) {
      return _buildEmptyState(
        icon: Icons.folder_open,
        title: 'No media files found',
        subtitle: _searchQuery.isNotEmpty || _selectedFilter != 'all'
            ? 'Try adjusting your search or filters'
            : 'Add media files to your server to see them here',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMediaFiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredMediaFiles.length,
        itemBuilder: (context, index) {
          final file = _filteredMediaFiles[index];
          return _buildMediaFileItem(file);
        },
      ),
    );
  }

  Widget _buildPlaylistsTab(AppLocalizations? l10n) {
    if (_playlists.isEmpty) {
      return _buildEmptyState(
        icon: Icons.playlist_play,
        title: 'No playlists found',
        subtitle: 'Create playlists to organize your media files',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPlaylists,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          final playlist = _playlists[index];
          return _buildPlaylistItem(playlist);
        },
      ),
    );
  }

  Widget _buildStreamingTab(AppLocalizations? l10n) {
    if (_streamingSources.isEmpty) {
      return _buildEmptyState(
        icon: Icons.stream,
        title: 'No streaming sources found',
        subtitle: 'Add streaming sources to your server to see them here',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadStreamingSources,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _streamingSources.length,
        itemBuilder: (context, index) {
          final source = _streamingSources[index];
          return _buildStreamingSourceItem(source);
        },
      ),
    );
  }

  Widget _buildMediaFileItem(MediaFile file) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: file.isVideo 
                ? Colors.blue.withOpacity(0.1) 
                : file.isImage 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            file.isVideo 
                ? Icons.video_file 
                : file.isImage 
                    ? Icons.image
                    : Icons.audiotrack,
            color: file.isVideo 
                ? Colors.blue 
                : file.isImage 
                    ? Colors.green
                    : Colors.orange,
            size: 24,
          ),
        ),
        title: Text(
          file.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file.type.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            if (file.duration != null)
              Text(
                file.formattedDuration,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            if (file.size != null)
              Text(
                'Size: ${file.size}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _playMediaFile(file),
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play',
            ),
            IconButton(
              onPressed: () => _showMediaFileDetails(file),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Details',
            ),
            IconButton(
              onPressed: () => _deleteMediaFile(file),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistItem(Playlist playlist) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.playlist_play,
            color: Colors.purple,
            size: 24,
          ),
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playlist.description != null)
              Text(
                playlist.description!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            Text(
              '${playlist.items.length} items',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            if (playlist.duration != null)
              Text(
                'Duration: ${playlist.formattedDuration}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _playPlaylist(playlist),
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play',
            ),
            IconButton(
              onPressed: () => _editPlaylist(playlist),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
            ),
            IconButton(
              onPressed: () => _showPlaylistDetails(playlist),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Details',
            ),
            IconButton(
              onPressed: () => _deletePlaylist(playlist),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamingSourceItem(StreamingSource source) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: source.isActive 
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
                      child: Icon(
            source.isLive 
                ? Icons.live_tv 
                : source.isInteractive 
                    ? Icons.touch_app
                    : Icons.data_usage,
            color: source.isActive 
                ? Colors.green
                : Colors.grey,
            size: 24,
          ),
        ),
        title: Text(
          source.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              source.type.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              source.status,
              style: TextStyle(
                color: source.isActive ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
            if (source.description != null)
              Text(
                source.description!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: source.isActive ? () => _playStreamingSource(source) : null,
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play',
            ),
            IconButton(
              onPressed: () => _showStreamingSourceDetails(source),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Details',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMediaFileDetails(MediaFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(file.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${file.type}'),
            if (file.duration != null)
              Text('Duration: ${file.formattedDuration}'),
            if (file.size != null)
              Text('Size: ${file.size}'),
            if (file.resolution != null)
              Text('Resolution: ${file.resolution}'),
            if (file.format != null)
              Text('Format: ${file.format}'),
            if (file.path != null)
              Text('Path: ${file.path}'),
            if (file.createdAt != null)
              Text('Created: ${file.createdAt!.toString().split('.')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _playMediaFile(file);
              Navigator.pop(context);
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }

  void _showPlaylistDetails(Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(playlist.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playlist.description != null)
              Text('Description: ${playlist.description}'),
            Text('Items: ${playlist.items.length}'),
            if (playlist.duration != null)
              Text('Duration: ${playlist.formattedDuration}'),
            if (playlist.created != null)
              Text('Created: ${playlist.created!.toString().split('.')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _playPlaylist(playlist);
              Navigator.pop(context);
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }

  void _showStreamingSourceDetails(StreamingSource source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(source.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${source.type}'),
            Text('Status: ${source.status}'),
            Text('URL: ${source.url}'),
            if (source.description != null)
              Text('Description: ${source.description}'),
            if (source.createdAt != null)
              Text('Created: ${source.createdAt!.toString().split('.')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (source.isActive)
            ElevatedButton(
              onPressed: () {
                _playStreamingSource(source);
                Navigator.pop(context);
              },
              child: const Text('Play'),
            ),
        ],
      ),
    );
  }
} 