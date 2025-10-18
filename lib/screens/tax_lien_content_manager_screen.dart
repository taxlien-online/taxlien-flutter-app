import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/server_connection_service.dart';
import '../services/tax_lien_content_service.dart';
import '../theme/app_colors.dart';

class TaxLienContentManagerScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;

  const TaxLienContentManagerScreen({
    super.key,
    required this.serverConnectionService,
  });

  @override
  State<TaxLienContentManagerScreen> createState() =>
      _TaxLienContentManagerScreenState();
}

class _TaxLienContentManagerScreenState
    extends State<TaxLienContentManagerScreen> with TickerProviderStateMixin {
  late TaxLienContentService _contentService;
  bool _isLoading = false;
  String? _errorMessage;

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Content data
  List<TaxLienDocument> _documents = [];
  List<PropertyMedia> _propertyMedia = [];
  List<EducationalContent> _educationalContent = [];
  List<MarketIntelligence> _marketIntelligence = [];
  List<LegalResource> _legalResources = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _contentService = TaxLienContentService(
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
        _loadDocuments(),
        _loadEducationalContent(),
        _loadMarketIntelligence(),
        _loadLegalResources(),
      ]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load content: $e';
      });
    }
  }

  Future<void> _loadDocuments() async {
    try {
      final documents = await _contentService.getDocuments();
      setState(() {
        _documents = documents;
      });
    } catch (e) {
      // Ignore errors for demo
    }
  }

  Future<void> _loadEducationalContent() async {
    try {
      final content = await _contentService.getEducationalContent();
      setState(() {
        _educationalContent = content;
      });
    } catch (e) {
      // Ignore errors for demo
    }
  }

  Future<void> _loadMarketIntelligence() async {
    try {
      final intelligence = await _contentService.getMarketIntelligence();
      setState(() {
        _marketIntelligence = intelligence;
      });
    } catch (e) {
      // Ignore errors for demo
    }
  }

  Future<void> _loadLegalResources() async {
    try {
      final resources = await _contentService.getLegalResources();
      setState(() {
        _legalResources = resources;
      });
    } catch (e) {
      // Ignore errors for demo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Manager'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContentDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.folder),
                  text: 'Documents',
                ),
                Tab(
                  icon: Icon(Icons.photo_library),
                  text: 'Property Media',
                ),
                Tab(
                  icon: Icon(Icons.school),
                  text: 'Educational',
                ),
                Tab(
                  icon: Icon(Icons.analytics),
                  text: 'Market Intel',
                ),
                Tab(
                  icon: Icon(Icons.gavel),
                  text: 'Legal',
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? _buildErrorWidget()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDocumentsTab(),
                          _buildPropertyMediaTab(),
                          _buildEducationalTab(),
                          _buildMarketIntelligenceTab(),
                          _buildLegalResourcesTab(),
                        ],
                      ),
          ),
        ],
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
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return _documents.isEmpty
        ? _buildEmptyState(
            icon: Icons.folder_open,
            title: 'No Documents',
            subtitle: 'Upload your first document to get started',
            actionText: 'Upload Document',
            onAction: () => _showUploadDocumentDialog(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _documents.length,
            itemBuilder: (context, index) {
              final document = _documents[index];
              return _buildDocumentCard(document);
            },
          );
  }

  Widget _buildPropertyMediaTab() {
    return _propertyMedia.isEmpty
        ? _buildEmptyState(
            icon: Icons.photo_library,
            title: 'No Property Media',
            subtitle: 'Add photos and videos of properties',
            actionText: 'Add Media',
            onAction: () => _showAddPropertyMediaDialog(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _propertyMedia.length,
            itemBuilder: (context, index) {
              final media = _propertyMedia[index];
              return _buildPropertyMediaCard(media);
            },
          );
  }

  Widget _buildEducationalTab() {
    return _educationalContent.isEmpty
        ? _buildEmptyState(
            icon: Icons.school,
            title: 'No Educational Content',
            subtitle: 'Add learning materials and courses',
            actionText: 'Add Content',
            onAction: () => _showAddEducationalContentDialog(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _educationalContent.length,
            itemBuilder: (context, index) {
              final content = _educationalContent[index];
              return _buildEducationalContentCard(content);
            },
          );
  }

  Widget _buildMarketIntelligenceTab() {
    return _marketIntelligence.isEmpty
        ? _buildEmptyState(
            icon: Icons.analytics,
            title: 'No Market Intelligence',
            subtitle: 'Add market reports and analysis',
            actionText: 'Add Report',
            onAction: () => _showAddMarketIntelligenceDialog(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _marketIntelligence.length,
            itemBuilder: (context, index) {
              final intelligence = _marketIntelligence[index];
              return _buildMarketIntelligenceCard(intelligence);
            },
          );
  }

  Widget _buildLegalResourcesTab() {
    return _legalResources.isEmpty
        ? _buildEmptyState(
            icon: Icons.gavel,
            title: 'No Legal Resources',
            subtitle: 'Add legal documents and resources',
            actionText: 'Add Resource',
            onAction: () => _showAddLegalResourceDialog(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _legalResources.length,
            itemBuilder: (context, index) {
              final resource = _legalResources[index];
              return _buildLegalResourceCard(resource);
            },
          );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(TaxLienDocument document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDocumentTypeColor(document.type),
          child: Icon(
            _getDocumentTypeIcon(document.type),
            color: Colors.white,
          ),
        ),
        title: Text(document.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.description != null)
              Text(
                document.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 16),
                const SizedBox(width: 4),
                Text(document.category ?? 'Uncategorized'),
                const Spacer(),
                Text(document.formattedFileSize),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              value: 'view',
            ),
            PopupMenuItem(
              child: const Text('Download'),
              value: 'download',
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              value: 'delete',
            ),
          ],
          onSelected: (value) => _handleDocumentAction(document, value),
        ),
      ),
    );
  }

  Widget _buildPropertyMediaCard(PropertyMedia media) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMediaTypeColor(media.type),
          child: Icon(
            _getMediaTypeIcon(media.type),
            color: Colors.white,
          ),
        ),
        title: Text(media.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.description != null)
              Text(
                media.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text('Property ID: ${media.propertyId}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              value: 'view',
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              value: 'delete',
            ),
          ],
          onSelected: (value) => _handlePropertyMediaAction(media, value),
        ),
      ),
    );
  }

  Widget _buildEducationalContentCard(EducationalContent content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getContentTypeColor(content.type),
          child: Icon(
            _getContentTypeIcon(content.type),
            color: Colors.white,
          ),
        ),
        title: Text(content.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.description != null)
              Text(
                content.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(content.difficulty),
                  backgroundColor: _getDifficultyColor(content.difficulty),
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(content.formattedDuration),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              value: 'view',
            ),
            PopupMenuItem(
              child: const Text('Edit'),
              value: 'edit',
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              value: 'delete',
            ),
          ],
          onSelected: (value) =>
              _handleEducationalContentAction(content, value),
        ),
      ),
    );
  }

  Widget _buildMarketIntelligenceCard(MarketIntelligence intelligence) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getIntelligenceTypeColor(intelligence.type),
          child: Icon(
            _getIntelligenceTypeIcon(intelligence.type),
            color: Colors.white,
          ),
        ),
        title: Text(intelligence.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (intelligence.description != null)
              Text(
                intelligence.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (intelligence.source != null) ...[
                  Icon(Icons.source, size: 16),
                  const SizedBox(width: 4),
                  Text(intelligence.source!),
                ],
                const Spacer(),
                if (intelligence.publishedDate != null)
                  Text(
                    _formatDate(intelligence.publishedDate!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              value: 'view',
            ),
            PopupMenuItem(
              child: const Text('Download'),
              value: 'download',
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              value: 'delete',
            ),
          ],
          onSelected: (value) =>
              _handleMarketIntelligenceAction(intelligence, value),
        ),
      ),
    );
  }

  Widget _buildLegalResourceCard(LegalResource resource) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getLegalTypeColor(resource.type),
          child: Icon(
            _getLegalTypeIcon(resource.type),
            color: Colors.white,
          ),
        ),
        title: Text(resource.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.description != null)
              Text(
                resource.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (resource.jurisdiction != null) ...[
                  Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(resource.jurisdiction!),
                ],
                const Spacer(),
                if (resource.isActive)
                  const Chip(
                    label: Text('Active'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('View'),
              value: 'view',
            ),
            PopupMenuItem(
              child: const Text('Download'),
              value: 'download',
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              value: 'delete',
            ),
          ],
          onSelected: (value) => _handleLegalResourceAction(resource, value),
        ),
      ),
    );
  }

  // Helper methods for icons and colors
  Color _getDocumentTypeColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.green;
      case 'audio':
        return Colors.blue;
      case 'video':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.video_library;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getMediaTypeColor(String type) {
    switch (type) {
      case 'photo':
        return Colors.green;
      case 'video':
        return Colors.purple;
      case '360_tour':
        return Colors.orange;
      case 'drone':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getMediaTypeIcon(String type) {
    switch (type) {
      case 'photo':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case '360_tour':
        return Icons.view_in_ar;
      case 'drone':
        return Icons.flight;
      default:
        return Icons.photo_library;
    }
  }

  Color _getContentTypeColor(String type) {
    switch (type) {
      case 'video':
        return Colors.red;
      case 'article':
        return Colors.green;
      case 'webinar':
        return Colors.orange;
      case 'course':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getContentTypeIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.video_library;
      case 'article':
        return Icons.article;
      case 'webinar':
        return Icons.cast;
      case 'course':
        return Icons.school;
      default:
        return Icons.menu_book;
    }
  }

  Color _getIntelligenceTypeColor(String type) {
    switch (type) {
      case 'report':
        return Colors.blue;
      case 'analysis':
        return Colors.green;
      case 'forecast':
        return Colors.orange;
      case 'news':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIntelligenceTypeIcon(String type) {
    switch (type) {
      case 'report':
        return Icons.assessment;
      case 'analysis':
        return Icons.analytics;
      case 'forecast':
        return Icons.trending_up;
      case 'news':
        return Icons.newspaper;
      default:
        return Icons.insights;
    }
  }

  Color _getLegalTypeColor(String type) {
    switch (type) {
      case 'law':
        return Colors.red;
      case 'regulation':
        return Colors.orange;
      case 'case_study':
        return Colors.blue;
      case 'template':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getLegalTypeIcon(String type) {
    switch (type) {
      case 'law':
        return Icons.gavel;
      case 'regulation':
        return Icons.rule;
      case 'case_study':
        return Icons.cases;
      case 'template':
        return Icons.description;
      default:
        return Icons.library_books;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  // Action handlers
  void _handleDocumentAction(TaxLienDocument document, String action) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing document: ${document.title}')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading document: ${document.title}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing document: ${document.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation('document', document.title, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document deleted: ${document.title}')),
          );
        });
        break;
    }
  }

  void _handlePropertyMediaAction(PropertyMedia media, String action) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing media: ${media.title}')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading media: ${media.title}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing media: ${media.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation('media', media.title, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Media deleted: ${media.title}')),
          );
        });
        break;
    }
  }

  void _handleEducationalContentAction(
      EducationalContent content, String action) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing content: ${content.title}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing content: ${content.title}')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing content: ${content.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation('content', content.title, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Content deleted: ${content.title}')),
          );
        });
        break;
    }
  }

  void _handleMarketIntelligenceAction(
      MarketIntelligence intelligence, String action) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Viewing intelligence: ${intelligence.title}')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Exporting intelligence: ${intelligence.title}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Editing intelligence: ${intelligence.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation('intelligence', intelligence.title, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Intelligence deleted: ${intelligence.title}')),
          );
        });
        break;
    }
  }

  void _handleLegalResourceAction(LegalResource resource, String action) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing resource: ${resource.title}')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading resource: ${resource.title}')),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing resource: ${resource.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation('resource', resource.title, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Resource deleted: ${resource.title}')),
          );
        });
        break;
    }
  }

  void _showDeleteConfirmation(
      String type, String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this $type: $title?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search term',
                hintText: 'Enter search term...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle search input
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Content Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Content')),
                DropdownMenuItem(value: 'documents', child: Text('Documents')),
                DropdownMenuItem(value: 'media', child: Text('Property Media')),
                DropdownMenuItem(
                    value: 'educational', child: Text('Educational Content')),
                DropdownMenuItem(
                    value: 'intelligence', child: Text('Market Intelligence')),
                DropdownMenuItem(
                    value: 'legal', child: Text('Legal Resources')),
              ],
              onChanged: (value) {
                // Handle content type selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform search
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Search functionality coming soon!')),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Upload Document'),
              subtitle:
                  const Text('Add property documents, certificates, etc.'),
              onTap: () {
                Navigator.pop(context);
                _showUploadDocumentDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Add Property Media'),
              subtitle: const Text('Add photos, videos, virtual tours'),
              onTap: () {
                Navigator.pop(context);
                _showAddPropertyMediaDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Add Educational Content'),
              subtitle: const Text('Add guides, tutorials, resources'),
              onTap: () {
                Navigator.pop(context);
                _showAddEducationalContentDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Add Market Intelligence'),
              subtitle: const Text('Add market reports, trends, analysis'),
              onTap: () {
                Navigator.pop(context);
                _showAddMarketIntelligenceDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Add Legal Resource'),
              subtitle: const Text('Add legal documents, forms, templates'),
              onTap: () {
                Navigator.pop(context);
                _showAddLegalResourceDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUploadDocumentDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'property_document';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Upload Document'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Document Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'property_document',
                        child: Text('Property Document')),
                    DropdownMenuItem(
                        value: 'certificate', child: Text('Certificate')),
                    DropdownMenuItem(
                        value: 'legal_document', child: Text('Legal Document')),
                    DropdownMenuItem(
                        value: 'financial_document',
                        child: Text('Financial Document')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle file selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('File selection coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Select File'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Document upload functionality coming soon!')),
                  );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPropertyMediaDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'photo';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Property Media'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Media Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Media Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'photo', child: Text('Photo')),
                    DropdownMenuItem(value: 'video', child: Text('Video')),
                    DropdownMenuItem(
                        value: 'virtual_tour', child: Text('Virtual Tour')),
                    DropdownMenuItem(
                        value: 'drone_footage', child: Text('Drone Footage')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Media selection coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Media'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Property media functionality coming soon!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEducationalContentDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'guide';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Educational Content'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Content Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'guide', child: Text('Guide')),
                    DropdownMenuItem(
                        value: 'tutorial', child: Text('Tutorial')),
                    DropdownMenuItem(value: 'faq', child: Text('FAQ')),
                    DropdownMenuItem(
                        value: 'resource', child: Text('Resource')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Educational content functionality coming soon!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMarketIntelligenceDialog() {
    final titleController = TextEditingController();
    final reportController = TextEditingController();
    String selectedType = 'market_report';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Market Intelligence'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Report Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Report Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'market_report', child: Text('Market Report')),
                    DropdownMenuItem(
                        value: 'trend_analysis', child: Text('Trend Analysis')),
                    DropdownMenuItem(
                        value: 'forecast', child: Text('Forecast')),
                    DropdownMenuItem(
                        value: 'comparison', child: Text('Market Comparison')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reportController,
                  decoration: const InputDecoration(
                    labelText: 'Report Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    reportController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Market intelligence functionality coming soon!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLegalResourceDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'legal_document';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Legal Resource'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Resource Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Resource Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'legal_document', child: Text('Legal Document')),
                    DropdownMenuItem(value: 'form', child: Text('Form')),
                    DropdownMenuItem(
                        value: 'template', child: Text('Template')),
                    DropdownMenuItem(
                        value: 'regulation', child: Text('Regulation')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('File selection coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Select File'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Legal resource functionality coming soon!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
