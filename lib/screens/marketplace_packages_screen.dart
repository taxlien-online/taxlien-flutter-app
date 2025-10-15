import 'package:flutter/material.dart';

/// Marketplace screen for competitor packages
class MarketplacePackagesScreen extends StatefulWidget {
  const MarketplacePackagesScreen({super.key});

  @override
  State<MarketplacePackagesScreen> createState() => _MarketplacePackagesScreenState();
}

class _MarketplacePackagesScreenState extends State<MarketplacePackagesScreen> {
  final List<DataPackage> _packages = [
    DataPackage(
      id: 'free_demo',
      name: 'Демо пакет',
      description: 'Бесплатный демонстрационный пакет с ограниченными данными',
      price: 0,
      currency: 'USD',
      features: [
        'Демо данные по 3 штатам',
        'Ограниченная история',
        'Базовый поиск',
        'Без AI-анализа',
      ],
      isFree: true,
      isPopular: false,
      statesIncluded: ['DEMO'],
      recordCount: 100,
    ),
    DataPackage(
      id: 'florida_basic',
      name: 'Florida Базовый',
      description: 'Полные данные по налоговым закладным штата Флорида',
      price: 49.99,
      currency: 'USD',
      features: [
        'Все округа Флориды',
        'Ежедневные обновления',
        'Расширенный поиск',
        'История за 3 года',
        'AI-рекомендации',
      ],
      isFree: false,
      isPopular: true,
      statesIncluded: ['FL'],
      recordCount: 15000,
    ),
    DataPackage(
      id: 'arizona_basic',
      name: 'Arizona Базовый',
      description: 'Полные данные по налоговым закладным штата Аризона',
      price: 39.99,
      currency: 'USD',
      features: [
        'Все округа Аризоны',
        'Ежедневные обновления',
        'Расширенный поиск',
        'История за 3 года',
        'AI-рекомендации',
      ],
      isFree: false,
      isPopular: false,
      statesIncluded: ['AZ'],
      recordCount: 8500,
    ),
    DataPackage(
      id: 'multi_state_pro',
      name: 'Мульти-штат PRO',
      description: 'Профессиональный пакет с данными по нескольким штатам',
      price: 99.99,
      currency: 'USD',
      features: [
        'Florida + Arizona + Texas',
        'Ежедневные обновления',
        'Расширенный AI-анализ',
        'История за 5 лет',
        'Приоритетная поддержка',
        'Экспорт данных',
      ],
      isFree: false,
      isPopular: true,
      statesIncluded: ['FL', 'AZ', 'TX'],
      recordCount: 35000,
    ),
    DataPackage(
      id: 'enterprise',
      name: 'Enterprise',
      description: 'Корпоративный пакет для профессиональных инвесторов',
      price: 299.99,
      currency: 'USD',
      features: [
        'Все 50 штатов США',
        'Реалтайм обновления',
        'Продвинутая AI-аналитика',
        'Полная история',
        'API доступ',
        'Белый лейбл',
        'Персональный менеджер',
      ],
      isFree: false,
      isPopular: false,
      statesIncluded: ['ALL'],
      recordCount: 250000,
    ),
  ];

  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final filteredPackages = _selectedCategory == 'all'
        ? _packages
        : _packages.where((p) => 
            _selectedCategory == 'free' ? p.isFree : !p.isFree
          ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пакеты данных'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Корзина пуста')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'Все',
                    isSelected: _selectedCategory == 'all',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'all';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: 'Бесплатные',
                    isSelected: _selectedCategory == 'free',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'free';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: 'Платные',
                    isSelected: _selectedCategory == 'paid',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'paid';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Packages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredPackages.length,
              itemBuilder: (context, index) {
                final package = filteredPackages[index];
                return _PackageCard(
                  package: package,
                  onPurchase: () => _handlePurchase(package),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase(DataPackage package) {
    if (package.isFree) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Активировать демо пакет?'),
          content: Text('Вы хотите активировать "${package.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Демо пакет активирован!')),
                );
              },
              child: const Text('Активировать'),
            ),
          ],
        ),
      );
    } else {
      _showPurchaseDialog(package);
    }
  }

  void _showPurchaseDialog(DataPackage package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    package.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Price
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '\$${package.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          'за месяц',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Features
                  Text(
                    'Что включено:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...package.features.map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      )),
                  
                  const SizedBox(height: 24),
                  
                  // Purchase button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Покупка "${package.name}" - функция в разработке'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Купить пакет',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Безопасная оплата через Stripe. Отмена в любое время.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}

class _PackageCard extends StatelessWidget {
  final DataPackage package;
  final VoidCallback onPurchase;

  const _PackageCard({
    required this.package,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            package.description,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (package.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'БЕСПЛАТНО',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        else
                          Text(
                            '\$${package.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (!package.isFree)
                          Text(
                            '/месяц',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Stats
                Row(
                  children: [
                    _StatItem(
                      icon: Icons.map,
                      label: '${package.statesIncluded.length} ${package.statesIncluded.contains("ALL") ? "штатов" : "штат"}',
                    ),
                    const SizedBox(width: 16),
                    _StatItem(
                      icon: Icons.folder,
                      label: '${(package.recordCount / 1000).toStringAsFixed(1)}K записей',
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Features preview (first 3)
                ...package.features.take(3).map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),
                
                if (package.features.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${package.features.length - 3} еще...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Purchase button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPurchase,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      package.isFree ? 'Активировать' : 'Купить пакет',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Popular badge
          if (package.isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.deepOrange.shade600,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'ПОПУЛЯРНЫЙ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// Data package model
class DataPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> features;
  final bool isFree;
  final bool isPopular;
  final List<String> statesIncluded;
  final int recordCount;

  DataPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.features,
    required this.isFree,
    required this.isPopular,
    required this.statesIncluded,
    required this.recordCount,
  });
}

