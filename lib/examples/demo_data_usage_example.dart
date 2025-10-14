import 'package:flutter/material.dart';
import '../services/simplified_demo_integration.dart';

/// DEPRECATED: This example uses old demo data classes
/// For production code, use OfflineDataLoaderService to load data from .rada files
/// 
/// Example:
/// ```dart
/// import '../services/offline_data_loader_service.dart';
/// 
/// final loader = OfflineDataLoaderService();
/// await loader.initialize();
/// final products = await loader.getProducts();
/// final counties = await loader.getCountiesForState('FL');
/// ```
///
/// Пример использования демо данных в TaxLien.online (DEPRECATED)
class DemoDataUsageExample extends StatefulWidget {
  const DemoDataUsageExample({Key? key}) : super(key: key);

  @override
  State<DemoDataUsageExample> createState() => _DemoDataUsageExampleState();
}

class _DemoDataUsageExampleState extends State<DemoDataUsageExample> {
  late SimplifiedDemoIntegration _demoIntegration;
  bool _isLoading = true;
  String? _error;

  // Demo data
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _counties = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  Future<void> _initializeDemoData() async {
    try {
      _demoIntegration = SimplifiedDemoIntegration();
      await _demoIntegration.initialize();

      // Load demo data
      await _loadDemoData();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize demo data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDemoData() async {
    // Load products
    _products = _demoIntegration.getProducts(pageSize: 10);

    // Load categories
    _categories = _demoIntegration.getCategories();

    // Load customers
    _customers = _demoIntegration.getCustomers(pageSize: 5);

    // Load orders
    _orders = _demoIntegration.getOrders(pageSize: 5);

    // Load counties for Florida
    _counties = _demoIntegration.getCountiesByState('FL');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeDemoData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaxLien.online Demo Data'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildProductsSection(),
            const SizedBox(height: 16),
            _buildCategoriesSection(),
            const SizedBox(height: 16),
            _buildCountiesSection(),
            const SizedBox(height: 16),
            _buildCustomersSection(),
            const SizedBox(height: 16),
            _buildOrdersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Data Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Products', _products.length.toString()),
                _buildStatItem('Categories', _categories.length.toString()),
                _buildStatItem('Counties', _counties.length.toString()),
                _buildStatItem('Customers', _customers.length.toString()),
                _buildStatItem('Orders', _orders.length.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tax Lien Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._products.take(3).map((product) => _buildProductItem(product)),
            if (_products.length > 3)
              TextButton(
                onPressed: () => _showAllProducts(),
                child: const Text('View All Products'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    final attributes = product['custom_attributes'] as List<dynamic>?;
    final address = attributes?.firstWhere(
          (attr) => attr['attribute_code'] == 'property_address',
          orElse: () => null,
        )?['value'] ??
        'Unknown Address';

    final county = attributes?.firstWhere(
          (attr) => attr['attribute_code'] == 'county',
          orElse: () => null,
        )?['value'] ??
        'Unknown County';

    return ListTile(
      title: Text(product['name']?.toString() ?? 'Unknown Product'),
      subtitle: Text('$address, $county'),
      trailing: Text(
        '\$${product['price']?.toString() ?? '0'}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories (States)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories
                  .where((cat) => cat['level'] == 2)
                  .take(10)
                  .map((category) => Chip(
                        label: Text(category['name']?.toString() ?? ''),
                        backgroundColor: Colors.blue[100],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountiesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Florida Counties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total counties: ${_counties.length}'),
            const SizedBox(height: 8),
            ..._counties.take(5).map((county) => _buildCountyItem(county)),
            if (_counties.length > 5)
              TextButton(
                onPressed: () => _showAllCounties(),
                child: const Text('View All Counties'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountyItem(Map<String, dynamic> county) {
    return ListTile(
      title: Text(county['name']?.toString() ?? 'Unknown County'),
      subtitle: Text('Population: ${county['population']?.toString() ?? '0'}'),
      trailing: Text('${county['area']?.toString() ?? '0'} sq mi'),
    );
  }

  Widget _buildCustomersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._customers.map((customer) => _buildCustomerItem(customer)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerItem(Map<String, dynamic> customer) {
    return ListTile(
      title: Text(
        '${customer['firstname']} ${customer['lastname']}',
      ),
      subtitle: Text(customer['email']?.toString() ?? ''),
      trailing: const Icon(Icons.person),
    );
  }

  Widget _buildOrdersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._orders.map((order) => _buildOrderItem(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    return ListTile(
      title: Text('Order #${order['increment_id']}'),
      subtitle: Text('Status: ${order['status']}'),
      trailing: Text('\$${order['grand_total']?.toString() ?? '0'}'),
    );
  }

  void _showAllProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Products'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ListTile(
                title: Text(product['name']?.toString() ?? ''),
                subtitle: Text(product['sku']?.toString() ?? ''),
                trailing: Text('\$${product['price']?.toString() ?? '0'}'),
              );
            },
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

  void _showAllCounties() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Florida Counties'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _counties.length,
            itemBuilder: (context, index) {
              final county = _counties[index];
              return ListTile(
                title: Text(county['name']?.toString() ?? ''),
                subtitle: Text('Population: ${county['population']}'),
                trailing: Text('${county['area']} sq mi'),
              );
            },
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
}

/// Пример использования статических методов демо данных
class StaticDemoDataExample {
  static void demonstrateStaticUsage() {
    // Получение всех продуктов
    final products = TaxLienDemoData.demoProducts;
    print('Total products: ${products.length}');

    // Получение продуктов по штату
    final floridaProducts = TaxLienDemoData.getTaxLienProductsByState('FL');
    print('Florida products: ${floridaProducts.length}');

    // Получение доступных tax liens
    final availableLiens = TaxLienDemoData.getAvailableTaxLiens();
    print('Available liens: ${availableLiens.length}');

    // Получение всех категорий
    final categories = TaxLienCategoriesDemoData.allCategories;
    print('Total categories: ${categories.length}');

    // Получение штатов с tax lien программами
    final states = TaxLienCategoriesDemoData.statesWithTaxLiens;
    print('States with tax liens: ${states.length}');

    // Получение округов штата
    final floridaCounties = TaxLienCountiesDemoData.getCountiesByState('FL');
    print('Florida counties: ${floridaCounties.length}');

    // Получение крупнейших округов по населению
    final largestCounties =
        TaxLienCountiesDemoData.getLargestCountiesByPopulation('FL', 5);
    print('Largest Florida counties: ${largestCounties.length}');

    // Получение статистики по штату
    final totalPopulation =
        TaxLienCountiesDemoData.getTotalPopulationForState('FL');
    final totalArea = TaxLienCountiesDemoData.getTotalAreaForState('FL');
    final density =
        TaxLienCountiesDemoData.getAveragePopulationDensityForState('FL');

    print('Florida statistics:');
    print('  Total population: $totalPopulation');
    print('  Total area: $totalArea sq mi');
    print('  Average density: $density people/sq mi');
  }
}
