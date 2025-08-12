import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/server_connection_service.dart';
import '../services/server_config_service.dart';

class ServerSettingsScreen extends StatefulWidget {
  final ServerConnectionService serverService;
  
  const ServerSettingsScreen({
    super.key,
    required this.serverService,
  });

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isDiscovering = false;
  bool _isConnecting = false;
  List<ServerConfig> _discoveredServers = [];
  List<ServerConfig> _savedServers = [];
  
  @override
  void initState() {
    super.initState();
    _loadSavedServers();
    _setupCurrentServer();
  }
  
  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  
  void _loadSavedServers() {
    setState(() {
      _savedServers = widget.serverService.configService.savedServers;
    });
  }
  
  void _setupCurrentServer() {
    final currentServer = widget.serverService.currentServer;
    if (currentServer != null) {
      _hostController.text = currentServer.host;
      _portController.text = currentServer.port.toString();
      _nameController.text = currentServer.name ?? '';
    } else {
      _hostController.text = 'localhost';
      _portController.text = '3000';
    }
  }
  
  Future<void> _discoverServers() async {
    setState(() {
      _isDiscovering = true;
      _discoveredServers.clear();
    });
    
    try {
      final servers = await widget.serverService.configService.discoverServers();
      setState(() {
        _discoveredServers = servers;
      });
      
      if (servers.isEmpty) {
        _showSnackBar('No servers found');
      } else {
        _showSnackBar('Found ${servers.length} server(s)');
      }
    } catch (e) {
      _showSnackBar('Discovery failed: $e');
    } finally {
      setState(() {
        _isDiscovering = false;
      });
    }
  }
  
  Future<void> _connectToServer(ServerConfig server) async {
    setState(() {
      _isConnecting = true;
    });
    
    try {
      final success = await widget.serverService.connectToServer(server);
      
      if (success) {
        _showSnackBar('Connected to ${server.url}');
        _loadSavedServers();
        Navigator.of(context).pop();
      } else {
        _showSnackBar('Failed to connect to ${server.url}');
      }
    } catch (e) {
      _showSnackBar('Connection error: $e');
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }
  
  Future<void> _saveAndConnect() async {
    if (!_formKey.currentState!.validate()) return;
    
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 3000;
    final name = _nameController.text.trim();
    
    final server = ServerConfig(
      host: host,
      port: port,
      name: name.isNotEmpty ? name : '$host:$port',
      lastUsed: DateTime.now(),
    );
    
    await _connectToServer(server);
  }
  
  Future<void> _removeServer(ServerConfig server) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Server'),
        content: Text('Are you sure you want to remove ${server.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await widget.serverService.configService.removeServer(server);
      _loadSavedServers();
      _showSnackBar('Server removed');
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
        title: Text(l10n.serverSettings ?? 'Server Settings'),
        actions: [
          if (widget.serverService.isConnected)
            IconButton(
              icon: const Icon(Icons.wifi),
              onPressed: () => _showSnackBar('Connected to ${widget.serverService.currentServer?.url}'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Текущее подключение
            if (widget.serverService.currentServer != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.serverService.isConnected 
                                ? Icons.wifi 
                                : Icons.wifi_off,
                            color: widget.serverService.isConnected 
                                ? Colors.green 
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Current Server',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.serverService.currentServer!.name ?? 
                        '${widget.serverService.currentServer!.host}:${widget.serverService.currentServer!.port}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.serverService.currentServer!.url,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await widget.serverService.disconnect();
                              _loadSavedServers();
                              setState(() {});
                            },
                            child: const Text('Disconnect'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Форма для нового сервера
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Server',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _hostController,
                        decoration: const InputDecoration(
                          labelText: 'Host',
                          hintText: 'localhost',
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Host is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: '3000',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final port = int.tryParse(value ?? '');
                          if (port == null || port < 1 || port > 65535) {
                            return 'Port must be between 1 and 65535';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name (optional)',
                          hintText: 'My Server',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isConnecting ? null : _saveAndConnect,
                              child: _isConnecting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Connect'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _isDiscovering ? null : _discoverServers,
                            icon: _isDiscovering
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.search),
                            label: Text(_isDiscovering ? 'Searching...' : 'Discover'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Найденные серверы
            if (_discoveredServers.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discovered Servers',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ...(_discoveredServers.map((server) => ListTile(
                        leading: const Icon(Icons.wifi_find),
                        title: Text(server.name ?? '${server.host}:${server.port}'),
                        subtitle: Text(server.url),
                        trailing: ElevatedButton(
                          onPressed: () => _connectToServer(server),
                          child: const Text('Connect'),
                        ),
                      ))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Сохраненные серверы
            if (_savedServers.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Servers',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ...(_savedServers.map((server) => ListTile(
                        leading: Icon(
                          server.host == widget.serverService.currentServer?.host &&
                          server.port == widget.serverService.currentServer?.port
                              ? Icons.wifi
                              : Icons.wifi_off,
                          color: server.host == widget.serverService.currentServer?.host &&
                                  server.port == widget.serverService.currentServer?.port
                              ? Colors.green
                              : Colors.grey,
                        ),
                        title: Text(server.name ?? '${server.host}:${server.port}'),
                        subtitle: Text(server.url),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => _connectToServer(server),
                              child: const Text('Connect'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _removeServer(server),
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ))),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 