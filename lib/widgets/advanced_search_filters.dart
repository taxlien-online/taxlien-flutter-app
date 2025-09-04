import 'package:flutter/material.dart';
import '../core/models/magento_models.dart';
import '../core/models/tax_lien_models.dart';

/// Advanced search filters for both modern and legacy tax liens
class AdvancedSearchFilters {
  // Location filters
  String? state;
  String? county;
  String? city;
  String? zipCode;
  
  // Financial filters
  double? minTaxAmount;
  double? maxTaxAmount;
  double? minInterestRate;
  double? maxInterestRate;
  double? minAssessedValue;
  double? maxAssessedValue;
  
  // Property filters
  String? propertyType;
  double? minLotSize;
  double? maxLotSize;
  int? minBedrooms;
  int? maxBedrooms;
  int? minBathrooms;
  int? maxBathrooms;
  
  // Status and date filters
  String? status;
  DateTime? minIssueDate;
  DateTime? maxIssueDate;
  DateTime? minSaleDate;
  DateTime? maxSaleDate;
  
  // Magento specific filters
  String? categoryId;
  String? brand;
  double? minPrice;
  double? maxPrice;
  bool? inStock;
  String? sortBy;
  String? sortOrder;
  
  // Advanced filters
  bool? hasImages;
  bool? isFeatured;
  List<String>? tags;
  String? condition;
  
  AdvancedSearchFilters();

  /// Check if any filters are active
  bool hasActiveFilters() {
    return state != null ||
        county != null ||
        city != null ||
        zipCode != null ||
        minTaxAmount != null ||
        maxTaxAmount != null ||
        minInterestRate != null ||
        maxInterestRate != null ||
        minAssessedValue != null ||
        maxAssessedValue != null ||
        propertyType != null ||
        minLotSize != null ||
        maxLotSize != null ||
        minBedrooms != null ||
        maxBedrooms != null ||
        minBathrooms != null ||
        maxBathrooms != null ||
        status != null ||
        minIssueDate != null ||
        maxIssueDate != null ||
        minSaleDate != null ||
        maxSaleDate != null ||
        categoryId != null ||
        brand != null ||
        minPrice != null ||
        maxPrice != null ||
        inStock != null ||
        hasImages != null ||
        isFeatured != null ||
        (tags != null && tags!.isNotEmpty) ||
        condition != null;
  }

  /// Get list of active filters for display
  List<ActiveFilter> getActiveFilters() {
    List<ActiveFilter> filters = [];
    
    if (state != null) filters.add(ActiveFilter('state', 'State: $state'));
    if (county != null) filters.add(ActiveFilter('county', 'County: $county'));
    if (city != null) filters.add(ActiveFilter('city', 'City: $city'));
    if (zipCode != null) filters.add(ActiveFilter('zipCode', 'ZIP: $zipCode'));
    if (minTaxAmount != null) filters.add(ActiveFilter('minTaxAmount', 'Min Tax: \$${minTaxAmount!.toStringAsFixed(0)}'));
    if (maxTaxAmount != null) filters.add(ActiveFilter('maxTaxAmount', 'Max Tax: \$${maxTaxAmount!.toStringAsFixed(0)}'));
    if (minInterestRate != null) filters.add(ActiveFilter('minInterestRate', 'Min Rate: ${minInterestRate!}%'));
    if (maxInterestRate != null) filters.add(ActiveFilter('maxInterestRate', 'Max Rate: ${maxInterestRate!}%'));
    if (minAssessedValue != null) filters.add(ActiveFilter('minAssessedValue', 'Min Value: \$${minAssessedValue!.toStringAsFixed(0)}'));
    if (maxAssessedValue != null) filters.add(ActiveFilter('maxAssessedValue', 'Max Value: \$${maxAssessedValue!.toStringAsFixed(0)}'));
    if (propertyType != null) filters.add(ActiveFilter('propertyType', 'Type: $propertyType'));
    if (status != null) filters.add(ActiveFilter('status', 'Status: $status'));
    if (categoryId != null) filters.add(ActiveFilter('categoryId', 'Category: $categoryId'));
    if (brand != null) filters.add(ActiveFilter('brand', 'Brand: $brand'));
    if (minPrice != null) filters.add(ActiveFilter('minPrice', 'Min Price: \$${minPrice!.toStringAsFixed(0)}'));
    if (maxPrice != null) filters.add(ActiveFilter('maxPrice', 'Max Price: \$${maxPrice!.toStringAsFixed(0)}'));
    if (inStock != null) filters.add(ActiveFilter('inStock', 'In Stock: ${inStock! ? 'Yes' : 'No'}'));
    if (hasImages != null) filters.add(ActiveFilter('hasImages', 'Has Images: ${hasImages! ? 'Yes' : 'No'}'));
    if (isFeatured != null) filters.add(ActiveFilter('isFeatured', 'Featured: ${isFeatured! ? 'Yes' : 'No'}'));
    if (condition != null) filters.add(ActiveFilter('condition', 'Condition: $condition'));
    
    return filters;
  }

