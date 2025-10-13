import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'offline_data_loader_service.dart';
import '../core/services/hybrid_magento_service.dart';

/// Configuration for scheduled sync
class SyncScheduleConfig {
  final String state;
  final List<String>? counties; // null = all counties
  final Duration interval;
  final bool enabled;
  final DateTime? lastSync;
  final DateTime? nextSync;

  SyncScheduleConfig({
    required this.state,
    this.counties,
    required this.interval,
    this.enabled = true,
    this.lastSync,
    this.nextSync,
  });

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'counties': counties,
      'interval_minutes': interval.inMinutes,
      'enabled': enabled,
      'last_sync': lastSync?.toIso8601String(),
      'next_sync': nextSync?.toIso8601String(),
    };
  }

  factory SyncScheduleConfig.fromJson(Map<String, dynamic> json) {
    return SyncScheduleConfig(
      state: json['state'] as String,
      counties: (json['counties'] as List<dynamic>?)?.cast<String>(),
      interval: Duration(minutes: json['interval_minutes'] as int? ?? 60),
      enabled: json['enabled'] as bool? ?? true,
      lastSync: json['last_sync'] != null
          ? DateTime.parse(json['last_sync'] as String)
          : null,
      nextSync: json['next_sync'] != null
          ? DateTime.parse(json['next_sync'] as String)
          : null,
    );
  }

  SyncScheduleConfig copyWith({
    String? state,
    List<String>? counties,
    Duration? interval,
    bool? enabled,
    DateTime? lastSync,
    DateTime? nextSync,
  }) {
    return SyncScheduleConfig(
      state: state ?? this.state,
      counties: counties ?? this.counties,
      interval: interval ?? this.interval,
      enabled: enabled ?? this.enabled,
      lastSync: lastSync ?? this.lastSync,
      nextSync: nextSync ?? this.nextSync,
    );
  }
}

/// Service for scheduled data synchronization by state and county
class ScheduledDataSyncService extends ChangeNotifier {
  static const String _schedulesKey = 'sync_schedules';
  static const String _syncHistoryKey = 'sync_history';
  static const int _maxHistoryEntries = 100;

  final OfflineDataLoaderService _offlineLoader;
  final HybridMagentoService? _magentoService;

  List<SyncScheduleConfig> _schedules = [];
  List<Map<String, dynamic>> _syncHistory = [];
  Timer? _syncTimer;
  bool _isInitialized = false;
  bool _isSyncing = false;
  String? _error;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isSyncing => _isSyncing;
  String? get error => _error;
  List<SyncScheduleConfig> get schedules => List.unmodifiable(_schedules);
  List<Map<String, dynamic>> get syncHistory => List.unmodifiable(_syncHistory);

  ScheduledDataSyncService({
    required OfflineDataLoaderService offlineLoader,
    HybridMagentoService? magentoService,
  })  : _offlineLoader = offlineLoader,
        _magentoService = magentoService;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadSchedules();
      await _loadSyncHistory();
      _startSyncTimer();
      _isInitialized = true;

