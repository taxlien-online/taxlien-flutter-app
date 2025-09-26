import 'historical_data.dart';
import 'demo_data.dart';

/// Initial preload data for TaxLien.online mobile app
/// Combines historical data from tax24.sql with demo data for first app launch
/// This provides offline functionality and initial data for new users
class InitialPreloadData {
  /// Get combined initial data for app preload
  static Map<String, dynamic> getInitialPreloadData() {
    return {
      'app_info': {
        'version': '1.0.0',
        'preload_date': DateTime.now().toIso8601String(),
        'data_source': 'tax24.sql + demo_data',
        'description': 'Initial offline data for TaxLien.online mobile app',
        'features': [
          'Historical tax lien data from Florida counties (2024)',
          'Demo products and categories',
          'Sample customer data',
          'Investment analytics and market trends',
          'Offline browsing capabilities'
        ]
      },
      'historical_data': TaxLienHistoricalData.historicalData,
      'demo_data': TaxLienDemoData.demoData,
      'combined_products': _getCombinedProducts(),
      'combined_categories': _getCombinedCategories(),
      'investment_opportunities': _getInvestmentOpportunities(),
      'market_insights': _getMarketInsights(),
      'county_overview': _getCountyOverview()
    };
  }

  /// Get combined products from historical and demo data
  static List<Map<String, dynamic>> _getCombinedProducts() {
    final demoProducts = TaxLienDemoData.demoProducts;
    final historicalLiens = TaxLienHistoricalData.getSampleTaxLiens();

    // Convert historical liens to product format
    final historicalProducts =
        historicalLiens.map((lien) => _convertLienToProduct(lien)).toList();

    // Combine and deduplicate
    final allProducts = [...demoProducts, ...historicalProducts];
    return _deduplicateProducts(allProducts);
  }

  /// Get combined categories with historical data integration
  static List<Map<String, dynamic>> _getCombinedCategories() {
    final demoCategories = TaxLienDemoData.demoCategories;
    final historicalCounties = TaxLienHistoricalData.getFlorida2024Counties();

    // Add historical county categories
    final historicalCategories = historicalCounties
        .map((county) => _convertCountyToCategory(county))
        .toList();

    return [...demoCategories, ...historicalCategories];
  }

  /// Get investment opportunities summary
  static Map<String, dynamic> _getInvestmentOpportunities() {
    final analytics =
        TaxLienHistoricalData.getInvestmentAnalytics('2024', 'FL');
    final trends = TaxLienHistoricalData.getMarketTrends('2024', 'FL');

    return {
      'total_opportunities': TaxLienHistoricalData.getSampleTaxLiens().length,
      'total_investment_amount':
          analytics?['total_investment_opportunity'] ?? 0.0,
      'average_investment': analytics?['average_investment'] ?? 0.0,
      'interest_rate': analytics?['average_interest_rate'] ?? 0.0,
      'risk_level': analytics?['risk_assessment'] ?? 'Medium',
      'liquidity': analytics?['liquidity'] ?? 'High',
      'counties_available':
          TaxLienHistoricalData.getFlorida2024Counties().length,
      'property_types': trends?['popular_property_types'] ?? [],
      'redemption_rate': trends?['average_redemption_rate'] ?? '75%'
    };
  }

  /// Get market insights for investment decisions
  static Map<String, dynamic> _getMarketInsights() {
    return TaxLienHistoricalData.getMarketInsights('2024', 'FL');
  }

  /// Get county overview with statistics
  static Map<String, dynamic> _getCountyOverview() {
    final counties = TaxLienHistoricalData.getFlorida2024Counties();
    final countyStats = counties.map((county) {
      final code = county['code']?.toString().toLowerCase() ?? '';
      final stats = TaxLienHistoricalData.getCountyStatistics(code);
      return {
        'county_info': county,
        'statistics': stats,
        'performance_metrics':
            TaxLienHistoricalData.getCountyPerformanceMetrics(code)
      };
    }).toList();

    return {
      'total_counties': counties.length,
      'counties': countyStats,
      'summary': {
        'total_properties': countyStats.fold<int>(
            0,
            (sum, county) =>
                sum + (county['statistics']?['total_properties'] as int? ?? 0)),
        'total_assessed_value': countyStats.fold<double>(
            0.0,
            (sum, county) =>
                sum +
                (county['statistics']?['total_assessed_value'] as double? ??
                    0.0)),
        'total_tax_amount': countyStats.fold<double>(
            0.0,
            (sum, county) =>
                sum +
                (county['statistics']?['total_tax_amount'] as double? ?? 0.0))
      }
    };
  }

