import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'server_config_service.dart';

class MediaFile {
  final int id;
  final String name;
  final String type;
  final int? duration;
  final String? size;
  final String? resolution;
  final String? format;
  final String path;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MediaFile({
    required this.id,
    required this.name,
    required this.type,
    this.duration,
    this.size,
    this.resolution,
    this.format,
    required this.path,
    this.createdAt,
    this.updatedAt,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      duration: json['duration'] as int?,
      size: json['size'] as String?,
      resolution: json['resolution'] as String?,
      format: json['format'] as String?,
      path: json['path'] as String,
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
      'name': name,
      'type': type,
      'duration': duration,
      'size': size,
      'resolution': resolution,
      'format': format,
      'path': path,
      'created': createdAt?.toIso8601String(),
      'updated': updatedAt?.toIso8601String(),
    };
  }

  String get formattedDuration {
    if (duration == null) return 'N/A';
    final minutes = (duration! / 60).floor();
    final seconds = duration! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';
  bool get isAudio => type == 'audio';
}

class Playlist {
  final int id;
  final String name;
  final String? description;
  final List<int> items;
  final int? duration;
  final DateTime? created;
  final DateTime? updated;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.items,
    this.duration,
    this.created,
    this.updated,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      items: List<int>.from(json['items'] ?? []),
      duration: json['duration'] as int?,
      created: json['created'] != null 
          ? DateTime.parse(json['created'] as String) 
          : null,
      updated: json['updated'] != null 
          ? DateTime.parse(json['updated'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items,
      'duration': duration,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
    };
  }

  String get formattedDuration {
    if (duration == null) return 'N/A';
    final minutes = (duration! / 60).floor();
    final seconds = duration! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

class StreamingSource {
  final int id;
  final String name;
  final String url;
  final String type;
  final String status;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StreamingSource({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory StreamingSource.fromJson(Map<String, dynamic> json) {
    return StreamingSource(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
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
      'name': name,
      'url': url,
      'type': type,
      'status': status,
      'description': description,
      'created': createdAt?.toIso8601String(),
      'updated': updatedAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isLive => type == 'live';
  bool get isInteractive => type == 'interactive';
  bool get isData => type == 'data';
}

class MediaLibraryService {
  final ApiService _apiService;
  final ServerConfigService _configService;

  MediaLibraryService({
    required ApiService apiService,
    required ServerConfigService configService,
  }) : _apiService = apiService, _configService = configService;

  // Получение всех медиафайлов
  Future<List<MediaFile>> getMediaFiles() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['data'] ?? [];
        return files.map<MediaFile>((file) => MediaFile.fromJson(file)).toList();
      } else {
        throw Exception('Failed to get media files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading media files: $e');
    }
  }

  // Получение медиафайла по ID
  Future<MediaFile?> getMediaFile(int id) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media/$id');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MediaFile.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get media file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading media file: $e');
    }
  }

  // Воспроизведение медиафайла
  Future<void> playMediaFile(int fileId) async {
    try {
      await _apiService.makeRequest('POST', '/api/media/$fileId/play');
    } catch (e) {
      throw Exception('Error playing media file: $e');
    }
  }

  // Воспроизведение медиафайла по имени
  Future<void> playMediaFileByName(String fileName) async {
    try {
      await _apiService.makeRequest('POST', '/api/play', body: {'file': fileName});
    } catch (e) {
      throw Exception('Error playing media file: $e');
    }
  }

  // Загрузка медиафайла
  Future<bool> uploadMediaFile(File file, {String? customName}) async {
    try {
      final fileName = customName ?? file.path.split('/').last;
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${_configService.currentServer?.url}/api/media/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      if (customName != null) {
        request.fields['name'] = customName;
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Upload failed: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Error uploading media file: $e');
    }
  }

  // Удаление медиафайла
  Future<void> deleteMediaFile(int fileId) async {
    try {
      await _apiService.makeRequest('DELETE', '/api/media/$fileId');
    } catch (e) {
      throw Exception('Error deleting media file: $e');
    }
  }

  // Получение всех плейлистов
  Future<List<Playlist>> getPlaylists() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/playlists');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final playlists = data['data'] ?? [];
        return playlists.map<Playlist>((playlist) => Playlist.fromJson(playlist)).toList();
      } else {
        throw Exception('Failed to get playlists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading playlists: $e');
    }
  }