  /// Remove a specific filter
  AdvancedSearchFilters removeFilter(String key) {
    final newFilters = AdvancedSearchFilters();
    
    // Copy all current values
    newFilters.state = state;
    newFilters.county = county;
    newFilters.city = city;
    newFilters.zipCode = zipCode;
    newFilters.minTaxAmount = minTaxAmount;
    newFilters.maxTaxAmount = maxTaxAmount;
    newFilters.minInterestRate = minInterestRate;
    newFilters.maxInterestRate = maxInterestRate;
    newFilters.minAssessedValue = minAssessedValue;
    newFilters.maxAssessedValue = maxAssessedValue;
    newFilters.propertyType = propertyType;
    newFilters.minLotSize = minLotSize;
    newFilters.maxLotSize = maxLotSize;
    newFilters.minBedrooms = minBedrooms;
    newFilters.maxBedrooms = maxBedrooms;
    newFilters.minBathrooms = minBathrooms;
    newFilters.maxBathrooms = maxBathrooms;
    newFilters.status = status;
    newFilters.minIssueDate = minIssueDate;
    newFilters.maxIssueDate = maxIssueDate;
    newFilters.minSaleDate = minSaleDate;
    newFilters.maxSaleDate = maxSaleDate;
    newFilters.categoryId = categoryId;
    newFilters.brand = brand;
    newFilters.minPrice = minPrice;
    newFilters.maxPrice = maxPrice;
    newFilters.inStock = inStock;
    newFilters.sortBy = sortBy;
    newFilters.sortOrder = sortOrder;
    newFilters.hasImages = hasImages;
    newFilters.isFeatured = isFeatured;
    newFilters.tags = tags;
    newFilters.condition = condition;
    
    // Remove the specified filter
    switch (key) {
      case 'state': newFilters.state = null; break;
      case 'county': newFilters.county = null; break;
      case 'city': newFilters.city = null; break;
      case 'zipCode': newFilters.zipCode = null; break;
      case 'minTaxAmount': newFilters.minTaxAmount = null; break;
      case 'maxTaxAmount': newFilters.maxTaxAmount = null; break;
      case 'minInterestRate': newFilters.minInterestRate = null; break;
      case 'maxInterestRate': newFilters.maxInterestRate = null; break;
      case 'minAssessedValue': newFilters.minAssessedValue = null; break;
      case 'maxAssessedValue': newFilters.maxAssessedValue = null; break;
      case 'propertyType': newFilters.propertyType = null; break;
      case 'status': newFilters.status = null; break;
      case 'categoryId': newFilters.categoryId = null; break;
      case 'brand': newFilters.brand = null; break;
      case 'minPrice': newFilters.minPrice = null; break;
      case 'maxPrice': newFilters.maxPrice = null; break;
      case 'inStock': newFilters.inStock = null; break;
      case 'hasImages': newFilters.hasImages = null; break;
      case 'isFeatured': newFilters.isFeatured = null; break;
      case 'condition': newFilters.condition = null; break;
    }
    
    return newFilters;
  }

  /// Convert to Magento API filters
  Map<String, dynamic> toMagentoFilters() {
    final filters = <String, dynamic>{};
    
    if (categoryId != null) filters['category_id'] = categoryId;
    if (brand != null) filters['brand'] = brand;
    if (minPrice != null) filters['price_from'] = minPrice;
    if (maxPrice != null) filters['price_to'] = maxPrice;
    if (inStock != null) filters['in_stock'] = inStock;
    if (hasImages != null) filters['has_images'] = hasImages;
    if (isFeatured != null) filters['is_featured'] = isFeatured;
    if (condition != null) filters['condition'] = condition;
    if (tags != null && tags!.isNotEmpty) filters['tags'] = tags;
    if (sortBy != null) filters['sort_by'] = sortBy;
    if (sortOrder != null) filters['sort_order'] = sortOrder;
    
    return filters;
  }

