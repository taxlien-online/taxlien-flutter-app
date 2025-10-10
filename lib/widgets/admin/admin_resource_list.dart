import 'package:flutter/material.dart';
import '../../core/admin_panel/admin_config.dart';
import '../../core/admin_panel/data_provider.dart';

/// Resource list view with CRUD operations
class AdminResourceList extends StatefulWidget {
  final AdminResource resource;
  final AdminDataProvider dataProvider;

  const AdminResourceList({
    super.key,
    required this.resource,
    required this.dataProvider,
  });

  @override
  State<AdminResourceList> createState() => _AdminResourceListState();
}

class _AdminResourceListState extends State<AdminResourceList> {
  List<Map<String, dynamic>> _items = [];
  int _total = 0;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isLoading = true;
  String? _sortField;
  bool _sortAscending = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final result = await widget.dataProvider.getList(
        widget.resource.name,
        pagination: PaginationConfig(
          page: _currentPage,
          pageSize: _pageSize,
        ),
        sort: _sortField != null
            ? SortConfig(field: _sortField!, ascending: _sortAscending)
            : null,
      );

      setState(() {
        _items = result.data;
        _total = result.total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          if (widget.resource.canExport)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportData,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildToolbar(),
                Expanded(
                  child:
                      _items.isEmpty ? _buildEmptyState() : _buildDataTable(),
                ),
                _buildPagination(),
              ],
            ),
      floatingActionButton: widget.resource.canCreate
          ? FloatingActionButton(
              onPressed: _showCreateDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Total: $_total items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          if (widget.resource.canDelete)
            TextButton.icon(
              onPressed: _selectedItems.isEmpty ? null : _deleteSelected,
              icon: const Icon(Icons.delete),
              label: Text('Delete Selected (${_selectedItems.length})'),
            ),
        ],
      ),
    );
  }

  final Set<String> _selectedItems = {};

  Widget _buildDataTable() {
    final visibleColumns =
        widget.resource.columns.where((c) => c.visible).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: widget.resource.canDelete,
          columns: [
            ...visibleColumns.map((column) => DataColumn(
                  label: Text(column.label),
                  onSort: column.sortable
                      ? (_, ascending) {
                          setState(() {
                            _sortField = column.key;
                            _sortAscending = ascending;
                          });
                          _loadData();
                        }
                      : null,
                )),
            const DataColumn(label: Text('Actions')),
          ],
          rows: _items.map((item) {
            final id = item['id']?.toString() ?? '';
            return DataRow(
              selected: _selectedItems.contains(id),
              onSelectChanged: widget.resource.canDelete
                  ? (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedItems.add(id);
                        } else {
                          _selectedItems.remove(id);
                        }
                      });
                    }
                  : null,
              cells: [
                ...visibleColumns.map((column) => DataCell(
                      _buildCellContent(item[column.key], column),
                    )),
                DataCell(_buildActions(item)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCellContent(dynamic value, ColumnConfig column) {
    if (value == null) {
      return const Text('-');
    }

    switch (column.type) {
      case ColumnType.bool:
        return Icon(
          value == true ? Icons.check_circle : Icons.cancel,
          color: value == true ? Colors.green : Colors.red,
          size: 20,
        );
      case ColumnType.image:
        return Image.network(
          value.toString(),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      case ColumnType.date:
      case ColumnType.datetime:
        return Text(DateTime.tryParse(value.toString())?.toString() ??
            value.toString());
      default:
        return Text(value.toString());
    }
  }

  Widget _buildActions(Map<String, dynamic> item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, size: 20),
          onPressed: () => _showViewDialog(item),
          tooltip: 'View',
        ),
        if (widget.resource.canEdit)
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditDialog(item),
            tooltip: 'Edit',
          ),
        if (widget.resource.canDelete)
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () => _deleteItem(item),
            tooltip: 'Delete',
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.resource.icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${widget.resource.label} Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first ${widget.resource.label.toLowerCase()} to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (widget.resource.canCreate) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add),
              label: Text('Create ${widget.resource.label}'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_total / _pageSize).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _loadData();
                  }
                : null,
          ),
          Text(
            'Page $_currentPage of $totalPages',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _loadData();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search term',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement search
              _loadData();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create ${widget.resource.label}'),
        content: const Text('Create form coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Create functionality coming soon')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showViewDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View ${widget.resource.label}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.resource.columns
                .map((column) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            column.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(item[column.key]?.toString() ?? '-'),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${widget.resource.label}'),
        content: const Text('Edit form coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit functionality coming soon')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final id = item['id']?.toString() ?? '';
        await widget.dataProvider.delete(widget.resource.name, id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully')),
          );
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting item: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete ${_selectedItems.length} items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.dataProvider.deleteMany(
          widget.resource.name,
          _selectedItems.toList(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Items deleted successfully')),
          );
          _selectedItems.clear();
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting items: $e')),
          );
        }
      }
    }
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