  // Получение плейлиста по ID
  Future<Playlist?> getPlaylist(int id) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/playlists/$id');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Playlist.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get playlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading playlist: $e');
    }
  }

  // Создание плейлиста
  Future<Playlist> createPlaylist(String name, {String? description, List<int>? items}) async {
    try {
      final response = await _apiService.makeRequest(
        'POST', 
        '/api/playlists',
        body: {
          'name': name,
          if (description != null) 'description': description,
          if (items != null) 'items': items,
        },
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Playlist.fromJson(data['data'] ?? data);
      } else {
        throw Exception('Failed to create playlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating playlist: $e');
    }
  }

  // Обновление плейлиста
  Future<Playlist> updatePlaylist(int id, {String? name, String? description, List<int>? items}) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (items != null) body['items'] = items;

      final response = await _apiService.makeRequest(
        'PUT', 
        '/api/playlists/$id',
        body: body,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Playlist.fromJson(data['data'] ?? data);
      } else {
        throw Exception('Failed to update playlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating playlist: $e');
    }
  }

  // Удаление плейлиста
  Future<void> deletePlaylist(int id) async {
    try {
      await _apiService.makeRequest('DELETE', '/api/playlists/$id');
    } catch (e) {
      throw Exception('Error deleting playlist: $e');
    }
  }

  // Воспроизведение плейлиста
  Future<void> playPlaylist(int playlistId) async {
    try {
      await _apiService.makeRequest('POST', '/api/playlists/$playlistId/play');
    } catch (e) {
      throw Exception('Error playing playlist: $e');
    }
  }

  // Получение элементов плейлиста
  Future<List<MediaFile>> getPlaylistItems(int playlistId) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/playlists/$playlistId/items');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] ?? [];
        return items.map<MediaFile>((item) => MediaFile.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get playlist items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading playlist items: $e');
    }
  }

  // Получение источников стриминга
  Future<List<StreamingSource>> getStreamingSources() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/streaming');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sources = data['sources'] ?? [];
        return sources.map<StreamingSource>((source) => StreamingSource.fromJson(source)).toList();
      } else {
        throw Exception('Failed to get streaming sources: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading streaming sources: $e');
    }
  }

  // Воспроизведение источника стриминга
  Future<void> playStreamingSource(int sourceId) async {
    try {
      await _apiService.makeRequest('POST', '/api/streaming/$sourceId/play');
    } catch (e) {
      throw Exception('Error playing streaming source: $e');
    }
  }

  // Получение информации о текущем медиа
  Future<Map<String, dynamic>?> getCurrentMediaInfo() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media/info');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Управление позицией воспроизведения
  Future<void> seekToPosition(int position) async {
    try {
      await _apiService.makeRequest('PUT', '/api/media/seek', body: {'position': position});
    } catch (e) {
      throw Exception('Error seeking to position: $e');
    }
  }

  // Поиск медиафайлов
  Future<List<MediaFile>> searchMediaFiles(String query) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media/search?q=${Uri.encodeComponent(query)}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['data'] ?? [];
        return files.map<MediaFile>((file) => MediaFile.fromJson(file)).toList();
      } else {
        throw Exception('Failed to search media files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching media files: $e');
    }
  }

  // Фильтрация медиафайлов по типу
  Future<List<MediaFile>> getMediaFilesByType(String type) async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media?type=$type');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['data'] ?? [];
        return files.map<MediaFile>((file) => MediaFile.fromJson(file)).toList();
      } else {
        throw Exception('Failed to get media files by type: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading media files by type: $e');
    }
  }

  // Получение статистики медиа библиотеки
  Future<Map<String, dynamic>> getMediaLibraryStats() async {
    try {
      final response = await _apiService.makeRequest('GET', '/api/media/stats');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get media library stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading media library stats: $e');
    }
  }
} 