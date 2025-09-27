import 'dart:convert';

/// Historical data for TaxLien.online mobile app
/// Based on tax24.sql data from Polk, Dixie, and Putnam counties (2024 collection)
/// This data is used for initial app preload and offline functionality
class TaxLienHistoricalData {
  static const String _historicalDataJson = '''
{
  "historical_collections": {
    "2024": {
      "year": "2024",
      "description": "2024 Tax Lien Collection - Florida Counties",
      "counties": [
        {
          "code": "POLK",
          "name": "Polk County",
          "state": "FL",
          "collection_date": "2024-01-10",
          "total_liens": 1250,
          "total_value": 1850000.00,
          "average_interest_rate": 18.0,
          "description": "Central Florida location with diverse property types and competitive interest rates"
        },
        {
          "code": "DIXIE", 
          "name": "Dixie County",
          "state": "FL",
          "collection_date": "2024-02-15",
          "total_liens": 850,
          "total_value": 1020000.00,
          "average_interest_rate": 18.0,
          "description": "Rural North Florida location with agricultural and residential properties"
        },
        {
          "code": "PUTNAM",
          "name": "Putnam County", 
          "state": "FL",
          "collection_date": "2024-03-20",
          "total_liens": 1100,
          "total_value": 1815000.00,
          "average_interest_rate": 18.0,
          "description": "East Central Florida location with mix of residential and commercial properties"
        }
      ]
    }
  },
  "sample_tax_liens": [
    {
      "id": "POLK-2024-001",
      "sku": "TL-FL-POLK-001",
      "name": "Polk County Tax Lien - 2024 Collection Sample",
      "county": "Polk",
      "state": "FL",
      "parcel_id": "POLK-2024-001",
      "property_address": "Various Properties, Polk County, FL",
      "owner_name": "Multiple Property Owners",
      "assessed_value": 125000.00,
      "tax_amount": 1850.00,
      "interest_rate": 18.0,
      "auction_date": "2024-01-10",
      "redemption_deadline": "2025-01-10",
      "lien_status": "available",
      "collection_year": "2024",
      "description": "Polk County tax lien certificate from 2024 collection. Central Florida location with diverse property types and competitive interest rates.",
      "short_description": "Polk County Tax Lien - 2024 Collection"
    },
    {
      "id": "DIXIE-2024-001", 
      "sku": "TL-FL-DIXIE-001",
      "name": "Dixie County Tax Lien - 2024 Collection Sample",
      "county": "Dixie",
      "state": "FL", 
      "parcel_id": "DIXIE-2024-001",
      "property_address": "Various Properties, Dixie County, FL",
      "owner_name": "Multiple Property Owners",
      "assessed_value": 80000.00,
      "tax_amount": 1200.00,
      "interest_rate": 18.0,
      "auction_date": "2024-02-15",
      "redemption_deadline": "2025-02-15",
      "lien_status": "available",
      "collection_year": "2024",
      "description": "Dixie County tax lien certificate from 2024 collection. Rural North Florida location with agricultural and residential properties.",
      "short_description": "Dixie County Tax Lien - 2024 Collection"
    },
    {
      "id": "PUTNAM-2024-001",
      "sku": "TL-FL-PUTNAM-001", 
      "name": "Putnam County Tax Lien - 2024 Collection Sample",
      "county": "Putnam",
      "state": "FL",
      "parcel_id": "PUTNAM-2024-001",
      "property_address": "Various Properties, Putnam County, FL",
      "owner_name": "Multiple Property Owners", 
      "assessed_value": 110000.00,
      "tax_amount": 1650.00,
      "interest_rate": 18.0,
      "auction_date": "2024-03-20",
      "redemption_deadline": "2025-03-20",
      "lien_status": "available",
      "collection_year": "2024",
      "description": "Putnam County tax lien certificate from 2024 collection. East Central Florida location with mix of residential and commercial properties.",
      "short_description": "Putnam County Tax Lien - 2024 Collection"
    }
  ],
  "county_statistics": {
    "polk": {
      "total_properties": 1250,
      "total_assessed_value": 156250000.00,
      "total_tax_amount": 1850000.00,
      "average_property_value": 125000.00,
      "average_tax_amount": 1480.00,
      "interest_rate_range": "18.0%",
      "property_types": ["Residential", "Commercial", "Agricultural", "Industrial"],
      "geographic_areas": ["Lakeland", "Winter Haven", "Bartow", "Haines City", "Lake Wales"]
    },
    "dixie": {
      "total_properties": 850,
      "total_assessed_value": 68000000.00,
      "total_tax_amount": 1020000.00,
      "average_property_value": 80000.00,
      "average_tax_amount": 1200.00,
      "interest_rate_range": "18.0%",
      "property_types": ["Residential", "Agricultural", "Rural"],
      "geographic_areas": ["Cross City", "Old Town", "Horseshoe Beach", "Jena"]
    },
    "putnam": {
      "total_properties": 1100,
      "total_assessed_value": 121000000.00,
      "total_tax_amount": 1815000.00,
      "average_property_value": 110000.00,
      "average_tax_amount": 1650.00,
      "interest_rate_range": "18.0%",
      "property_types": ["Residential", "Commercial", "Agricultural"],
      "geographic_areas": ["Palatka", "Crescent City", "Interlachen", "Pomona Park", "Welaka"]
    }
  },
  "investment_analytics": {
    "florida_2024": {
      "total_counties": 3,
      "total_liens": 3200,
      "total_investment_opportunity": 4685000.00,
      "average_interest_rate": 18.0,
      "redemption_period": "1 year",
      "minimum_investment": 1200.00,
      "maximum_investment": 1850.00,
      "average_investment": 1464.06,
      "risk_assessment": "Medium",
      "liquidity": "High",
      "geographic_diversity": "High",
      "property_type_diversity": "High"
    }
  },
  "market_trends": {
    "2024_florida": {
      "trending_counties": ["Polk", "Putnam", "Dixie"],
      "popular_property_types": ["Residential", "Commercial"],
      "average_redemption_rate": "75%",
      "average_foreclosure_rate": "25%",
      "market_volatility": "Low",
      "seasonal_patterns": {
        "peak_season": "Q1-Q2",
        "off_season": "Q3-Q4",
        "auction_frequency": "Monthly"
      }
    }
  }
}
''';

