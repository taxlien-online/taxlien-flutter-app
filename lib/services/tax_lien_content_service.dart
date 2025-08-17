import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'server_config_service.dart';

// Document Library Models
class TaxLienDocument {
  final int id;
  final String title;
  final String type; // 'pdf', 'image', 'audio', 'video'
  final String? description;
  final String? category; // 'legal', 'property', 'financial', 'educational'
  final String path;
  final int? fileSize;
  final String? format;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

  TaxLienDocument({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.category,
    required this.path,
    this.fileSize,
    this.format,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
  });

  factory TaxLienDocument.fromJson(Map<String, dynamic> json) {
    return TaxLienDocument(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      path: json['path'] as String,
      fileSize: json['file_size'] as int?,
      format: json['format'] as String?,
      createdAt: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
      updatedAt: json['updated'] != null 
          ? DateTime.parse(json['updated'] as String) 
          : null,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'category': category,
      'path': path,
      'file_size': fileSize,
      'format': format,
      'created': createdAt?.toIso8601String(),
      'updated': updatedAt?.toIso8601String(),
      'tags': tags,
    };
  }

  String get formattedFileSize {
    if (fileSize == null) return 'N/A';
    if (fileSize! < 1024) return '${fileSize!} B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isPdf => type == 'pdf';
  bool get isImage => type == 'image';
  bool get isAudio => type == 'audio';
  bool get isVideo => type == 'video';
}

// Property Media Models
class PropertyMedia {
  final int id;
  final String propertyId;
  final String title;
  final String type; // 'photo', 'video', '360_tour', 'drone'
  final String? description;
  final String path;
  final String? thumbnailPath;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata; // GPS, dimensions, etc.

