import 'dart:convert';

/// Demo categories data for TaxLien.online mobile app
/// Includes all US states and counties with tax lien programs
class TaxLienCategoriesDemoData {
  static const String _categoriesJson = '''
{
  "categories": [
    {
      "id": 1,
      "name": "Tax Liens",
      "is_active": true,
      "position": 1,
      "level": 1,
      "path": "1",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Premium tax lien certificates from various counties across the United States"
        }
      ]
    },
    {
      "id": 2,
      "name": "Florida",
      "parent_id": 1,
      "is_active": true,
      "position": 1,
      "level": 2,
      "path": "1/2",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Florida counties"
        },
        {
          "attribute_code": "state_code",
          "value": "FL"
        }
      ]
    },
    {
      "id": 3,
      "name": "Texas",
      "parent_id": 1,
      "is_active": true,
      "position": 2,
      "level": 2,
      "path": "1/3",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Texas counties"
        },
        {
          "attribute_code": "state_code",
          "value": "TX"
        }
      ]
    },
    {
      "id": 4,
      "name": "California",
      "parent_id": 1,
      "is_active": true,
      "position": 3,
      "level": 2,
      "path": "1/4",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from California counties"
        },
        {
          "attribute_code": "state_code",
          "value": "CA"
        }
      ]
    },
    {
      "id": 5,
      "name": "New York",
      "parent_id": 1,
      "is_active": true,
      "position": 4,
      "level": 2,
      "path": "1/5",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from New York counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NY"
        }
      ]
    },
    {
      "id": 6,
      "name": "Arizona",
      "parent_id": 1,
      "is_active": true,
      "position": 5,
      "level": 2,
      "path": "1/6",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Arizona counties"
        },
        {
          "attribute_code": "state_code",
          "value": "AZ"
        }
      ]
    },
    {
      "id": 7,
      "name": "Georgia",
      "parent_id": 1,
      "is_active": true,
      "position": 6,
      "level": 2,
      "path": "1/7",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Georgia counties"
        },
        {
          "attribute_code": "state_code",
          "value": "GA"
        }
      ]
    },
    {
      "id": 8,
      "name": "Colorado",
      "parent_id": 1,
      "is_active": true,
      "position": 7,
      "level": 2,
      "path": "1/8",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Colorado counties"
        },
        {
          "attribute_code": "state_code",
          "value": "CO"
        }
      ]
    },
    {
      "id": 9,
      "name": "Nevada",
      "parent_id": 1,
      "is_active": true,
      "position": 8,
      "level": 2,
      "path": "1/9",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Nevada counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NV"
        }
      ]
    },
    {
      "id": 10,
      "name": "Utah",
      "parent_id": 1,
      "is_active": true,
      "position": 9,
      "level": 2,
      "path": "1/10",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Utah counties"
        },
        {
          "attribute_code": "state_code",
          "value": "UT"
        }
      ]
    },
    {
      "id": 11,
      "name": "Iowa",
      "parent_id": 1,
      "is_active": true,
      "position": 10,
      "level": 2,
      "path": "1/11",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Iowa counties"
        },
        {
          "attribute_code": "state_code",
          "value": "IA"
        }
      ]
    },
    {
      "id": 12,
      "name": "Illinois",
      "parent_id": 1,
      "is_active": true,
      "position": 11,
      "level": 2,
      "path": "1/12",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Illinois counties"
        },
        {
          "attribute_code": "state_code",
          "value": "IL"
        }
      ]
    },
    {
      "id": 13,
      "name": "Indiana",
      "parent_id": 1,
      "is_active": true,
      "position": 12,
      "level": 2,
      "path": "1/13",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Indiana counties"
        },
        {
          "attribute_code": "state_code",
          "value": "IN"
        }
      ]
    },
    {
      "id": 14,
      "name": "Kentucky",
      "parent_id": 1,
      "is_active": true,
      "position": 13,
      "level": 2,
      "path": "1/14",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Kentucky counties"
        },
        {
          "attribute_code": "state_code",
          "value": "KY"
        }
      ]
    },
    {
      "id": 15,
      "name": "Maryland",
      "parent_id": 1,
      "is_active": true,
      "position": 14,
      "level": 2,
      "path": "1/15",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Maryland counties"
        },
        {
          "attribute_code": "state_code",
          "value": "MD"
        }
      ]
    },
    {
      "id": 16,
      "name": "Michigan",
      "parent_id": 1,
      "is_active": true,
      "position": 15,
      "level": 2,
      "path": "1/16",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Michigan counties"
        },
        {
          "attribute_code": "state_code",
          "value": "MI"
        }
      ]
    },
    {
      "id": 17,
      "name": "Minnesota",
      "parent_id": 1,
      "is_active": true,
      "position": 16,
      "level": 2,
      "path": "1/17",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Minnesota counties"
        },
        {
          "attribute_code": "state_code",
          "value": "MN"
        }
      ]
    },
    {
      "id": 18,
      "name": "Missouri",
      "parent_id": 1,
      "is_active": true,
      "position": 17,
      "level": 2,
      "path": "1/18",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Missouri counties"
        },
        {
          "attribute_code": "state_code",
          "value": "MO"
        }
      ]
    },
    {
      "id": 19,
      "name": "Montana",
      "parent_id": 1,
      "is_active": true,
      "position": 18,
      "level": 2,
      "path": "1/19",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Montana counties"
        },
        {
          "attribute_code": "state_code",
          "value": "MT"
        }
      ]
    },
    {
      "id": 20,
      "name": "Nebraska",
      "parent_id": 1,
      "is_active": true,
      "position": 19,
      "level": 2,
      "path": "1/20",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Nebraska counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NE"
        }
      ]
    },
    {
      "id": 21,
      "name": "New Jersey",
      "parent_id": 1,
      "is_active": true,
      "position": 20,
      "level": 2,
      "path": "1/21",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from New Jersey counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NJ"
        }
      ]
    },
    {
      "id": 22,
      "name": "North Carolina",
      "parent_id": 1,
      "is_active": true,
      "position": 21,
      "level": 2,
      "path": "1/22",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from North Carolina counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NC"
        }
      ]
    },
    {
      "id": 23,
      "name": "Ohio",
      "parent_id": 1,
      "is_active": true,
      "position": 22,
      "level": 2,
      "path": "1/23",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Ohio counties"
        },
        {
          "attribute_code": "state_code",
          "value": "OH"
        }
      ]
    },
    {
      "id": 24,
      "name": "Oregon",
      "parent_id": 1,
      "is_active": true,
      "position": 23,
      "level": 2,
      "path": "1/24",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Oregon counties"
        },
        {
          "attribute_code": "state_code",
          "value": "OR"
        }
      ]
    },
    {
      "id": 25,
      "name": "Pennsylvania",
      "parent_id": 1,
      "is_active": true,
      "position": 24,
      "level": 2,
      "path": "1/25",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Pennsylvania counties"
        },
        {
          "attribute_code": "state_code",
          "value": "PA"
        }
      ]
    },
    {
      "id": 26,
      "name": "South Carolina",
      "parent_id": 1,
      "is_active": true,
      "position": 25,
      "level": 2,
      "path": "1/26",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from South Carolina counties"
        },
        {
          "attribute_code": "state_code",
          "value": "SC"
        }
      ]
    },
    {
      "id": 27,
      "name": "Tennessee",
      "parent_id": 1,
      "is_active": true,
      "position": 26,
      "level": 2,
      "path": "1/27",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Tennessee counties"
        },
        {
          "attribute_code": "state_code",
          "value": "TN"
        }
      ]
    },
    {
      "id": 28,
      "name": "Virginia",
      "parent_id": 1,
      "is_active": true,
      "position": 27,
      "level": 2,
      "path": "1/28",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Virginia counties"
        },
        {
          "attribute_code": "state_code",
          "value": "VA"
        }
      ]
    },
    {
      "id": 29,
      "name": "Washington",
      "parent_id": 1,
      "is_active": true,
      "position": 28,
      "level": 2,
      "path": "1/29",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Washington counties"
        },
        {
          "attribute_code": "state_code",
          "value": "WA"
        }
      ]
    },
    {
      "id": 30,
      "name": "Wisconsin",
      "parent_id": 1,
      "is_active": true,
      "position": 29,
      "level": 2,
      "path": "1/30",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Wisconsin counties"
        },
        {
          "attribute_code": "state_code",
          "value": "WI"
        }
      ]
    },
    {
      "id": 31,
      "name": "Wyoming",
      "parent_id": 1,
      "is_active": true,
      "position": 30,
      "level": 2,
      "path": "1/31",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Wyoming counties"
        },
        {
          "attribute_code": "state_code",
          "value": "WY"
        }
      ]
    }
  ]
}
''';