  /// Convert historical lien to product format
  static Map<String, dynamic> _convertLienToProduct(Map<String, dynamic> lien) {
    return {
      'id': lien['id'],
      'sku': lien['sku'],
      'name': lien['name'],
      'type_id': 'tax_lien',
      'attribute_set_id': 4,
      'price': lien['tax_amount'],
      'status': 1,
      'visibility': 4,
      'weight': 0,
      'created_at': lien['auction_date'],
      'updated_at': lien['auction_date'],
      'extension_attributes': {
        'stock_item': {
          'item_id': lien['id'],
          'product_id': lien['id'],
          'stock_id': 1,
          'qty': 1,
          'is_in_stock': true,
          'is_qty_decimal': false,
          'use_config_min_qty': true,
          'min_qty': 0,
          'use_config_min_sale_qty': 1,
          'min_sale_qty': 1,
          'use_config_max_sale_qty': true,
          'max_sale_qty': 10000,
          'use_config_backorders': true,
          'backorders': 0,
          'use_config_notify_stock_qty': true,
          'notify_stock_qty': 1,
          'use_config_qty_increments': true,
          'qty_increments': 1,
          'use_config_enable_qty_inc': true,
          'enable_qty_increments': false,
          'use_config_manage_stock': true,
          'manage_stock': true,
          'low_stock_date': null,
          'is_decimal_divided': false,
          'stock_status_changed_auto': 0
        }
      },
      'custom_attributes': [
        {'attribute_code': 'parcel_id', 'value': lien['parcel_id']},
        {
          'attribute_code': 'property_address',
          'value': lien['property_address']
        },
        {'attribute_code': 'county', 'value': lien['county']},
        {'attribute_code': 'state', 'value': lien['state']},
        {'attribute_code': 'owner_name', 'value': lien['owner_name']},
        {
          'attribute_code': 'assessed_value',
          'value': lien['assessed_value'].toString()
        },
        {
          'attribute_code': 'tax_amount',
          'value': lien['tax_amount'].toString()
        },
        {
          'attribute_code': 'interest_rate',
          'value': lien['interest_rate'].toString()
        },
        {'attribute_code': 'auction_date', 'value': lien['auction_date']},
        {
          'attribute_code': 'redemption_deadline',
          'value': lien['redemption_deadline']
        },
        {'attribute_code': 'lien_status', 'value': lien['lien_status']},
        {'attribute_code': 'collection_year', 'value': lien['collection_year']},
        {'attribute_code': 'description', 'value': lien['description']},
        {
          'attribute_code': 'short_description',
          'value': lien['short_description']
        }
      ]
    };
  }

  /// Convert county to category format
  static Map<String, dynamic> _convertCountyToCategory(
      Map<String, dynamic> county) {
    return {
      'id': 'hist_${county['code']?.toString().toLowerCase()}',
      'name': '${county['name']} - 2024 Collection',
      'parent_id': 2, // Florida category
      'is_active': true,
      'position': 10,
      'level': 3,
      'path': '1/2/hist_${county['code']?.toString().toLowerCase()}',
      'available_sort_by': ['position', 'name', 'price'],
      'include_in_menu': true,
      'custom_attributes': [
        {
          'attribute_code': 'description',
          'value': '${county['description']} - Historical data from tax24.sql'
        },
        {'attribute_code': 'county_code', 'value': county['code']},
        {'attribute_code': 'collection_year', 'value': '2024'},
        {
          'attribute_code': 'total_liens',
          'value': county['total_liens'].toString()
        },
        {
          'attribute_code': 'total_value',
          'value': county['total_value'].toString()
        }
      ]
    };
  }

  /// Deduplicate products by SKU
  static List<Map<String, dynamic>> _deduplicateProducts(
      List<Map<String, dynamic>> products) {
    final seen = <String>{};
    return products.where((product) {
      final sku = product['sku']?.toString();
      if (sku == null || seen.contains(sku)) return false;
      seen.add(sku);
      return true;
    }).toList();
  }

  /// Get preload data summary for user display
  static Map<String, dynamic> getPreloadSummary() {
    return {
      'total_products': _getCombinedProducts().length,
      'total_categories': _getCombinedCategories().length,
      'historical_counties':
          TaxLienHistoricalData.getFlorida2024Counties().length,
      'investment_opportunities': _getInvestmentOpportunities(),
      'data_size_estimate': '~2.5MB',
      'last_updated': DateTime.now().toIso8601String(),
      'features_available': [
        'Browse tax liens offline',
        'View county statistics',
        'Analyze investment opportunities',
        'Access market insights',
        'Filter by property type and value'
      ]
    };
  }

  /// Get quick access data for app startup
  static Map<String, dynamic> getQuickAccessData() {
    return {
      'featured_products': _getCombinedProducts().take(5).toList(),
      'county_highlights':
          TaxLienHistoricalData.getFlorida2024Counties().take(3).toList(),
      'investment_summary': _getInvestmentOpportunities(),
      'recent_activity': [
        {
          'type': 'new_collection',
          'message': '2024 Florida Tax Lien Collection Available',
          'date': '2024-01-10',
          'counties': ['Polk', 'Dixie', 'Putnam']
        }
      ]
    };
  }

  /// Check if preload data is available
  static bool isPreloadDataAvailable() {
    try {
      final data = getInitialPreloadData();
      return data.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get data freshness info
  static Map<String, dynamic> getDataFreshness() {
    return {
      'historical_data_date': '2024-01-10',
      'demo_data_date': DateTime.now().toIso8601String(),
      'preload_generated': DateTime.now().toIso8601String(),
      'data_source': 'tax24.sql + demo_data.dart',
      'update_frequency': 'On app update',
      'offline_capable': true
    };
  }
}
