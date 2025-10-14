import 'package:flutter/material.dart';
import '../services/preload_service.dart';

/// Screen for selecting which state RADA files to load
class RadaStateSelectorScreen extends StatefulWidget {
  const RadaStateSelectorScreen({super.key});

  @override
  State<RadaStateSelectorScreen> createState() =>
      _RadaStateSelectorScreenState();
}

class _RadaStateSelectorScreenState extends State<RadaStateSelectorScreen> {
  bool _isLoading = false;
  Set<String> _selectedStates = {};
  Map<String, Map<String, int>> _stateSizes = {};

  final Map<String, _StateInfo> _stateInfo = {
    'FL': _StateInfo(
      name: 'Florida',
      description: 'Florida tax liens (18% interest rate)',
      icon: Icons.wb_sunny,
      color: Colors.orange,
      emoji: '🌴',
    ),
    'AZ': _StateInfo(
      name: 'Arizona',
      description: 'Arizona tax liens and deeds',
      icon: Icons.landscape,
      color: Colors.brown,
      emoji: '🌵',
    ),
    'ALL': _StateInfo(
      name: 'All States',
      description: 'Complete dataset with all states',
      icon: Icons.public,
      color: Colors.blue,
      emoji: '🌎',
    ),
    'DEMO': _StateInfo(
      name: 'Demo Data',
      description: 'Sample data for testing',
      icon: Icons.science,
      color: Colors.purple,
      emoji: '🧪',
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentSelection();
    _loadStateSizes();
  }

  Future<void> _loadCurrentSelection() async {
    final loader = PreloadService.offlineLoader;
    if (loader != null) {
      setState(() {
        _selectedStates = loader.selectedStates;
      });
    }
  }

  Future<void> _loadStateSizes() async {
    final loader = PreloadService.offlineLoader;
    if (loader == null) return;

    for (var state in _stateInfo.keys) {
      final size = await loader.getStateDataSize(state);
      if (mounted) {
        setState(() {
          _stateSizes[state] = size;
        });
      }
    }
  }

  void _toggleState(String state) {
    setState(() {
      if (state == 'ALL') {
        // Если выбрали ALL - снимаем выбор с остальных
        _selectedStates = {'ALL'};
      } else {
        // Снимаем ALL если выбираем конкретный штат
        _selectedStates.remove('ALL');

        if (_selectedStates.contains(state)) {
          _selectedStates.remove(state);
          // Если не осталось выборов - выбираем ALL
          if (_selectedStates.isEmpty) {
            _selectedStates.add('ALL');
          }
        } else {
          _selectedStates.add(state);
        }
      }
    });
  }

  Future<void> _applySelection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loader = PreloadService.offlineLoader;
      if (loader != null) {
        final success = await loader.setSelectedStates(_selectedStates);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Loaded data for: ${_selectedStates.join(", ")}',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed: ${loader.error ?? "Unknown error"}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalProducts = _stateSizes.values
        .fold<int>(0, (sum, size) => sum + (size['products'] ?? 0));
    final totalSize = _stateSizes.values
        .where((size) => _selectedStates.contains(_stateSizes.keys
            .firstWhere((key) => _stateSizes[key] == size, orElse: () => '')))
        .fold<int>(0, (sum, size) => sum + (size['file_size_kb'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор штатов'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _applySelection,
              child: const Text(
                'ПРИМЕНИТЬ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загрузка данных...'),
                ],
              ),
            )
          : Column(
              children: [
                // Summary card
                Card(
                  margin: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Выбрано: ${_selectedStates.length} ${_selectedStates.length == 1 ? "источник" : "источника"}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_stateSizes.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.storage,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Размер: ~${totalSize}KB',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.inventory,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Продуктов: ~$totalProducts',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // State selection list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _stateInfo.entries.map((entry) {
                      final state = entry.key;
                      final info = entry.value;
                      final isSelected = _selectedStates.contains(state);
                      final size = _stateSizes[state];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: isSelected ? 4 : 1,
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) => _toggleState(state),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: info.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(info.icon, color: info.color),
                          ),
                          title: Row(
                            children: [
                              Text(
                                info.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                info.name,
                                style: TextStyle(
                                  fontWeight:
                                      isSelected ? FontWeight.bold : null,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(info.description),
                              if (size != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.inventory_2,
                                        size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${size['products']} products',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.file_copy,
                                        size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${size['file_size_kb']}KB',
                                      style: TextStyle(
                                        fontSize: 12,
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
                    }).toList(),
                  ),
                ),

                // Bottom tip
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Выберите несколько штатов для объединения данных, или "All States" для полного набора',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
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

class _StateInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String emoji;

  _StateInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.emoji,
  });
}