  /// Convert to Tax Lien filters
  Map<String, dynamic> toTaxLienFilters() {
    final filters = <String, dynamic>{};
    
    if (state != null) filters['state'] = state;
    if (county != null) filters['county'] = county;
    if (city != null) filters['city'] = city;
    if (zipCode != null) filters['zip_code'] = zipCode;
    if (minTaxAmount != null) filters['min_tax_amount'] = minTaxAmount;
    if (maxTaxAmount != null) filters['max_tax_amount'] = maxTaxAmount;
    if (minInterestRate != null) filters['min_interest_rate'] = minInterestRate;
    if (maxInterestRate != null) filters['max_interest_rate'] = maxInterestRate;
    if (minAssessedValue != null) filters['min_assessed_value'] = minAssessedValue;
    if (maxAssessedValue != null) filters['max_assessed_value'] = maxAssessedValue;
    if (propertyType != null) filters['property_type'] = propertyType;
    if (minLotSize != null) filters['min_lot_size'] = minLotSize;
    if (maxLotSize != null) filters['max_lot_size'] = maxLotSize;
    if (minBedrooms != null) filters['min_bedrooms'] = minBedrooms;
    if (maxBedrooms != null) filters['max_bedrooms'] = maxBedrooms;
    if (minBathrooms != null) filters['min_bathrooms'] = minBathrooms;
    if (maxBathrooms != null) filters['max_bathrooms'] = maxBathrooms;
    if (status != null) filters['status'] = status;
    if (minIssueDate != null) filters['min_issue_date'] = minIssueDate!.toIso8601String();
    if (maxIssueDate != null) filters['max_issue_date'] = maxIssueDate!.toIso8601String();
    if (minSaleDate != null) filters['min_sale_date'] = minSaleDate!.toIso8601String();
    if (maxSaleDate != null) filters['max_sale_date'] = maxSaleDate!.toIso8601String();
    
    return filters;
  }

  /// Create a copy with updated values
  AdvancedSearchFilters copyWith({
    String? state,
    String? county,
    String? city,
    String? zipCode,
    double? minTaxAmount,
    double? maxTaxAmount,
    double? minInterestRate,
    double? maxInterestRate,
    double? minAssessedValue,
    double? maxAssessedValue,
    String? propertyType,
    double? minLotSize,
    double? maxLotSize,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
    String? status,
    DateTime? minIssueDate,
    DateTime? maxIssueDate,
    DateTime? minSaleDate,
    DateTime? maxSaleDate,
    String? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String? sortBy,
    String? sortOrder,
    bool? hasImages,
    bool? isFeatured,
    List<String>? tags,
    String? condition,
  }) {
    final newFilters = AdvancedSearchFilters();
    
    newFilters.state = state ?? state;
    newFilters.county = county ?? county;
    newFilters.city = city ?? city;
    newFilters.zipCode = zipCode ?? zipCode;
    newFilters.minTaxAmount = minTaxAmount ?? this.minTaxAmount;
    newFilters.maxTaxAmount = maxTaxAmount ?? this.maxTaxAmount;
    newFilters.minInterestRate = minInterestRate ?? this.minInterestRate;
    newFilters.maxInterestRate = maxInterestRate ?? this.maxInterestRate;
    newFilters.minAssessedValue = minAssessedValue ?? this.minAssessedValue;
    newFilters.maxAssessedValue = maxAssessedValue ?? this.maxAssessedValue;
    newFilters.propertyType = propertyType ?? this.propertyType;
    newFilters.minLotSize = minLotSize ?? this.minLotSize;
    newFilters.maxLotSize = maxLotSize ?? this.maxLotSize;
    newFilters.minBedrooms = minBedrooms ?? this.minBedrooms;
    newFilters.maxBedrooms = maxBedrooms ?? this.maxBedrooms;
    newFilters.minBathrooms = minBathrooms ?? this.minBathrooms;
    newFilters.maxBathrooms = maxBathrooms ?? this.maxBathrooms;
    newFilters.status = status ?? this.status;
    newFilters.minIssueDate = minIssueDate ?? this.minIssueDate;
    newFilters.maxIssueDate = maxIssueDate ?? this.maxIssueDate;
    newFilters.minSaleDate = minSaleDate ?? this.minSaleDate;
    newFilters.maxSaleDate = maxSaleDate ?? this.maxSaleDate;
    newFilters.categoryId = categoryId ?? this.categoryId;
    newFilters.brand = brand ?? this.brand;
    newFilters.minPrice = minPrice ?? this.minPrice;
    newFilters.maxPrice = maxPrice ?? this.maxPrice;
    newFilters.inStock = inStock ?? this.inStock;
    newFilters.sortBy = sortBy ?? this.sortBy;
    newFilters.sortOrder = sortOrder ?? this.sortOrder;
    newFilters.hasImages = hasImages ?? this.hasImages;
    newFilters.isFeatured = isFeatured ?? this.isFeatured;
    newFilters.tags = tags ?? this.tags;
    newFilters.condition = condition ?? this.condition;
    
    return newFilters;
  }
}

