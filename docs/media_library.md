# Media Library для FreeDome Manager

## Обзор

Media Library - это комплексная система управления медиафайлами, плейлистами и источниками стриминга для FreeDome Manager, совместимая с API freedome_server.

## Возможности

### Медиафайлы
- **Просмотр**: Отображение всех доступных медиафайлов с информацией о типе, длительности, размере
- **Поиск**: Поиск медиафайлов по названию
- **Фильтрация**: Фильтрация по типу (видео, изображения, аудио)
- **Воспроизведение**: Прямое воспроизведение медиафайлов
- **Загрузка**: Загрузка новых медиафайлов через интерфейс
- **Удаление**: Удаление медиафайлов с подтверждением
- **Детали**: Просмотр подробной информации о медиафайле

### Плейлисты
- **Создание**: Создание новых плейлистов с названием и описанием
- **Редактирование**: Изменение существующих плейлистов
- **Управление**: Добавление/удаление медиафайлов из плейлиста
- **Сортировка**: Перетаскивание для изменения порядка воспроизведения
- **Воспроизведение**: Воспроизведение плейлистов целиком
- **Удаление**: Удаление плейлистов с подтверждением

### Стриминг
- **Источники**: Управление источниками стриминга (live, interactive, data)
- **Статус**: Отображение статуса источников (active/inactive)
- **Воспроизведение**: Воспроизведение активных источников стриминга
- **Добавление**: Добавление новых источников стриминга
- **Удаление**: Удаление источников стриминга

## Архитектура

### Сервисы

#### MediaLibraryService
Основной сервис для работы с медиа библиотекой:

```dart
class MediaLibraryService {
  // Медиафайлы
  Future<List<MediaFile>> getMediaFiles()
  Future<MediaFile?> getMediaFile(int id)
  Future<void> playMediaFile(int fileId)
  Future<void> playMediaFileByName(String fileName)
  Future<bool> uploadMediaFile(File file, {String? customName})
  Future<void> deleteMediaFile(int fileId)
  
  // Плейлисты
  Future<List<Playlist>> getPlaylists()
  Future<Playlist?> getPlaylist(int id)
  Future<Playlist> createPlaylist(String name, {String? description, List<int>? items})
  Future<Playlist> updatePlaylist(int id, {String? name, String? description, List<int>? items})
  Future<void> deletePlaylist(int id)
  Future<void> playPlaylist(int playlistId)
  Future<List<MediaFile>> getPlaylistItems(int playlistId)
  
  // Стриминг
  Future<List<StreamingSource>> getStreamingSources()
  Future<void> playStreamingSource(int sourceId)
  
  // Дополнительные функции
  Future<Map<String, dynamic>?> getCurrentMediaInfo()
  Future<void> seekToPosition(int position)
  Future<List<MediaFile>> searchMediaFiles(String query)
  Future<List<MediaFile>> getMediaFilesByType(String type)
  Future<Map<String, dynamic>> getMediaLibraryStats()
}
```

### Модели данных

#### MediaFile
```dart
class MediaFile {
  final int id;
  final String name;
  final String type; // 'video', 'image', 'audio'
  final int? duration;
  final String? size;
  final String? resolution;
  final String? format;
  final String path;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Геттеры
  String get formattedDuration;
  bool get isVideo;
  bool get isImage;
  bool get isAudio;
}
```

#### Playlist
```dart
class Playlist {
  final int id;
  final String name;
  final String? description;
  final List<int> items; // ID медиафайлов
  final int? duration;
  final DateTime? created;
  final DateTime? updated;
  
  // Геттеры
  String get formattedDuration;
}
```

#### StreamingSource
```dart
class StreamingSource {
  final int id;
  final String name;
  final String url;
  final String type; // 'live', 'interactive', 'data'
  final String status; // 'active', 'inactive'
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Геттеры
  bool get isActive;
  bool get isLive;
  bool get isInteractive;
  bool get isData;
}
```

### Экраны

