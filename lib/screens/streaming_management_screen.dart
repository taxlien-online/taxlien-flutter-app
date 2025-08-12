import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/media_library_service.dart';
import '../theme/app_colors.dart';

class StreamingManagementScreen extends StatefulWidget {
  final MediaLibraryService mediaLibraryService;
  
  const StreamingManagementScreen({
    super.key,
    required this.mediaLibraryService,
  });

  @override
  State<StreamingManagementScreen> createState() => _StreamingManagementScreenState();
}

class _StreamingManagementScreenState extends State<StreamingManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  List<StreamingSource> _streamingSources = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedType = 'live';
  String _selectedStatus = 'active';

  @override
  void initState() {
    super.initState();
    _loadStreamingSources();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadStreamingSources() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sources = await widget.mediaLibraryService.getStreamingSources();
      setState(() {
        _streamingSources = sources;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load streaming sources: $e';
      });
    }
  }

  Future<void> _playStreamingSource(StreamingSource source) async {
    try {
      await widget.mediaLibraryService.playStreamingSource(source.id);
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

  void _showAddStreamingSourceDialog() {
    _nameController.clear();
    _urlController.clear();
    _descriptionController.clear();
    _selectedType = 'live';
    _selectedStatus = 'active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Streaming Source'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a URL';
                    }
                    if (!Uri.tryParse(value)?.hasAbsolutePath ?? true) {
                      return 'Please enter a valid URL';
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'live', child: Text('Live')),
                          DropdownMenuItem(value: 'interactive', child: Text('Interactive')),
                          DropdownMenuItem(value: 'data', child: Text('Data')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'active', child: Text('Active')),
                          DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addStreamingSource,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addStreamingSource() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Здесь должна быть реализация добавления источника стриминга
      // Пока что просто закрываем диалог
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Streaming source added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      await _loadStreamingSources();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding streaming source: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteStreamingSource(StreamingSource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Streaming Source'),
        content: Text('Are you sure you want to delete "${source.name}"?'),
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
        // Здесь должна быть реализация удаления источника стриминга
        await _loadStreamingSources();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Streaming source deleted successfully'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming Management'),
        actions: [
          IconButton(
            onPressed: _loadStreamingSources,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : _streamingSources.isEmpty
                  ? _buildEmptyState()
                  : _buildStreamingSourcesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStreamingSourceDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Streaming Source',
      ),
    );
  }

  Widget _buildStreamingSourcesList() {
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
            Text(
              source.url,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            IconButton(
              onPressed: () => _deleteStreamingSource(source),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.stream,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No streaming sources found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add streaming sources to your server to see them here',
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
              'Error loading streaming sources',
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
              onPressed: _loadStreamingSources,
              child: const Text('Retry'),
            ),
          ],
        ),
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