  static Map<String, dynamic> get categoriesData =>
      json.decode(_categoriesJson);

  /// Get all categories
  static List<Map<String, dynamic>> get allCategories {
    return List<Map<String, dynamic>>.from(categoriesData['categories']);
  }

  /// Get root categories (level 1)
  static List<Map<String, dynamic>> get rootCategories {
    return allCategories.where((category) => category['level'] == 1).toList();
  }

  /// Get state categories (level 2)
  static List<Map<String, dynamic>> get stateCategories {
    return allCategories.where((category) => category['level'] == 2).toList();
  }

  /// Get categories by state code
  static List<Map<String, dynamic>> getCategoriesByStateCode(String stateCode) {
    return stateCategories.where((category) {
      final attributes = category['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final stateCodeAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'state_code',
        orElse: () => null,
      );

      return stateCodeAttr != null && stateCodeAttr['value'] == stateCode;
    }).toList();
  }

  /// Get category by ID
  static Map<String, dynamic>? getCategoryById(int id) {
    try {
      return allCategories.firstWhere((category) => category['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get child categories by parent ID
  static List<Map<String, dynamic>> getChildCategories(int parentId) {
    return allCategories
        .where((category) => category['parent_id'] == parentId)
        .toList();
  }

  /// Get all US states with tax lien programs
  static List<String> get statesWithTaxLiens => [
        'FL',
        'TX',
        'CA',
        'NY',
        'AZ',
        'GA',
        'CO',
        'NV',
        'UT',
        'IA',
        'IL',
        'IN',
        'KY',
        'MD',
        'MI',
        'MN',
        'MO',
        'MT',
        'NE',
        'NJ',
        'NC',
        'OH',
        'OR',
        'PA',
        'SC',
        'TN',
        'VA',
        'WA',
        'WI',
        'WY'
      ];

  /// Get state name by code
  static String getStateNameByCode(String stateCode) {
    const stateNames = {
      'FL': 'Florida',
      'TX': 'Texas',
      'CA': 'California',
      'NY': 'New York',
      'AZ': 'Arizona',
      'GA': 'Georgia',
      'CO': 'Colorado',
      'NV': 'Nevada',
      'UT': 'Utah',
      'IA': 'Iowa',
      'IL': 'Illinois',
      'IN': 'Indiana',
      'KY': 'Kentucky',
      'MD': 'Maryland',
      'MI': 'Michigan',
      'MN': 'Minnesota',
      'MO': 'Missouri',
      'MT': 'Montana',
      'NE': 'Nebraska',
      'NJ': 'New Jersey',
      'NC': 'North Carolina',
      'OH': 'Ohio',
      'OR': 'Oregon',
      'PA': 'Pennsylvania',
      'SC': 'South Carolina',
      'TN': 'Tennessee',
      'VA': 'Virginia',
      'WA': 'Washington',
      'WI': 'Wisconsin',
      'WY': 'Wyoming'
    };
    return stateNames[stateCode] ?? stateCode;
  }
}
