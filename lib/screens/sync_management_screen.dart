import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/preload_service.dart';
import '../services/scheduled_data_sync_service.dart';

/// Screen for managing scheduled data synchronization
class SyncManagementScreen extends StatefulWidget {
  const SyncManagementScreen({super.key});

  @override
  State<SyncManagementScreen> createState() => _SyncManagementScreenState();
}

class _SyncManagementScreenState extends State<SyncManagementScreen> {
  bool _isLoading = false;
  List<String> _availableStates = [];
  List<SyncScheduleConfig> _schedules = [];
  Map<String, dynamic> _syncStats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load available states
      _availableStates = await PreloadService.getAvailableStates();

      // Load schedules
      _schedules = PreloadService.getSyncSchedules();

      // Load sync statistics
      _syncStats = PreloadService.getSyncStatistics();

      if (kDebugMode) {
        print('Loaded ${_availableStates.length} states');
        print('Loaded ${_schedules.length} schedules');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading sync data: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading sync data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addSchedule() async {
    if (_availableStates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No states available')),
      );
      return;
    }

    String? selectedState;
    Duration selectedInterval = const Duration(hours: 24);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Sync Schedule'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedState,
                      items: _availableStates
                          .map((state) => DropdownMenuItem(
                                value: state,
                                child: Text(state),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedState = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Sync Interval',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedInterval.inHours,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Hourly')),
                        DropdownMenuItem(
                            value: 6, child: Text('Every 6 hours')),
                        DropdownMenuItem(
                            value: 12, child: Text('Every 12 hours')),
                        DropdownMenuItem(value: 24, child: Text('Daily')),
                        DropdownMenuItem(value: 168, child: Text('Weekly')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedInterval = Duration(hours: value!);
                        });
                      },
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
                  onPressed: selectedState != null
                      ? () {
                          Navigator.pop(context, {
                            'state': selectedState,
                            'interval': selectedInterval,
                          });
                        }
                      : null,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      try {
        await PreloadService.addSyncSchedule(
          state: result['state'] as String,
          interval: result['interval'] as Duration,
          enabled: true,
        );

        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Schedule added for ${result['state']}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding schedule: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleSchedule(SyncScheduleConfig schedule) async {
    try {
      await PreloadService.toggleSyncSchedule(
          schedule.state, !schedule.enabled);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Schedule ${!schedule.enabled ? "enabled" : "disabled"} for ${schedule.state}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling schedule: $e')),
        );
      }
    }
  }

  Future<void> _removeSchedule(String state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Schedule'),
        content: Text('Remove sync schedule for $state?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await PreloadService.removeSyncSchedule(state);
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Schedule removed for $state'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error removing schedule: $e')),
          );
        }
      }
    }
  }

  Future<void> _syncNow(String state) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await PreloadService.syncStateNow(state);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Sync completed for $state' : 'Sync failed for $state',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }

      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error syncing: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _syncAll() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PreloadService.syncAllStates();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All schedules synced'),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error syncing all: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Management'),
        actions: [
          if (_schedules.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _isLoading ? null : _syncAll,
              tooltip: 'Sync All',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistics Card
                    _buildStatisticsCard(),
                    const SizedBox(height: 16),

                    // Schedules List
                    Text(
                      'Sync Schedules',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),

                    if (_schedules.isEmpty)
                      _buildEmptyState()
                    else
                      ..._schedules
                          .map((schedule) => _buildScheduleCard(schedule)),

                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _addSchedule,
        icon: const Icon(Icons.add),
        label: const Text('Add Schedule'),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Schedules',
                  '${_syncStats['total_schedules'] ?? 0}',
                  Icons.calendar_today,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Active',
                  '${_syncStats['enabled_schedules'] ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Syncs Done',
                  '${_syncStats['successful_syncs'] ?? 0}',
                  Icons.sync_alt,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.sync_disabled,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Sync Schedules',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Add a schedule to automatically sync data for specific states',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(SyncScheduleConfig schedule) {
    final status = PreloadService.getSyncStatus(schedule.state);
    final lastSync = status?['last_sync'] != null
        ? DateTime.parse(status!['last_sync'] as String)
        : null;
    final nextSync = status?['next_sync'] != null
        ? DateTime.parse(status!['next_sync'] as String)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          schedule.enabled ? Icons.sync : Icons.sync_disabled,
          color: schedule.enabled ? Colors.green : Colors.grey,
        ),
        title: Text(
          schedule.state,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Interval: ${_formatDuration(schedule.interval)} • ${schedule.enabled ? "Active" : "Disabled"}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lastSync != null)
                  _buildInfoRow(
                    'Last Sync',
                    _formatDateTime(lastSync),
                    Icons.history,
                  ),
                if (nextSync != null)
                  _buildInfoRow(
                    'Next Sync',
                    _formatDateTime(nextSync),
                    Icons.schedule,
                  ),
                if (schedule.counties != null && schedule.counties!.isNotEmpty)
                  _buildInfoRow(
                    'Counties',
                    schedule.counties!.join(', '),
                    Icons.location_on,
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _toggleSchedule(schedule),
                      icon: Icon(
                        schedule.enabled ? Icons.pause : Icons.play_arrow,
                      ),
                      label: Text(schedule.enabled ? 'Disable' : 'Enable'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _syncNow(schedule.state),
                      icon: const Icon(Icons.sync),
                      label: const Text('Sync Now'),
                    ),
                    IconButton(
                      onPressed: () => _removeSchedule(schedule.state),
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      tooltip: 'Remove',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours < 1) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours';
    } else if (duration.inDays < 7) {
      return '${duration.inDays} days';
    } else {
      return '${(duration.inDays / 7).round()} weeks';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = dateTime.difference(now);

    if (diff.abs().inMinutes < 1) {
      return 'Just now';
    } else if (diff.abs().inHours < 1) {
      return '${diff.abs().inMinutes} minutes ${diff.isNegative ? "ago" : "from now"}';
    } else if (diff.abs().inDays < 1) {
      return '${diff.abs().inHours} hours ${diff.isNegative ? "ago" : "from now"}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
