import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../../../widgets/tax_lien_card.dart';
import '../providers/simulator_provider.dart';
import '../models/simulated_portfolio.dart';
import '../constants/simulator_constants.dart';
import '../widgets/simulate_purchase_button.dart';

/// Property browsing screen for the simulator
/// Shows available properties with "Simulate Purchase" action
class PropertyBrowseScreen extends StatefulWidget {
  final SimulatedPortfolio portfolio;

  const PropertyBrowseScreen({
    super.key,
    required this.portfolio,
  });

  @override
  State<PropertyBrowseScreen> createState() => _PropertyBrowseScreenState();
}

class _PropertyBrowseScreenState extends State<PropertyBrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TaxLien> _properties = [];
  bool _isLoading = false;
  String? _error;

  // Filter states
  double _minPrice = 0;
  double _maxPrice = 500000;
  String? _selectedCounty;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final taxLienService = context.read<TaxLienService>();
      final allProperties = await taxLienService.searchLiens();

      // Filter properties for simulator mode
      final filtered = allProperties.where((property) {
        // Apply price filter
        if (property.taxAmount < _minPrice || property.taxAmount > _maxPrice) {
          return false;
        }

        // Apply county filter
        if (_selectedCounty != null && property.county != _selectedCounty) {
          return false;
        }

        // Apply state filter
        if (_selectedState != null && property.state != _selectedState) {
          return false;
        }

        // Only show available properties
        return property.isAvailable ?? true;
      }).toList();

      setState(() {
        _properties = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load properties: $e';
        _isLoading = false;
      });
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _minPrice = 0;
                        _maxPrice = 500000;
                        _selectedCounty = null;
                        _selectedState = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price range
              const Text('Price Range'),
              RangeSlider(
                values: RangeValues(_minPrice, _maxPrice),
                min: 0,
                max: 500000,
                divisions: 100,
                labels: RangeLabels(
                  '\$${_minPrice.toStringAsFixed(0)}',
                  '\$${_maxPrice.toStringAsFixed(0)}',
                ),
                onChanged: (values) {
                  setModalState(() {
                    _minPrice = values.start;
                    _maxPrice = values.end;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Trigger rebuild with new filters
                    });
                    Navigator.pop(context);
                    _loadProperties();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final simulatorProvider = context.watch<SimulatorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Portfolio info header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.portfolio.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Available Capital: \$${widget.portfolio.availableCapital.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${widget.portfolio.positionCount} Positions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by address, county, or parcel ID',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Property list
          Expanded(
            child: _buildPropertyList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProperties,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _minPrice = 0;
                  _maxPrice = 500000;
                  _selectedCounty = null;
                  _selectedState = null;
                });
                _loadProperties();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    // Filter by search query
    final searchQuery = _searchController.text.toLowerCase();
    final filteredProperties = searchQuery.isEmpty
        ? _properties
        : _properties.where((property) {
            return property.propertyAddress.toLowerCase().contains(searchQuery) ||
                property.county.toLowerCase().contains(searchQuery) ||
                (property.parcelId?.toLowerCase().contains(searchQuery) ?? false);
          }).toList();

    return RefreshIndicator(
      onRefresh: _loadProperties,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filteredProperties.length,
        itemBuilder: (context, index) {
          final property = filteredProperties[index];
          return _buildPropertyCard(property);
        },
      ),
    );
  }

  Widget _buildPropertyCard(TaxLien property) {
    // Add random variance to price for simulator (±10%)
    final variance = (property.taxAmount * 0.1) * (0.5 - (property.id.hashCode % 100) / 100);
    final simulatedPrice = property.taxAmount + variance;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image
          if (property.images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                property.images.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.home, size: 64),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address
                Text(
                  property.propertyAddress,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${property.county}, ${property.state}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),

                // Property details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('Tax Amount', '\$${simulatedPrice.toStringAsFixed(2)}'),
                    _buildDetailItem('Interest Rate', '${property.interestRate}%'),
                    _buildDetailItem('Type', property.propertyType),
                  ],
                ),
                const SizedBox(height: 12),

                // Estimated value
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Est. Value: \$${property.estimatedValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Simulate purchase button
                SimulatePurchaseButton(
                  property: property,
                  portfolio: widget.portfolio,
                  simulatedPrice: simulatedPrice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