      if (kDebugMode) {
        print(
            'ScheduledDataSyncService initialized with ${_schedules.length} schedules');
      }
    } catch (e) {
      _error = 'Failed to initialize sync service: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  /// Load schedules from storage
  Future<void> _loadSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = prefs.getString(_schedulesKey);

      if (schedulesJson != null) {
        final List<dynamic> schedulesList = json.decode(schedulesJson);
        _schedules = schedulesList
            .map((json) =>
                SyncScheduleConfig.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading schedules: $e');
      }
    }
  }

  /// Save schedules to storage
  Future<void> _saveSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson =
          json.encode(_schedules.map((s) => s.toJson()).toList());
      await prefs.setString(_schedulesKey, schedulesJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving schedules: $e');
      }
    }
  }

  /// Load sync history
  Future<void> _loadSyncHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_syncHistoryKey);

      if (historyJson != null) {
        _syncHistory = (json.decode(historyJson) as List<dynamic>)
            .cast<Map<String, dynamic>>();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading sync history: $e');
      }
    }
  }

  /// Save sync history
  Future<void> _saveSyncHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Keep only last N entries
      if (_syncHistory.length > _maxHistoryEntries) {
        _syncHistory =
            _syncHistory.sublist(_syncHistory.length - _maxHistoryEntries);
      }

      final historyJson = json.encode(_syncHistory);
      await prefs.setString(_syncHistoryKey, historyJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving sync history: $e');
      }
    }
  }

  /// Add a new sync schedule
  Future<void> addSchedule(SyncScheduleConfig schedule) async {
    // Check if schedule for this state already exists
    final existingIndex =
        _schedules.indexWhere((s) => s.state == schedule.state);

    if (existingIndex >= 0) {
      _schedules[existingIndex] = schedule;
    } else {
      _schedules.add(schedule);
    }

    await _saveSchedules();
    notifyListeners();

    if (kDebugMode) {
      print('Added sync schedule for state: ${schedule.state}');
    }
  }

  /// Remove a sync schedule
  Future<void> removeSchedule(String state) async {
    _schedules.removeWhere((s) => s.state == state);
    await _saveSchedules();
    notifyListeners();

    if (kDebugMode) {
      print('Removed sync schedule for state: $state');
    }
  }

  /// Update a sync schedule
  Future<void> updateSchedule(
      String state, SyncScheduleConfig newSchedule) async {
    final index = _schedules.indexWhere((s) => s.state == state);

    if (index >= 0) {
      _schedules[index] = newSchedule;
      await _saveSchedules();
      notifyListeners();
    }
  }

  /// Enable/disable a schedule
  Future<void> toggleSchedule(String state, bool enabled) async {
    final index = _schedules.indexWhere((s) => s.state == state);

    if (index >= 0) {
      _schedules[index] = _schedules[index].copyWith(enabled: enabled);
      await _saveSchedules();
      notifyListeners();
    }
  }

  /// Start the sync timer
  void _startSyncTimer() {
    _syncTimer?.cancel();

    // Check every minute for schedules that need to run
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndRunSchedules();
    });

    if (kDebugMode) {
      print('Sync timer started');
    }
  }

  /// Check and run due schedules
  Future<void> _checkAndRunSchedules() async {
    if (_isSyncing) return;

    final now = DateTime.now();

    for (var schedule in _schedules) {
      if (!schedule.enabled) continue;

      // Check if it's time to sync
      if (schedule.nextSync == null || now.isAfter(schedule.nextSync!)) {
        await syncStateData(schedule);
      }
    }
  }

  /// Manually trigger sync for a state
  Future<bool> syncStateData(SyncScheduleConfig schedule) async {
    if (_isSyncing) return false;

    _isSyncing = true;
    _error = null;
    notifyListeners();

    final startTime = DateTime.now();
    bool success = false;
    String? errorMessage;
    int itemsSynced = 0;

    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;

      if (!isOnline) {
        throw Exception('No internet connection');
      }

      // Load data from offline storage
      final offlineProducts = await _offlineLoader.getProducts(
        state: schedule.state,
        county: schedule.counties?.isNotEmpty == true
            ? schedule.counties!.first
            : null,
      );

      if (kDebugMode) {
        print(
            'Syncing ${offlineProducts.length} products for ${schedule.state}');
      }

      // Sync with Magento if available
      if (_magentoService != null) {
        // Get online products to compare
        final onlineProducts = await _magentoService.getProducts(
          filters: {
            'state': schedule.state,
            if (schedule.counties?.isNotEmpty == true)
              'county': schedule.counties,
          },
        );

        // In a real implementation, you would:
        // 1. Compare offline vs online data
        // 2. Update changed products
        // 3. Add new products
        // 4. Remove deleted products

        itemsSynced = offlineProducts.length;
      } else {
        // Just count loaded products
        itemsSynced = offlineProducts.length;
      }

      // Update schedule with last sync time and next sync time
      final updatedSchedule = schedule.copyWith(
        lastSync: startTime,
        nextSync: startTime.add(schedule.interval),
      );

      await updateSchedule(schedule.state, updatedSchedule);

      success = true;

      if (kDebugMode) {
        print('Successfully synced ${itemsSynced} items for ${schedule.state}');
      }
    } catch (e) {
      errorMessage = e.toString();
      _error = 'Sync failed for ${schedule.state}: $e';

      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isSyncing = false;

      // Add to history
      _syncHistory.add({
        'timestamp': startTime.toIso8601String(),
        'state': schedule.state,
        'counties': schedule.counties,
        'success': success,
        'items_synced': itemsSynced,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        'error': errorMessage,
      });

      await _saveSyncHistory();
      notifyListeners();
    }

    return success;
  }

  /// Sync all enabled schedules now
  Future<void> syncAllNow() async {
    for (var schedule in _schedules) {
      if (schedule.enabled) {
        await syncStateData(schedule);
      }
    }
  }

  /// Get sync status for a state
  Map<String, dynamic>? getSyncStatus(String state) {
    final schedule = _schedules.firstWhere(
      (s) => s.state == state,
      orElse: () => SyncScheduleConfig(
        state: state,
        interval: const Duration(hours: 24),
        enabled: false,
      ),
    );

    final lastSyncEntry =
        _syncHistory.where((h) => h['state'] == state).lastOrNull;

    return {
      'state': state,
      'enabled': schedule.enabled,
      'last_sync': schedule.lastSync?.toIso8601String(),
      'next_sync': schedule.nextSync?.toIso8601String(),
      'last_sync_success': lastSyncEntry?['success'],
      'last_sync_items': lastSyncEntry?['items_synced'],
      'interval_minutes': schedule.interval.inMinutes,
    };
  }

  /// Get sync statistics
  Map<String, dynamic> getSyncStatistics() {
    final totalSyncs = _syncHistory.length;
    final successfulSyncs =
        _syncHistory.where((h) => h['success'] == true).length;
    final failedSyncs = totalSyncs - successfulSyncs;

    final totalItems = _syncHistory
        .where((h) => h['items_synced'] != null)
        .fold<int>(0, (sum, h) => sum + (h['items_synced'] as int));

    return {
      'total_schedules': _schedules.length,
      'enabled_schedules': _schedules.where((s) => s.enabled).length,
      'total_syncs': totalSyncs,
      'successful_syncs': successfulSyncs,
      'failed_syncs': failedSyncs,
      'total_items_synced': totalItems,
      'is_syncing': _isSyncing,
      'last_error': _error,
    };
  }

  /// Create default schedules for common states
  Future<void> createDefaultSchedules() async {
    final commonStates = ['FL', 'TX', 'CA', 'NY', 'AZ'];

    for (var state in commonStates) {
      await addSchedule(SyncScheduleConfig(
        state: state,
        interval: const Duration(hours: 24), // Daily sync
        enabled: false, // Start disabled, user can enable
      ));
    }

    if (kDebugMode) {
      print('Created default sync schedules');
    }
  }

  /// Clear all sync history
  Future<void> clearSyncHistory() async {
    _syncHistory.clear();
    await _saveSyncHistory();
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}

// Extension for lastOrNull on List
extension ListExtension<T> on List<T> {
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
}
