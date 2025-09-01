import 'package:flutter/material.dart';
import '../core/models/magento_models.dart';

/// Chip widget for displaying and selecting categories
class CategoryChip extends StatelessWidget {
  final MagentoCategory category;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin ?? const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 2 : 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category.level > 1) ...[
                  Icon(
                    Icons.subdirectory_arrow_right,
                    size: 14,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (category.productCount != null && category.productCount! > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.onPrimary.withOpacity(0.2)
                          : colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${category.productCount}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable list of category chips
class CategoryChipList extends StatelessWidget {
  final List<MagentoCategory> categories;
  final MagentoCategory? selectedCategory;
  final Function(MagentoCategory?)? onCategorySelected;
  final bool showAllOption;

  const CategoryChipList({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" option
          if (showAllOption)
            CategoryChip(
              category: MagentoCategory(
                id: 0,
                name: 'All',
                isActive: true,
                position: 0,
                level: 1,
                productCount: null,
                childrenData: [],
              ),
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected?.call(null),
            ),
          
          // Category chips
          ...categories.map((category) => CategoryChip(
            category: category,
            isSelected: selectedCategory?.id == category.id,
            onTap: () => onCategorySelected?.call(category),
          )),
        ],
      ),
    );
  }
}

/// Category filter bottom sheet with hierarchical categories
class CategoryFilterBottomSheet extends StatefulWidget {
  final List<MagentoCategory> categories;
  final MagentoCategory? selectedCategory;
  final Function(MagentoCategory?)? onCategorySelected;

  const CategoryFilterBottomSheet({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  State<CategoryFilterBottomSheet> createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  MagentoCategory? _selectedCategory;
  final Map<int, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Select Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          
          // Categories list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // All option
                _buildCategoryTile(
                  category: null,
                  title: 'All Categories',
                  isSelected: _selectedCategory == null,
                ),
                
                const Divider(),
                
                // Category hierarchy
                ...widget.categories.where((cat) => cat.level == 2).map((category) {
                  return _buildCategoryHierarchy(category);
                }),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onCategorySelected?.call(_selectedCategory);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHierarchy(MagentoCategory category) {
    final hasChildren = category.childrenData?.isNotEmpty == true;
    final isExpanded = _expandedCategories[category.id] ?? false;

    return Column(
      children: [
        _buildCategoryTile(
          category: category,
          title: category.name,
          isSelected: _selectedCategory?.id == category.id,
          hasChildren: hasChildren,
          isExpanded: isExpanded,
          onToggleExpanded: hasChildren ? () {
            setState(() {
              _expandedCategories[category.id] = !isExpanded;
            });
          } : null,
        ),
        
        // Child categories
        if (hasChildren && isExpanded)
          ...category.childrenData!.map((childCategory) {
            return Padding(
              padding: const EdgeInsets.only(left: 20),
              child: _buildCategoryTile(
                category: childCategory,
                title: childCategory.name,
                isSelected: _selectedCategory?.id == childCategory.id,
                isChild: true,
              ),
            );
          }),
      ],
    );
  }

  Widget _buildCategoryTile({
    required MagentoCategory? category,
    required String title,
    required bool isSelected,
    bool hasChildren = false,
    bool isExpanded = false,
    bool isChild = false,
    VoidCallback? onToggleExpanded,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: isChild 
          ? const SizedBox(width: 24)
          : category == null 
              ? Icon(Icons.grid_view, color: colorScheme.primary)
              : Icon(Icons.folder, color: colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: hasChildren
          ? IconButton(
              onPressed: onToggleExpanded,
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : isSelected
              ? Icon(Icons.check, color: colorScheme.primary)
              : null,
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }
}