  PropertyMedia({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.type,
    this.description,
    required this.path,
    this.thumbnailPath,
    this.createdAt,
    this.metadata,
  });

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    return PropertyMedia(
      id: json['id'] as int,
      propertyId: json['property_id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      path: json['path'] as String,
      thumbnailPath: json['thumbnail_path'] as String?,
      createdAt: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'title': title,
      'type': type,
      'description': description,
      'path': path,
      'thumbnail_path': thumbnailPath,
      'created': createdAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isPhoto => type == 'photo';
  bool get isVideo => type == 'video';
  bool get is360Tour => type == '360_tour';
  bool get isDrone => type == 'drone';
}

// Educational Content Models
class EducationalContent {
  final int id;
  final String title;
  final String type; // 'video', 'article', 'webinar', 'course'
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? thumbnailPath;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final int? duration; // in minutes
  final List<String> topics;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EducationalContent({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.content,
    this.videoUrl,
    this.thumbnailPath,
    required this.difficulty,
    this.duration,
    this.topics = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailPath: json['thumbnail_path'] as String?,
      difficulty: json['difficulty'] as String,
      duration: json['duration'] as int?,
      topics: List<String>.from(json['topics'] ?? []),
      createdAt: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
      updatedAt: json['updated'] != null 
          ? DateTime.parse(json['updated'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'content': content,
      'video_url': videoUrl,
      'thumbnail_path': thumbnailPath,
      'difficulty': difficulty,
      'duration': duration,
      'topics': topics,
      'created': createdAt?.toIso8601String(),
      'updated': updatedAt?.toIso8601String(),
    };
  }

  String get formattedDuration {
    if (duration == null) return 'N/A';
    final hours = (duration! / 60).floor();
    final minutes = duration! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  bool get isVideo => type == 'video';
  bool get isArticle => type == 'article';
  bool get isWebinar => type == 'webinar';
  bool get isCourse => type == 'course';
}

// Market Intelligence Models
class MarketIntelligence {
  final int id;
  final String title;
  final String type; // 'report', 'analysis', 'forecast', 'news'
  final String? description;
  final String? content;
  final String? source;
  final String? author;
  final DateTime? publishedDate;
  final List<String> regions;
  final List<String> tags;
  final String? pdfPath;
  final String? thumbnailPath;

  MarketIntelligence({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.content,
    this.source,
    this.author,
    this.publishedDate,
    this.regions = const [],
    this.tags = const [],
    this.pdfPath,
    this.thumbnailPath,
  });

  factory MarketIntelligence.fromJson(Map<String, dynamic> json) {
    return MarketIntelligence(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      source: json['source'] as String?,
      author: json['author'] as String?,
      publishedDate: json['published_date'] != null 
          ? DateTime.parse(json['published_date'] as String) 
          : null,
      regions: List<String>.from(json['regions'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      pdfPath: json['pdf_path'] as String?,
      thumbnailPath: json['thumbnail_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'content': content,
      'source': source,
      'author': author,
      'published_date': publishedDate?.toIso8601String(),
      'regions': regions,
      'tags': tags,
      'pdf_path': pdfPath,
      'thumbnail_path': thumbnailPath,
    };
  }

  bool get isReport => type == 'report';
  bool get isAnalysis => type == 'analysis';
  bool get isForecast => type == 'forecast';
  bool get isNews => type == 'news';
}

// Legal Resources Models
class LegalResource {
  final int id;
  final String title;
  final String type; // 'law', 'regulation', 'case_study', 'template'
  final String? description;
  final String? content;
  final String? jurisdiction;
  final String? category; // 'federal', 'state', 'local'
  final DateTime? effectiveDate;
  final DateTime? expirationDate;
  final String? pdfPath;
  final List<String> tags;
  final bool isActive;

  LegalResource({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.content,
    this.jurisdiction,
    this.category,
    this.effectiveDate,
    this.expirationDate,
    this.pdfPath,
    this.tags = const [],
    this.isActive = true,
  });

  factory LegalResource.fromJson(Map<String, dynamic> json) {
    return LegalResource(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      jurisdiction: json['jurisdiction'] as String?,
      category: json['category'] as String?,
      effectiveDate: json['effective_date'] != null 
          ? DateTime.parse(json['effective_date'] as String) 
          : null,
      expirationDate: json['expiration_date'] != null 
          ? DateTime.parse(json['expiration_date'] as String) 
          : null,
      pdfPath: json['pdf_path'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'content': content,
      'jurisdiction': jurisdiction,
      'category': category,
      'effective_date': effectiveDate?.toIso8601String(),
      'expiration_date': expirationDate?.toIso8601String(),
      'pdf_path': pdfPath,
      'tags': tags,
      'is_active': isActive,
    };
  }

  bool get isLaw => type == 'law';
  bool get isRegulation => type == 'regulation';
  bool get isCaseStudy => type == 'case_study';
  bool get isTemplate => type == 'template';
}

class TaxLienContentService {
  final ApiService _apiService;
  final ServerConfigService _configService;

  TaxLienContentService({
    required ApiService apiService,
    required ServerConfigService configService,
  }) : _apiService = apiService, _configService = configService;

  // Document Library Methods
  Future<List<TaxLienDocument>> getDocuments({String? category, String? search}) async {
    try {
      String endpoint = '/api/content/documents';
      if (category != null) endpoint += '?category=$category';
      if (search != null) endpoint += '${category != null ? '&' : '?'}search=${Uri.encodeComponent(search)}';
      
      final response = await _apiService.makeRequest('GET', endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final documents = data['data'] ?? [];
        return documents.map<TaxLienDocument>((doc) => TaxLienDocument.fromJson(doc)).toList();
      } else {
        throw Exception('Failed to get documents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading documents: $e');
    }
  }

  Future<TaxLienDocument?> getDocument(int id) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/content/documents/$id');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TaxLienDocument.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading document: $e');
    }
  }

  Future<bool> uploadDocument(File file, String title, {String? description, String? category, List<String>? tags}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${_configService.currentServer?.url}/api/content/documents/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (category != null) request.fields['category'] = category;
      if (tags != null) request.fields['tags'] = tags.join(',');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error uploading document: $e');
    }
  }

  Future<void> deleteDocument(int id) async {
    try {
      await _apiService.makeRequest('DELETE', '/api/content/documents/$id');
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }

  // Property Media Methods
  Future<List<PropertyMedia>> getPropertyMedia(String propertyId) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/content/property/$propertyId/media');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final media = data['data'] ?? [];
        return media.map<PropertyMedia>((item) => PropertyMedia.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get property media: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading property media: $e');
    }
  }

  Future<bool> uploadPropertyMedia(File file, String propertyId, String title, {String? description, String? type}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${_configService.currentServer?.url}/api/content/property/$propertyId/media/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (type != null) request.fields['type'] = type;

      final response = await request.send();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error uploading property media: $e');
    }
  }

  // Educational Content Methods
  Future<List<EducationalContent>> getEducationalContent({String? difficulty, String? type}) async {
    try {
      String endpoint = '/api/content/educational';
      if (difficulty != null) endpoint += '?difficulty=$difficulty';
      if (type != null) endpoint += '${difficulty != null ? '&' : '?'}type=$type';
      
      final response = await _apiService.makeRequest('GET', endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['data'] ?? [];
        return content.map<EducationalContent>((item) => EducationalContent.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get educational content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading educational content: $e');
    }
  }

  Future<EducationalContent?> getEducationalContentById(int id) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/content/educational/$id');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EducationalContent.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get educational content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading educational content: $e');
    }
  }

  // Market Intelligence Methods
  Future<List<MarketIntelligence>> getMarketIntelligence({String? type, String? region}) async {
    try {
      String endpoint = '/api/content/market-intelligence';
      if (type != null) endpoint += '?type=$type';
      if (region != null) endpoint += '${type != null ? '&' : '?'}region=${Uri.encodeComponent(region)}';
      
      final response = await _apiService.makeRequest('GET', endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final intelligence = data['data'] ?? [];
        return intelligence.map<MarketIntelligence>((item) => MarketIntelligence.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get market intelligence: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading market intelligence: $e');
    }
  }

  // Legal Resources Methods
  Future<List<LegalResource>> getLegalResources({String? jurisdiction, String? category}) async {
    try {
      String endpoint = '/api/content/legal-resources';
      if (jurisdiction != null) endpoint += '?jurisdiction=${Uri.encodeComponent(jurisdiction)}';
      if (category != null) endpoint += '${jurisdiction != null ? '&' : '?'}category=$category';
      
      final response = await _apiService.makeRequest('GET', endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resources = data['data'] ?? [];
        return resources.map<LegalResource>((item) => LegalResource.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get legal resources: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading legal resources: $e');
    }
  }

  // Search Methods
  Future<List<dynamic>> searchContent(String query, {List<String>? types}) async {
    try {
      String endpoint = '/api/content/search?q=${Uri.encodeComponent(query)}';
      if (types != null && types.isNotEmpty) {
        endpoint += '&types=${types.join(',')}';
      }
      
      final response = await _apiService.makeRequest('GET', endpoint);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to search content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching content: $e');
    }
  }

  // Statistics Methods
  Future<Map<String, dynamic>> getContentStats() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/content/stats');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get content stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading content stats: $e');
    }
  }
}
