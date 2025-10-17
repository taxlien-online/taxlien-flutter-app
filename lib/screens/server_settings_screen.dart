import 'package:flutter/material.dart';
import '../services/server_connection_service.dart';

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
  late TextEditingController _serverUrlController;
  late TextEditingController _portController;
  bool _autoConnect = true;

  @override
  void initState() {
    super.initState();
    _serverUrlController = TextEditingController(text: widget.serverService.serverUrl);
    _portController = TextEditingController(text: widget.serverService.port.toString());
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final url = _serverUrlController.text.trim();
    final port = int.tryParse(_portController.text) ?? 3000;

    await widget.serverService.updateServerSettings(url, port);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _testConnection() async {
    final connected = await widget.serverService.connect();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(connected ? 'Connection successful!' : 'Connection failed'),
          backgroundColor: connected ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection status card
            Card(
              child: ListTile(
                leading: Icon(
                  widget.serverService.isConnected
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: widget.serverService.isConnected
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(
                  widget.serverService.isConnected
                      ? 'Connected'
                      : 'Disconnected',
                ),
                subtitle: Text(
                  '${widget.serverService.serverUrl}:${widget.serverService.port}',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Server URL
            TextField(
              controller: _serverUrlController,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://localhost',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.dns),
              ),
            ),

            const SizedBox(height: 16),

            // Port
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '3000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // Auto-connect
            SwitchListTile(
              title: const Text('Auto-connect on startup'),
              subtitle: const Text('Automatically connect to server when app starts'),
              value: _autoConnect,
              onChanged: (value) {
                setState(() {
                  _autoConnect = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Test connection button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _testConnection,
                icon: const Icon(Icons.wifi),
                label: const Text('Test Connection'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

