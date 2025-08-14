import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/server_connection_service.dart';
import '../services/tax_lien_content_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class TaxLienContentManagerScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;
  
  const TaxLienContentManagerScreen({
    super.key, 
    required this.serverConnectionService,
  });

  @override
  State<TaxLienContentManagerScreen> createState() => _TaxLienContentManagerScreenState();
}

class _TaxLienContentManagerScreenState extends State<TaxLienContentManagerScreen> 
    with TickerProviderStateMixin {
  late TaxLienContentService _contentService;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentTabIndex = 0;
  
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
        title: Text(AppLocalizations.of(context)?.contentManager ?? 'Content Manager'),
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
              tabs: [
                Tab(
                  icon: const Icon(Icons.folder),
                  text: AppLocalizations.of(context)?.documents ?? 'Documents',
                ),
                Tab(
                  icon: const Icon(Icons.photo_library),
                  text: AppLocalizations.of(context)?.propertyMedia ?? 'Property Media',
                ),
                Tab(
                  icon: const Icon(Icons.school),
                  text: AppLocalizations.of(context)?.educational ?? 'Educational',
                ),
                Tab(
                  icon: const Icon(Icons.analytics),
                  text: AppLocalizations.of(context)?.marketIntelligence ?? 'Market Intel',
                ),
                Tab(
                  icon: const Icon(Icons.gavel),
                  text: AppLocalizations.of(context)?.legalResources ?? 'Legal',
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
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
          onSelected: (value) => _handleEducationalContentAction(content, value),
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
          onSelected: (value) => _handleMarketIntelligenceAction(intelligence, value),
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
      case 'pdf': return Colors.red;
      case 'image': return Colors.green;
      case 'audio': return Colors.blue;
      case 'video': return Colors.purple;
      default: return Colors.grey;
    }
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'image': return Icons.image;
      case 'audio': return Icons.audiotrack;
      case 'video': return Icons.video_library;
      default: return Icons.insert_drive_file;
    }
  }

  Color _getMediaTypeColor(String type) {
    switch (type) {
      case 'photo': return Colors.green;
      case 'video': return Colors.purple;
      case '360_tour': return Colors.orange;
      case 'drone': return Colors.blue;
      default: return Colors.grey;
    }
  }

  IconData _getMediaTypeIcon(String type) {
    switch (type) {
      case 'photo': return Icons.photo;
      case 'video': return Icons.videocam;
      case '360_tour': return Icons.view_in_ar;
      case 'drone': return Icons.flight;
      default: return Icons.photo_library;
    }
  }

  Color _getContentTypeColor(String type) {
    switch (type) {
      case 'video': return Colors.red;
      case 'article': return Colors.green;
      case 'webinar': return Colors.orange;
      case 'course': return Colors.blue;
      default: return Colors.grey;
    }
  }

  IconData _getContentTypeIcon(String type) {
    switch (type) {
      case 'video': return Icons.video_library;
      case 'article': return Icons.article;
      case 'webinar': return Icons.cast;
      case 'course': return Icons.school;
      default: return Icons.menu_book;
    }
  }

  Color _getIntelligenceTypeColor(String type) {
    switch (type) {
      case 'report': return Colors.blue;
      case 'analysis': return Colors.green;
      case 'forecast': return Colors.orange;
      case 'news': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getIntelligenceTypeIcon(String type) {
    switch (type) {
      case 'report': return Icons.assessment;
      case 'analysis': return Icons.analytics;
      case 'forecast': return Icons.trending_up;
      case 'news': return Icons.newspaper;
      default: return Icons.insights;
    }
  }

  Color _getLegalTypeColor(String type) {
    switch (type) {
      case 'law': return Colors.red;
      case 'regulation': return Colors.orange;
      case 'case_study': return Colors.blue;
      case 'template': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _getLegalTypeIcon(String type) {
    switch (type) {
      case 'law': return Icons.gavel;
      case 'regulation': return Icons.rule;
      case 'case_study': return Icons.cases;
      case 'template': return Icons.description;
      default: return Icons.library_books;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner': return Colors.green;
      case 'intermediate': return Colors.orange;
      case 'advanced': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  // Action handlers
  void _handleDocumentAction(TaxLienDocument document, String action) {
    // TODO: Implement document actions
  }

  void _handlePropertyMediaAction(PropertyMedia media, String action) {
    // TODO: Implement property media actions
  }

  void _handleEducationalContentAction(EducationalContent content, String action) {
    // TODO: Implement educational content actions
  }

  void _handleMarketIntelligenceAction(MarketIntelligence intelligence, String action) {
    // TODO: Implement market intelligence actions
  }

  void _handleLegalResourceAction(LegalResource resource, String action) {
    // TODO: Implement legal resource actions
  }

  // Dialog methods
  void _showSearchDialog() {
    // TODO: Implement search dialog
  }

  void _showAddContentDialog() {
    // TODO: Implement add content dialog
  }

  void _showUploadDocumentDialog() {
    // TODO: Implement upload document dialog
  }

  void _showAddPropertyMediaDialog() {
    // TODO: Implement add property media dialog
  }

  void _showAddEducationalContentDialog() {
    // TODO: Implement add educational content dialog
  }

  void _showAddMarketIntelligenceDialog() {
    // TODO: Implement add market intelligence dialog
  }

  void _showAddLegalResourceDialog() {
    // TODO: Implement add legal resource dialog
  }
}
