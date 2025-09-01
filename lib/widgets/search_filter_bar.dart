import 'package:flutter/material.dart';

/// Enhanced search and filter bar with modern design
class SearchFilterBar extends StatefulWidget {
  final TextEditingController searchController;
  final String? hintText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final VoidCallback? onSearchChanged;
  final bool hasActiveFilters;
  final String? activeFiltersText;
  final VoidCallback? onClearFilters;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    this.hintText,
    this.onFilterTap,
    this.onSortTap,
    this.onSearchChanged,
    this.hasActiveFilters = false,
    this.activeFiltersText,
    this.onClearFilters,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar with filter and sort buttons
          Row(
            children: [
              // Search field
              Expanded(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          controller: widget.searchController,
                          onChanged: (value) => widget.onSearchChanged?.call(),
                          onTap: () {
                            _animationController.forward();
                          },
                          onEditingComplete: () {
                            _animationController.reverse();
                          },
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? 'Search tax liens...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            suffixIcon: widget.searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      widget.searchController.clear();
                                      widget.onSearchChanged?.call();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Filter button
              _buildActionButton(
                icon: Icons.filter_list,
                isActive: widget.hasActiveFilters,
                onTap: widget.onFilterTap,
                tooltip: 'Filters',
              ),
              
              const SizedBox(width: 8),
              
              // Sort button
              _buildActionButton(
                icon: Icons.sort,
                isActive: false,
                onTap: widget.onSortTap,
                tooltip: 'Sort',
              ),
            ],
          ),
          
          // Active filters indicator
          if (widget.hasActiveFilters && widget.activeFiltersText != null)
            _buildActiveFiltersRow(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isActive ? colorScheme.primary : colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive 
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: isActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              
              // Active indicator
              if (isActive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.activeFiltersText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: widget.onClearFilters,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick filter chips for common filters
class QuickFilterChips extends StatelessWidget {
  final List<QuickFilter> filters;
  final Function(QuickFilter)? onFilterSelected;

  const QuickFilterChips({
    super.key,
    required this.filters,
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return _buildFilterChip(context, filter);
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, QuickFilter filter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: filter.isSelected ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => onFilterSelected?.call(filter),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: filter.isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (filter.icon != null) ...[
                  Icon(
                    filter.icon,
                    size: 16,
                    color: filter.isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  filter.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: filter.isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                    fontWeight: filter.isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (filter.count != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: filter.isSelected 
                          ? colorScheme.onPrimary.withOpacity(0.2)
                          : colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filter.count}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: filter.isSelected ? colorScheme.onPrimary : colorScheme.primary,
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

/// Model for quick filter
class QuickFilter {
  final String id;
  final String label;
  final IconData? icon;
  final int? count;
  final bool isSelected;
  final Map<String, dynamic>? filterData;

  const QuickFilter({
    required this.id,
    required this.label,
    this.icon,
    this.count,
    this.isSelected = false,
    this.filterData,
  });

  QuickFilter copyWith({
    String? id,
    String? label,
    IconData? icon,
    int? count,
    bool? isSelected,
    Map<String, dynamic>? filterData,
  }) {
    return QuickFilter(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      count: count ?? this.count,
      isSelected: isSelected ?? this.isSelected,
      filterData: filterData ?? this.filterData,
    );
  }
}