#### MediaLibraryScreen
Основной экран медиа библиотеки с табами:
- **Media Files**: Управление медиафайлами
- **Playlists**: Управление плейлистами  
- **Streaming**: Управление источниками стриминга

#### PlaylistEditorScreen
Экран для создания и редактирования плейлистов:
- Форма для названия и описания
- Список выбранных медиафайлов с возможностью перетаскивания
- Список доступных медиафайлов для добавления

#### StreamingManagementScreen
Экран для управления источниками стриминга:
- Список источников стриминга
- Диалог добавления нового источника
- Управление статусом и типом источников

## API Совместимость

### freedome_server Endpoints

#### Медиафайлы
- `GET /api/media` - Получение списка медиафайлов
- `GET /api/media/{id}` - Получение медиафайла по ID
- `POST /api/media/{id}/play` - Воспроизведение медиафайла
- `POST /api/play` - Воспроизведение по имени файла
- `POST /api/media/upload` - Загрузка медиафайла
- `DELETE /api/media/{id}` - Удаление медиафайла
- `GET /api/media/search` - Поиск медиафайлов
- `GET /api/media/stats` - Статистика медиа библиотеки

#### Плейлисты
- `GET /api/playlists` - Получение списка плейлистов
- `GET /api/playlists/{id}` - Получение плейлиста по ID
- `POST /api/playlists` - Создание плейлиста
- `PUT /api/playlists/{id}` - Обновление плейлиста
- `DELETE /api/playlists/{id}` - Удаление плейлиста
- `POST /api/playlists/{id}/play` - Воспроизведение плейлиста
- `GET /api/playlists/{id}/items` - Получение элементов плейлиста

#### Стриминг
- `GET /api/streaming` - Получение источников стриминга
- `POST /api/streaming/{id}/play` - Воспроизведение источника стриминга

## Использование

### Инициализация
```dart
// В ServerConnectionService
late MediaLibraryService _mediaLibraryService;

Future<void> initialize() async {
  await _configService.initialize();
  
  _mediaLibraryService = MediaLibraryService(
    apiService: _apiService,
    configService: _configService,
  );
  
  // ... остальная инициализация
}
```

### Получение медиафайлов
```dart
final mediaFiles = await mediaLibraryService.getMediaFiles();
```

### Воспроизведение медиафайла
```dart
await mediaLibraryService.playMediaFile(fileId);
```

### Создание плейлиста
```dart
final playlist = await mediaLibraryService.createPlaylist(
  'My Playlist',
  description: 'Description',
  items: [1, 2, 3], // ID медиафайлов
);
```

### Загрузка медиафайла
```dart
final file = File('/path/to/file.mp4');
final success = await mediaLibraryService.uploadMediaFile(file);
```

## Зависимости

### pubspec.yaml
```yaml
dependencies:
  file_picker: ^6.1.1
  http: ^1.1.0
```

## Обработка ошибок

Все методы сервиса включают обработку ошибок:
- Сетевые ошибки
- Ошибки API (4xx, 5xx)
- Ошибки валидации
- Ошибки файловой системы

## Локализация

Поддержка многоязычности через `AppLocalizations`:
- Названия экранов
- Сообщения об ошибках
- Подсказки и описания

## Безопасность

- Валидация входных данных
- Проверка типов файлов при загрузке
- Подтверждение удаления
- Обработка ошибок сети

## Производительность

- Ленивая загрузка данных
- Кэширование результатов
- Оптимизированные запросы к API
- Обработка больших файлов

## Тестирование

### Unit тесты
- Тестирование моделей данных
- Тестирование сервисов
- Тестирование валидации

### Integration тесты
- Тестирование API интеграции
- Тестирование UI взаимодействий

### Widget тесты
- Тестирование экранов
- Тестирование диалогов

## Будущие улучшения

- Поддержка drag & drop для загрузки файлов
- Предварительный просмотр медиафайлов
- Автоматическое создание плейлистов
- Синхронизация с облачными хранилищами
- Поддержка субтитров
- Аналитика воспроизведения 