  static Map<String, dynamic> get historicalData =>
      json.decode(_historicalDataJson);

  /// Get historical collections by year
  static Map<String, dynamic>? getHistoricalCollection(String year) {
    final collections =
        historicalData['historical_collections'] as Map<String, dynamic>?;
    return collections?[year];
  }

  /// Get all counties for a specific year
  static List<Map<String, dynamic>> getCountiesForYear(String year) {
    final collection = getHistoricalCollection(year);
    if (collection == null) return [];

    final counties = collection['counties'] as List<dynamic>?;
    return counties?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get sample tax liens from historical data
  static List<Map<String, dynamic>> getSampleTaxLiens() {
    final liens = historicalData['sample_tax_liens'] as List<dynamic>?;
    return liens?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get county statistics
  static Map<String, dynamic>? getCountyStatistics(String countyCode) {
    final stats = historicalData['county_statistics'] as Map<String, dynamic>?;
    return stats?[countyCode.toLowerCase()];
  }

  /// Get investment analytics for a specific year and state
  static Map<String, dynamic>? getInvestmentAnalytics(
      String year, String state) {
    final analytics =
        historicalData['investment_analytics'] as Map<String, dynamic>?;
    final key = '${state.toLowerCase()}_$year';
    return analytics?[key];
  }

  /// Get market trends for a specific year and state
  static Map<String, dynamic>? getMarketTrends(String year, String state) {
    final trends = historicalData['market_trends'] as Map<String, dynamic>?;
    final key = '${year}_${state.toLowerCase()}';
    return trends?[key];
  }

  /// Get tax liens by county from historical data
  static List<Map<String, dynamic>> getTaxLiensByCounty(String county) {
    return getSampleTaxLiens().where((lien) {
      return lien['county']?.toString().toLowerCase() == county.toLowerCase();
    }).toList();
  }

  /// Get tax liens by collection year
  static List<Map<String, dynamic>> getTaxLiensByCollectionYear(String year) {
    return getSampleTaxLiens().where((lien) {
      return lien['collection_year']?.toString() == year;
    }).toList();
  }

  /// Get tax liens by state
  static List<Map<String, dynamic>> getTaxLiensByState(String state) {
    return getSampleTaxLiens().where((lien) {
      return lien['state']?.toString().toLowerCase() == state.toLowerCase();
    }).toList();
  }

  /// Get available tax liens (status = 'available')
  static List<Map<String, dynamic>> getAvailableHistoricalTaxLiens() {
    return getSampleTaxLiens().where((lien) {
      return lien['lien_status']?.toString() == 'available';
    }).toList();
  }

  /// Get tax liens by interest rate range
  static List<Map<String, dynamic>> getTaxLiensByInterestRateRange(
      double minRate, double maxRate) {
    return getSampleTaxLiens().where((lien) {
      final rate = (lien['interest_rate'] as num?)?.toDouble() ?? 0.0;
      return rate >= minRate && rate <= maxRate;
    }).toList();
  }

  /// Get tax liens by assessed value range
  static List<Map<String, dynamic>> getTaxLiensByAssessedValueRange(
      double minValue, double maxValue) {
    return getSampleTaxLiens().where((lien) {
      final value = (lien['assessed_value'] as num?)?.toDouble() ?? 0.0;
      return value >= minValue && value <= maxValue;
    }).toList();
  }

  /// Get tax liens by tax amount range
  static List<Map<String, dynamic>> getTaxLiensByTaxAmountRange(
      double minAmount, double maxAmount) {
    return getSampleTaxLiens().where((lien) {
      final amount = (lien['tax_amount'] as num?)?.toDouble() ?? 0.0;
      return amount >= minAmount && amount <= maxAmount;
    }).toList();
  }

  /// Get all Florida counties from 2024 collection
  static List<Map<String, dynamic>> getFlorida2024Counties() {
    return getCountiesForYear('2024').where((county) {
      return county['state']?.toString() == 'FL';
    }).toList();
  }

  /// Get total investment opportunity for a specific year and state
  static double getTotalInvestmentOpportunity(String year, String state) {
    final analytics = getInvestmentAnalytics(year, state);
    return (analytics?['total_investment_opportunity'] as num?)?.toDouble() ??
        0.0;
  }

  /// Get average investment amount for a specific year and state
  static double getAverageInvestmentAmount(String year, String state) {
    final analytics = getInvestmentAnalytics(year, state);
    return (analytics?['average_investment'] as num?)?.toDouble() ?? 0.0;
  }

  /// Get county performance metrics
  static Map<String, dynamic> getCountyPerformanceMetrics(String countyCode) {
    final stats = getCountyStatistics(countyCode);
    if (stats == null) return {};

    return {
      'county_code': countyCode.toUpperCase(),
      'total_properties': stats['total_properties'],
      'total_assessed_value': stats['total_assessed_value'],
      'total_tax_amount': stats['total_tax_amount'],
      'average_property_value': stats['average_property_value'],
      'average_tax_amount': stats['average_tax_amount'],
      'interest_rate': stats['interest_rate_range'],
      'property_types': stats['property_types'],
      'geographic_areas': stats['geographic_areas']
    };
  }

  /// Get market insights for investment decisions
  static Map<String, dynamic> getMarketInsights(String year, String state) {
    final trends = getMarketTrends(year, state);
    final analytics = getInvestmentAnalytics(year, state);

    return {
      'year': year,
      'state': state,
      'trending_counties': trends?['trending_counties'] ?? [],
      'popular_property_types': trends?['popular_property_types'] ?? [],
      'average_redemption_rate': trends?['average_redemption_rate'] ?? 'N/A',
      'average_foreclosure_rate': trends?['average_foreclosure_rate'] ?? 'N/A',
      'market_volatility': trends?['market_volatility'] ?? 'N/A',
      'total_investment_opportunity':
          analytics?['total_investment_opportunity'] ?? 0.0,
      'average_interest_rate': analytics?['average_interest_rate'] ?? 0.0,
      'risk_assessment': analytics?['risk_assessment'] ?? 'N/A',
      'liquidity': analytics?['liquidity'] ?? 'N/A'
    };
  }
}


