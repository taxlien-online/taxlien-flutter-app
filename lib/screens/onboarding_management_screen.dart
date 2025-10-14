import 'package:flutter/material.dart';
import '../services/onboarding_data_provider.dart';

/// Screen for managing onboarding pages through admin panel
/// Allows admins to create, edit, delete, and reorder onboarding pages
class OnboardingManagementScreen extends StatefulWidget {
  const OnboardingManagementScreen({super.key});

  @override
  State<OnboardingManagementScreen> createState() =>
      _OnboardingManagementScreenState();
}

class _OnboardingManagementScreenState
    extends State<OnboardingManagementScreen> {
  final OnboardingDataProvider _dataProvider = OnboardingDataProvider();
  List<Map<String, dynamic>> _pages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _dataProvider.getList(
        sortField: 'order',
        sortOrder: 'ASC',
      );

      setState(() {
        _pages = List<Map<String, dynamic>>.from(result['data'] as List);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createPage() async {
    final newPage = {
      'order': _pages.length,
      'title': 'Новый шаг',
      'subtitle': 'Подзаголовок',
      'description': 'Описание',
      'iconName': 'info',
      'colorHex': '#2196F3',
      'isActive': true,
    };

    await _showEditDialog(newPage, isNew: true);
  }

  Future<void> _editPage(Map<String, dynamic> page) async {
    await _showEditDialog(page, isNew: false);
  }

  Future<void> _showEditDialog(Map<String, dynamic> page,
      {required bool isNew}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => OnboardingEditDialog(
        page: page,
        isNew: isNew,
      ),
    );

    if (result != null) {
      try {
        if (isNew) {
          await _dataProvider.create(result);
        } else {
          await _dataProvider.update(page['id'] as String, result);
        }
        await _loadPages();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      }
    }
  }

  Future<void> _deletePage(Map<String, dynamic> page) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить страницу?'),
        content: Text('Вы уверены, что хотите удалить "${page['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dataProvider.delete(page['id'] as String);
        await _loadPages();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      }
    }
  }

  Future<void> _reorderPages(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    setState(() {
      final page = _pages.removeAt(oldIndex);
      _pages.insert(newIndex, page);

      // Update order for all pages
      for (int i = 0; i < _pages.length; i++) {
        _pages[i]['order'] = i;
      }
    });

    // Save to backend
    try {
      for (final page in _pages) {
        await _dataProvider.update(page['id'] as String, page);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
      await _loadPages(); // Reload to get correct order
    }
  }

  Future<void> _resetToDefault() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбросить к настройкам по умолчанию?'),
        content: const Text(
            'Все текущие страницы onboarding будут заменены на страницы по умолчанию.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dataProvider.resetToDefault();
        await _loadPages();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Страницы onboarding сброшены к настройкам по умолчанию')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление Onboarding'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPages,
            tooltip: 'Обновить',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefault,
            tooltip: 'Сбросить к настройкам по умолчанию',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createPage,
            tooltip: 'Добавить страницу',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPages,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_pages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.view_carousel, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Нет страниц onboarding'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createPage,
              child: const Text('Создать первую страницу'),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      itemCount: _pages.length,
      onReorder: _reorderPages,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final page = _pages[index];
        return _buildPageCard(page, index);
      },
    );
  }

  Widget _buildPageCard(Map<String, dynamic> page, int index) {
    final iconData = _getIconData(page['iconName'] as String);
    final color = _getColor(page['colorHex'] as String);
    final isActive = page['isActive'] as bool? ?? true;

    return Card(
      key: ValueKey(page['id']),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: color),
            ),
          ],
        ),
        title: Text(
          page['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(page['subtitle'] as String),
            const SizedBox(height: 4),
            Text(
              'Порядок: ${page['order']} • ${isActive ? "Активно" : "Неактивно"}',
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editPage(page),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePage(page),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'trending_up': Icons.trending_up,
      'how_to_reg': Icons.how_to_reg,
      'security': Icons.security,
      'rocket_launch': Icons.rocket_launch,
      'person': Icons.person,
      'shopping_cart': Icons.shopping_cart,
      'wallet': Icons.wallet,
      'analytics': Icons.analytics,
      'settings': Icons.settings,
      'home': Icons.home,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'info': Icons.info,
      'help': Icons.help,
      'check_circle': Icons.check_circle,
    };

    return iconMap[iconName] ?? Icons.info;
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }
}

/// Dialog for editing onboarding page
class OnboardingEditDialog extends StatefulWidget {
  final Map<String, dynamic> page;
  final bool isNew;

  const OnboardingEditDialog({
    super.key,
    required this.page,
    required this.isNew,
  });

  @override
  State<OnboardingEditDialog> createState() => _OnboardingEditDialogState();
}

class _OnboardingEditDialogState extends State<OnboardingEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late String _selectedIcon;
  late String _selectedColor;
  late bool _isActive;

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'trending_up', 'icon': Icons.trending_up},
    {'name': 'how_to_reg', 'icon': Icons.how_to_reg},
    {'name': 'security', 'icon': Icons.security},
    {'name': 'rocket_launch', 'icon': Icons.rocket_launch},
    {'name': 'person', 'icon': Icons.person},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
    {'name': 'wallet', 'icon': Icons.wallet},
    {'name': 'analytics', 'icon': Icons.analytics},
    {'name': 'settings', 'icon': Icons.settings},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'favorite', 'icon': Icons.favorite},
    {'name': 'star', 'icon': Icons.star},
    {'name': 'info', 'icon': Icons.info},
    {'name': 'help', 'icon': Icons.help},
    {'name': 'check_circle', 'icon': Icons.check_circle},
  ];

  final List<String> _availableColors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#9C27B0', // Purple
    '#F44336', // Red
    '#00BCD4', // Cyan
    '#FFEB3B', // Yellow
    '#795548', // Brown
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.page['title'] as String?);
    _subtitleController =
        TextEditingController(text: widget.page['subtitle'] as String?);
    _descriptionController =
        TextEditingController(text: widget.page['description'] as String?);
    _selectedIcon = widget.page['iconName'] as String? ?? 'info';
    _selectedColor = widget.page['colorHex'] as String? ?? '#2196F3';
    _isActive = widget.page['isActive'] as bool? ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew
          ? 'Создать страницу Onboarding'
          : 'Редактировать страницу Onboarding'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Подзаголовок',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Иконка',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((iconData) {
                  final iconName = iconData['name'] as String;
                  final icon = iconData['icon'] as IconData;
                  final isSelected = iconName == _selectedIcon;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconName;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Цвет', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getColor(color),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Активно'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  void _save() {
    final updatedPage = {
      ...widget.page,
      'title': _titleController.text,
      'subtitle': _subtitleController.text,
      'description': _descriptionController.text,
      'iconName': _selectedIcon,
      'colorHex': _selectedColor,
      'isActive': _isActive,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    Navigator.pop(context, updatedPage);
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }
}

