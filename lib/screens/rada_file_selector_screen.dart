import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/offline_data_loader_service.dart';

/// Screen for selecting which .rada files to load
class RadaFileSelectorScreen extends StatefulWidget {
  const RadaFileSelectorScreen({super.key});

  @override
  State<RadaFileSelectorScreen> createState() => _RadaFileSelectorScreenState();
}

class _RadaFileSelectorScreenState extends State<RadaFileSelectorScreen> {
  final Map<String, RadaFileInfo> _availableFiles = {
    'ALL': RadaFileInfo(
      key: 'ALL',
      name: 'Все штаты',
      description: 'Полный набор данных по всем штатам США',
      file: 'assets/taxlien_data.rada',
      estimatedRecords: 250000,
      size: '45 MB',
      states: ['ALL'],
      icon: Icons.public,
      color: Colors.blue,
    ),
    'FL': RadaFileInfo(
      key: 'FL',
      name: 'Florida',
      description: 'Налоговые закладные штата Флорида',
      file: 'assets/taxlien_florida.rada',
      estimatedRecords: 15000,
      size: '3.2 MB',
      states: ['FL'],
      icon: Icons.beach_access,
      color: Colors.orange,
    ),
    'AZ': RadaFileInfo(
      key: 'AZ',
      name: 'Arizona',
      description: 'Налоговые закладные штата Аризона',
      file: 'assets/taxlien_arizona.rada',
      estimatedRecords: 8500,
      size: '1.8 MB',
      states: ['AZ'],
      icon: Icons.landscape,
      color: Colors.deepOrange,
    ),
    'DEMO': RadaFileInfo(
      key: 'DEMO',
      name: 'Демо данные',
      description: 'Демонстрационные данные для тестирования',
      file: 'assets/taxlien_demo.rada',
      estimatedRecords: 100,
      size: '15 KB',
      states: ['DEMO'],
      icon: Icons.play_circle_outline,
      color: Colors.purple,
    ),
    'DEFAULT': RadaFileInfo(
      key: 'DEFAULT',
      name: 'Базовый набор',
      description: 'Базовый набор данных',
      file: 'assets/taxlien.rada',
      estimatedRecords: 5000,
      size: '950 KB',
      states: ['DEFAULT'],
      icon: Icons.folder,
      color: Colors.grey,
    ),
  };

  Set<String> _selectedFiles = {'DEMO'};
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadSavedSelection();
  }

  Future<void> _loadSavedSelection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('selected_rada_states');
      if (saved != null && saved.isNotEmpty) {
        setState(() {
          _selectedFiles = saved.toSet();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки настроек: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          'selected_rada_states', _selectedFiles.toList());

      // Reload data with new selection
      final dataLoader = OfflineDataLoaderService();
      await dataLoader.initialize();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Настройки сохранены. Данные обновлены.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSelection(String key) {
    setState(() {
      if (key == 'ALL') {
        // If selecting ALL, deselect others
        if (_selectedFiles.contains('ALL')) {
          _selectedFiles.remove('ALL');
        } else {
          _selectedFiles = {'ALL'};
        }
      } else {
        // If selecting specific state, remove ALL
        _selectedFiles.remove('ALL');
        if (_selectedFiles.contains(key)) {
          _selectedFiles.remove(key);
        } else {
          _selectedFiles.add(key);
        }
      }

      // Ensure at least one is selected
      if (_selectedFiles.isEmpty) {
        _selectedFiles.add('DEMO');
      }

      _hasChanges = true;
    });
  }

  int get _totalRecords {
    if (_selectedFiles.contains('ALL')) {
      return _availableFiles['ALL']!.estimatedRecords;
    }
    return _selectedFiles.fold<int>(
      0,
      (sum, key) => sum + (_availableFiles[key]?.estimatedRecords ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор данных'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveSelection,
              child: const Text(
                'Сохранить',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Выбранные данные',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_selectedFiles.length} ${_selectedFiles.length == 1 ? "файл" : "файла"} · ≈${(_totalRecords / 1000).toStringAsFixed(1)}K записей',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),

                // Files list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: _availableFiles.entries.map((entry) {
                      final info = entry.value;
                      final isSelected = _selectedFiles.contains(entry.key);

                      return _RadaFileCard(
                        info: info,
                        isSelected: isSelected,
                        onTap: () => _toggleSelection(entry.key),
                      );
                    }).toList(),
                  ),
                ),

                // Bottom actions
                if (_hasChanges)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _loadSavedSelection();
                                    _hasChanges = false;
                                  });
                                },
                                child: const Text('Отмена'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _saveSelection,
                                child: const Text('Применить изменения'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Данные будут перезагружены',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _RadaFileCard extends StatelessWidget {
  final RadaFileInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadaFileCard({
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: info.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  info.icon,
                  color: info.color,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.folder_outlined,
                          label:
                              '${(info.estimatedRecords / 1000).toStringAsFixed(1)}K',
                        ),
                        const SizedBox(width: 8),
                        _InfoChip(
                          icon: Icons.storage,
                          label: info.size,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Information about a .rada file
class RadaFileInfo {
  final String key;
  final String name;
  final String description;
  final String file;
  final int estimatedRecords;
  final String size;
  final List<String> states;
  final IconData icon;
  final Color color;

  RadaFileInfo({
    required this.key,
    required this.name,
    required this.description,
    required this.file,
    required this.estimatedRecords,
    required this.size,
    required this.states,
    required this.icon,
    required this.color,
  });
}


