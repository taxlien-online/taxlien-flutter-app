import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/media_library_service.dart';
import '../theme/app_colors.dart';

class PlaylistEditorScreen extends StatefulWidget {
  final MediaLibraryService mediaLibraryService;
  final Playlist? playlist; // null для создания нового плейлиста
  
  const PlaylistEditorScreen({
    super.key,
    required this.mediaLibraryService,
    this.playlist,
  });

  @override
  State<PlaylistEditorScreen> createState() => _PlaylistEditorScreenState();
}

class _PlaylistEditorScreenState extends State<PlaylistEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  List<MediaFile> _availableMediaFiles = [];
  List<MediaFile> _selectedMediaFiles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeForm();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final files = await widget.mediaLibraryService.getMediaFiles();
      setState(() {
        _availableMediaFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load media files: $e';
      });
    }
  }

  void _initializeForm() {
    if (widget.playlist != null) {
      _nameController.text = widget.playlist!.name;
      _descriptionController.text = widget.playlist!.description ?? '';
      
      // Загружаем выбранные медиафайлы
      _loadSelectedMediaFiles();
    }
  }

  Future<void> _loadSelectedMediaFiles() async {
    if (widget.playlist != null) {
      try {
        final items = await widget.mediaLibraryService.getPlaylistItems(widget.playlist!.id);
        setState(() {
          _selectedMediaFiles = items;
        });
      } catch (e) {
        // Игнорируем ошибки для совместимости
      }
    }
  }

  Future<void> _savePlaylist() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim();
      final itemIds = _selectedMediaFiles.map((file) => file.id).toList();

      if (widget.playlist != null) {
        // Обновление существующего плейлиста
        await widget.mediaLibraryService.updatePlaylist(
          widget.playlist!.id,
          name: name,
          description: description,
          items: itemIds,
        );
      } else {
        // Создание нового плейлиста
        await widget.mediaLibraryService.createPlaylist(
          name,
          description: description,
          items: itemIds,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.playlist != null 
                ? 'Playlist updated successfully' 
                : 'Playlist created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving playlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addMediaFile(MediaFile file) {
    if (!_selectedMediaFiles.any((f) => f.id == file.id)) {
      setState(() {
        _selectedMediaFiles.add(file);
      });
    }
  }

  void _removeMediaFile(MediaFile file) {
    setState(() {
      _selectedMediaFiles.removeWhere((f) => f.id == file.id);
    });
  }

  void _moveMediaFile(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _selectedMediaFiles.removeAt(oldIndex);
      _selectedMediaFiles.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.playlist != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Playlist' : 'Create Playlist'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _savePlaylist,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    // Форма
                    _buildForm(),
                    
                    // Выбранные медиафайлы
                    Expanded(
                      child: _buildSelectedMediaFiles(),
                    ),
                    
                    // Доступные медиафайлы
                    Expanded(
                      child: _buildAvailableMediaFiles(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Playlist Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a playlist name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMediaFiles() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.playlist_play),
                const SizedBox(width: 8),
                Text(
                  'Selected Media Files (${_selectedMediaFiles.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedMediaFiles.isEmpty
                ? const Center(
                    child: Text(
                      'No media files selected',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _selectedMediaFiles.length,
                    onReorder: _moveMediaFile,
                    itemBuilder: (context, index) {
                      final file = _selectedMediaFiles[index];
                      return _buildSelectedMediaFileItem(file, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMediaFileItem(MediaFile file, int index) {
    return Card(
      key: ValueKey(file.id),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
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
            size: 20,
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
                fontSize: 12,
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
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${index + 1}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _removeMediaFile(file),
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableMediaFiles() {
    final availableFiles = _availableMediaFiles
        .where((file) => !_selectedMediaFiles.any((f) => f.id == file.id))
        .toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.folder),
                const SizedBox(width: 8),
                Text(
                  'Available Media Files (${availableFiles.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: availableFiles.isEmpty
                ? const Center(
                    child: Text(
                      'No available media files',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: availableFiles.length,
                    itemBuilder: (context, index) {
                      final file = availableFiles[index];
                      return _buildAvailableMediaFileItem(file);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableMediaFileItem(MediaFile file) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
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
            size: 20,
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
                fontSize: 12,
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
          ],
        ),
        trailing: IconButton(
          onPressed: () => _addMediaFile(file),
          icon: const Icon(Icons.add_circle_outline),
          color: Colors.green,
          tooltip: 'Add to playlist',
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
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
              _errorMessage!,
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
} 