/// Model for active filter display
class ActiveFilter {
  final String key;
  final String label;

  const ActiveFilter(this.key, this.label);
}

/// Advanced filters configuration dialog
class AdvancedFiltersDialog extends StatefulWidget {
  final AdvancedSearchFilters filters;
  final Function(AdvancedSearchFilters) onFiltersChanged;

  const AdvancedFiltersDialog({
    Key? key,
    required this.filters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<AdvancedFiltersDialog> createState() => _AdvancedFiltersDialogState();
}

class _AdvancedFiltersDialogState extends State<AdvancedFiltersDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AdvancedSearchFilters _currentFilters;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentFilters = widget.filters;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Advanced Filters',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Location', icon: Icon(Icons.location_on)),
                Tab(text: 'Financial', icon: Icon(Icons.attach_money)),
                Tab(text: 'Property', icon: Icon(Icons.home)),
              ],
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLocationFilters(),
                  _buildFinancialFilters(),
                  _buildPropertyFilters(),
                ],
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear All'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationFilters() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'State',
            value: _currentFilters.state,
            onChanged: (value) => _currentFilters.state = value,
            hint: 'e.g., FL, CA, TX',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'County',
            value: _currentFilters.county,
            onChanged: (value) => _currentFilters.county = value,
            hint: 'e.g., Miami-Dade, Los Angeles',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'City',
            value: _currentFilters.city,
            onChanged: (value) => _currentFilters.city = value,
            hint: 'e.g., Miami, Los Angeles',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'ZIP Code',
            value: _currentFilters.zipCode,
            onChanged: (value) => _currentFilters.zipCode = value,
            hint: 'e.g., 33101',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialFilters() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Amount Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minTaxAmount,
                  onChanged: (value) => _currentFilters.minTaxAmount = value,
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxTaxAmount,
                  onChanged: (value) => _currentFilters.maxTaxAmount = value,
                  hint: '100000',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            'Interest Rate Range (%)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minInterestRate,
                  onChanged: (value) => _currentFilters.minInterestRate = value,
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxInterestRate,
                  onChanged: (value) => _currentFilters.maxInterestRate = value,
                  hint: '50',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            'Assessed Value Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minAssessedValue,
                  onChanged: (value) => _currentFilters.minAssessedValue = value,
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxAssessedValue,
                  onChanged: (value) => _currentFilters.maxAssessedValue = value,
                  hint: '1000000',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFilters() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            label: 'Property Type',
            value: _currentFilters.propertyType,
            items: const ['Residential', 'Commercial', 'Industrial', 'Agricultural', 'Vacant Land'],
            onChanged: (value) => _currentFilters.propertyType = value,
          ),
          const SizedBox(height: 16),
          
          _buildDropdown(
            label: 'Status',
            value: _currentFilters.status,
            items: const ['Available', 'Sold', 'Redeemed', 'Cancelled', 'Pending'],
            onChanged: (value) => _currentFilters.status = value,
          ),
          const SizedBox(height: 16),
          
          Text(
            'Lot Size Range (sq ft)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minLotSize,
                  onChanged: (value) => _currentFilters.minLotSize = value,
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxLotSize,
                  onChanged: (value) => _currentFilters.maxLotSize = value,
                  hint: '10000',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            'Bedrooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minBedrooms?.toDouble(),
                  onChanged: (value) => _currentFilters.minBedrooms = value?.toInt(),
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxBedrooms?.toDouble(),
                  onChanged: (value) => _currentFilters.maxBedrooms = value?.toInt(),
                  hint: '10',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            'Bathrooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Min',
                  value: _currentFilters.minBathrooms?.toDouble(),
                  onChanged: (value) => _currentFilters.minBathrooms = value?.toInt(),
                  hint: '0',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Max',
                  value: _currentFilters.maxBathrooms?.toDouble(),
                  onChanged: (value) => _currentFilters.maxBathrooms = value?.toInt(),
                  hint: '10',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    required Function(String?) onChanged,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value ?? ''),
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    double? value,
    required Function(double?) onChanged,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value?.toString() ?? ''),
          onChanged: (value) {
            final parsed = double.tryParse(value);
            onChanged(parsed);
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Any'),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            )),
          ],
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters = AdvancedSearchFilters();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_currentFilters);
    Navigator.of(context).pop();
  }
}
