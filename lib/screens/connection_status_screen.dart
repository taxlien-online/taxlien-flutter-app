import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/server_connection_service.dart';

class ConnectionStatusScreen extends StatefulWidget {
  final ServerConnectionService serverService;
  
  const ConnectionStatusScreen({
    super.key,
    required this.serverService,
  });

  @override
  State<ConnectionStatusScreen> createState() => _ConnectionStatusScreenState();
}

class _ConnectionStatusScreenState extends State<ConnectionStatusScreen> {
  List<String> _logs = [];
  Map<String, dynamic>? _systemStatus;
  bool _isLoading = false;
  StreamSubscription? _logSubscription;

  @override
  void initState() {
    super.initState();
    _setupLogSubscription();
    _loadSystemStatus();
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    super.dispose();
  }

  void _setupLogSubscription() {
    _logSubscription = widget.serverService.logStream.listen((log) {
      setState(() {
        _logs.add('${DateTime.now().toString().substring(11, 19)}: $log');
        // Ограничиваем количество логов
        if (_logs.length > 100) {
          _logs.removeAt(0);
        }
      });
    });
  }

  Future<void> _loadSystemStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await widget.serverService.getSystemStatus();
      setState(() {
        _systemStatus = status;
      });
    } catch (e) {
      _showSnackBar('Failed to load system status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _reconnect() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.serverService.reconnect();
      if (success) {
        _showSnackBar('Reconnected successfully');
        await _loadSystemStatus();
      } else {
        _showSnackBar('Reconnection failed');
      }
    } catch (e) {
      _showSnackBar('Reconnection error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _autoConnect() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final server = await widget.serverService.autoConnect();
      if (server != null) {
        _showSnackBar('Auto-connected to ${server.url}');
        await _loadSystemStatus();
      } else {
        _showSnackBar('No servers found');
      }
    } catch (e) {
      _showSnackBar('Auto-connect error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.connectionStatus ?? 'Connection Status'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadSystemStatus,
            icon: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Статус подключения
            _buildConnectionStatusCard(),
            const SizedBox(height: 16),
            
            // Действия
            _buildActionButtons(),
            const SizedBox(height: 16),
            
            // Статус системы
            if (_systemStatus != null) ...[
              _buildSystemStatusCard(),
              const SizedBox(height: 16),
            ],
            
            // Логи
            _buildLogsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    final isConnected = widget.serverService.isConnected;
    final currentServer = widget.serverService.currentServer;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: isConnected ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isConnected ? 'Connected' : 'Disconnected',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (currentServer != null)
                        Text(
                          currentServer.url,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (currentServer != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Server: ${currentServer.name ?? '${currentServer.host}:${currentServer.port}'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    'Last used: ${_formatDateTime(currentServer.lastUsed)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _reconnect,
            icon: const Icon(Icons.refresh),
            label: const Text('Reconnect'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _autoConnect,
            icon: const Icon(Icons.search),
            label: const Text('Auto Connect'),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStatusCard() {
    if (_systemStatus == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Running', _systemStatus!['isRunning'] ?? false),
            _buildStatusRow('Brightness', '${_systemStatus!['brightness'] ?? 0}%'),
            _buildStatusRow('Volume', '${_systemStatus!['volume'] ?? 0}%'),
            _buildStatusRow('Rotation', '${_systemStatus!['rotation'] ?? 0}°'),
            if (_systemStatus!['media'] != null) ...[
              _buildStatusRow('Playing', _systemStatus!['media']['isPlaying'] ?? false),
              _buildStatusRow('Current File', _systemStatus!['media']['currentFile'] ?? 'None'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (value is bool)
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: value ? Colors.green : Colors.red,
              size: 20,
            )
          else
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Connection Logs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _logs.clear();
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      log,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
} 