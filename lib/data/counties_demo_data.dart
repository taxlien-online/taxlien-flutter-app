import 'dart:convert';

/// Demo counties data for TaxLien.online mobile app
/// Includes all counties from states with tax lien programs
class TaxLienCountiesDemoData {
  static const String _countiesJson = '''
{
  "counties": {
    "FL": [
      {"name": "Alachua", "code": "alachua", "population": 278000, "area": 875},
      {"name": "Baker", "code": "baker", "population": 28000, "area": 585},
      {"name": "Bay", "code": "bay", "population": 175000, "area": 1036},
      {"name": "Bradford", "code": "bradford", "population": 28000, "area": 300},
      {"name": "Brevard", "code": "brevard", "population": 600000, "area": 1018},
      {"name": "Broward", "code": "broward", "population": 1950000, "area": 1208},
      {"name": "Calhoun", "code": "calhoun", "population": 14000, "area": 567},
      {"name": "Charlotte", "code": "charlotte", "population": 190000, "area": 680},
      {"name": "Citrus", "code": "citrus", "population": 150000, "area": 582},
      {"name": "Clay", "code": "clay", "population": 220000, "area": 604},
      {"name": "Collier", "code": "collier", "population": 380000, "area": 2025},
      {"name": "Columbia", "code": "columbia", "population": 70000, "area": 797},
      {"name": "DeSoto", "code": "desoto", "population": 38000, "area": 637},
      {"name": "Dixie", "code": "dixie", "population": 17000, "area": 704},
      {"name": "Duval", "code": "duval", "population": 950000, "area": 918},
      {"name": "Escambia", "code": "escambia", "population": 320000, "area": 666},
      {"name": "Flagler", "code": "flagler", "population": 110000, "area": 485},
      {"name": "Franklin", "code": "franklin", "population": 12000, "area": 545},
      {"name": "Gadsden", "code": "gadsden", "population": 46000, "area": 529},
      {"name": "Gilchrist", "code": "gilchrist", "population": 18000, "area": 350},
      {"name": "Glades", "code": "glades", "population": 12000, "area": 987},
      {"name": "Gulf", "code": "gulf", "population": 15000, "area": 564},
      {"name": "Hamilton", "code": "hamilton", "population": 14000, "area": 519},
      {"name": "Hardee", "code": "hardee", "population": 27000, "area": 637},
      {"name": "Hendry", "code": "hendry", "population": 40000, "area": 1153},
      {"name": "Hernando", "code": "hernando", "population": 190000, "area": 473},
      {"name": "Highlands", "code": "highlands", "population": 100000, "area": 1027},
      {"name": "Hillsborough", "code": "hillsborough", "population": 1450000, "area": 1059},
      {"name": "Holmes", "code": "holmes", "population": 20000, "area": 494},
      {"name": "Indian River", "code": "indian_river", "population": 160000, "area": 503},
      {"name": "Jackson", "code": "jackson", "population": 49000, "area": 916},
      {"name": "Jefferson", "code": "jefferson", "population": 14000, "area": 598},
      {"name": "Lafayette", "code": "lafayette", "population": 8500, "area": 543},
      {"name": "Lake", "code": "lake", "population": 360000, "area": 953},
      {"name": "Lee", "code": "lee", "population": 760000, "area": 804},
      {"name": "Leon", "code": "leon", "population": 290000, "area": 702},
      {"name": "Levy", "code": "levy", "population": 42000, "area": 1129},
      {"name": "Liberty", "code": "liberty", "population": 8500, "area": 836},
      {"name": "Madison", "code": "madison", "population": 19000, "area": 574},
      {"name": "Manatee", "code": "manatee", "population": 400000, "area": 743},
      {"name": "Marion", "code": "marion", "population": 360000, "area": 1638},
      {"name": "Martin", "code": "martin", "population": 160000, "area": 555},
      {"name": "Miami-Dade", "code": "miami_dade", "population": 2700000, "area": 1898},
      {"name": "Monroe", "code": "monroe", "population": 75000, "area": 1009},
      {"name": "Nassau", "code": "nassau", "population": 90000, "area": 726},
      {"name": "Okaloosa", "code": "okaloosa", "population": 210000, "area": 956},
      {"name": "Okeechobee", "code": "okeechobee", "population": 40000, "area": 774},
      {"name": "Orange", "code": "orange", "population": 1400000, "area": 907},
      {"name": "Osceola", "code": "osceola", "population": 380000, "area": 1322},
      {"name": "Palm Beach", "code": "palm_beach", "population": 1500000, "area": 1971},
      {"name": "Pasco", "code": "pasco", "population": 540000, "area": 747},
      {"name": "Pinellas", "code": "pinellas", "population": 980000, "area": 274},
      {"name": "Polk", "code": "polk", "population": 720000, "area": 1866},
      {"name": "Putnam", "code": "putnam", "population": 74000, "area": 727},
      {"name": "Santa Rosa", "code": "santa_rosa", "population": 180000, "area": 1013},
      {"name": "Sarasota", "code": "sarasota", "population": 430000, "area": 725},
      {"name": "Seminole", "code": "seminole", "population": 470000, "area": 345},
      {"name": "St. Johns", "code": "st_johns", "population": 260000, "area": 609},
      {"name": "St. Lucie", "code": "st_lucie", "population": 330000, "area": 572},
      {"name": "Sumter", "code": "sumter", "population": 130000, "area": 558},
      {"name": "Suwannee", "code": "suwannee", "population": 43000, "area": 689},
      {"name": "Taylor", "code": "taylor", "population": 22000, "area": 1047},
      {"name": "Union", "code": "union", "population": 15000, "area": 240},
      {"name": "Volusia", "code": "volusia", "population": 550000, "area": 1101},
      {"name": "Wakulla", "code": "wakulla", "population": 33000, "area": 607},
      {"name": "Walton", "code": "walton", "population": 75000, "area": 1055},
      {"name": "Washington", "code": "washington", "population": 25000, "area": 580}
    ],
    "TX": [
      {"name": "Harris", "code": "harris", "population": 4700000, "area": 1778},
      {"name": "Dallas", "code": "dallas", "population": 2600000, "area": 880},
      {"name": "Tarrant", "code": "tarrant", "population": 2100000, "area": 864},
      {"name": "Bexar", "code": "bexar", "population": 2000000, "area": 1246},
      {"name": "Travis", "code": "travis", "population": 1300000, "area": 989},
      {"name": "Collin", "code": "collin", "population": 1000000, "area": 848},
      {"name": "Fort Bend", "code": "fort_bend", "population": 820000, "area": 875},
      {"name": "Montgomery", "code": "montgomery", "population": 600000, "area": 1040},
      {"name": "Hidalgo", "code": "hidalgo", "population": 870000, "area": 1569},
      {"name": "El Paso", "code": "el_paso", "population": 840000, "area": 1013},
      {"name": "Cameron", "code": "cameron", "population": 420000, "area": 906},
      {"name": "Galveston", "code": "galveston", "population": 340000, "area": 399},
      {"name": "Brazoria", "code": "brazoria", "population": 370000, "area": 1387},
      {"name": "Jefferson", "code": "jefferson", "population": 250000, "area": 876},
      {"name": "Webb", "code": "webb", "population": 270000, "area": 3361},
      {"name": "Nueces", "code": "nueces", "population": 360000, "area": 836},
      {"name": "Bell", "code": "bell", "population": 370000, "area": 1059},
      {"name": "McLennan", "code": "mclennan", "population": 260000, "area": 1042},
      {"name": "Smith", "code": "smith", "population": 230000, "area": 923},
      {"name": "Brazos", "code": "brazos", "population": 230000, "area": 586}
    ],
    "CA": [
      {"name": "Los Angeles", "code": "los_angeles", "population": 10000000, "area": 4751},
      {"name": "San Diego", "code": "san_diego", "population": 3300000, "area": 4205},
      {"name": "Orange", "code": "orange", "population": 3200000, "area": 789},
      {"name": "Riverside", "code": "riverside", "population": 2400000, "area": 7207},
      {"name": "San Bernardino", "code": "san_bernardino", "population": 2200000, "area": 20105},
      {"name": "Santa Clara", "code": "santa_clara", "population": 1900000, "area": 1291},
      {"name": "Alameda", "code": "alameda", "population": 1700000, "area": 739},
      {"name": "Sacramento", "code": "sacramento", "population": 1600000, "area": 965},
      {"name": "Contra Costa", "code": "contra_costa", "population": 1200000, "area": 720},
      {"name": "Fresno", "code": "fresno", "population": 1000000, "area": 5961},
      {"name": "Kern", "code": "kern", "population": 900000, "area": 8139},
      {"name": "Ventura", "code": "ventura", "population": 850000, "area": 1843},
      {"name": "San Francisco", "code": "san_francisco", "population": 870000, "area": 47},
      {"name": "Stanislaus", "code": "stanislaus", "population": 550000, "area": 1495},
      {"name": "Tulare", "code": "tulare", "population": 470000, "area": 4832},
      {"name": "Santa Barbara", "code": "santa_barbara", "population": 450000, "area": 2739},
      {"name": "San Mateo", "code": "san_mateo", "population": 770000, "area": 448},
      {"name": "Marin", "code": "marin", "population": 260000, "area": 520},
      {"name": "Butte", "code": "butte", "population": 220000, "area": 1647},
      {"name": "Shasta", "code": "shasta", "population": 180000, "area": 3785}
    ],
    "NY": [
      {"name": "Kings", "code": "kings", "population": 2700000, "area": 71},
      {"name": "Queens", "code": "queens", "population": 2400000, "area": 109},
      {"name": "New York", "code": "new_york", "population": 1700000, "area": 23},
      {"name": "Suffolk", "code": "suffolk", "population": 1500000, "area": 912},
      {"name": "Bronx", "code": "bronx", "population": 1400000, "area": 42},
      {"name": "Nassau", "code": "nassau", "population": 1400000, "area": 285},
      {"name": "Westchester", "code": "westchester", "population": 1000000, "area": 433},
      {"name": "Erie", "code": "erie", "population": 950000, "area": 1044},
      {"name": "Monroe", "code": "monroe", "population": 750000, "area": 657},
      {"name": "Onondaga", "code": "onondaga", "population": 470000, "area": 780},
      {"name": "Orange", "code": "orange", "population": 390000, "area": 816},
      {"name": "Richmond", "code": "richmond", "population": 480000, "area": 58},
      {"name": "Rockland", "code": "rockland", "population": 330000, "area": 174},
      {"name": "Albany", "code": "albany", "population": 310000, "area": 533},
      {"name": "Dutchess", "code": "dutchess", "population": 300000, "area": 796},
      {"name": "Saratoga", "code": "saratoga", "population": 230000, "area": 810},
      {"name": "Oneida", "code": "oneida", "population": 230000, "area": 1212},
      {"name": "Niagara", "code": "niagara", "population": 220000, "area": 522},
      {"name": "Broome", "code": "broome", "population": 200000, "area": 715},
      {"name": "Ulster", "code": "ulster", "population": 180000, "area": 1131}
    ],
    "AZ": [
      {"name": "Maricopa", "code": "maricopa", "population": 4500000, "area": 9203},
      {"name": "Pima", "code": "pima", "population": 1000000, "area": 9189},
      {"name": "Pinal", "code": "pinal", "population": 460000, "area": 5374},
      {"name": "Yavapai", "code": "yavapai", "population": 240000, "area": 8128},
      {"name": "Mohave", "code": "mohave", "population": 210000, "area": 13311},
      {"name": "Coconino", "code": "coconino", "population": 140000, "area": 18619},
      {"name": "Cochise", "code": "cochise", "population": 130000, "area": 6219},
      {"name": "Navajo", "code": "navajo", "population": 110000, "area": 9959},
      {"name": "Apache", "code": "apache", "population": 72000, "area": 11218},
      {"name": "Gila", "code": "gila", "population": 54000, "area": 4796},
      {"name": "Yuma", "code": "yuma", "population": 210000, "area": 5519},
      {"name": "Santa Cruz", "code": "santa_cruz", "population": 47000, "area": 1238},
      {"name": "Graham", "code": "graham", "population": 38000, "area": 4641},
      {"name": "La Paz", "code": "la_paz", "population": 21000, "area": 4513},
      {"name": "Greenlee", "code": "greenlee", "population": 9500, "area": 1848}
    ],
    "GA": [
      {"name": "Fulton", "code": "fulton", "population": 1100000, "area": 529},
      {"name": "Gwinnett", "code": "gwinnett", "population": 950000, "area": 437},
      {"name": "DeKalb", "code": "dekalb", "population": 760000, "area": 268},
      {"name": "Cobb", "code": "cobb", "population": 760000, "area": 340},
      {"name": "Clayton", "code": "clayton", "population": 290000, "area": 143},
      {"name": "Chatham", "code": "chatham", "population": 290000, "area": 426},
      {"name": "Forsyth", "code": "forsyth", "population": 250000, "area": 226},
      {"name": "Henry", "code": "henry", "population": 240000, "area": 323},
      {"name": "Cherokee", "code": "cherokee", "population": 260000, "area": 424},
      {"name": "Hall", "code": "hall", "population": 200000, "area": 394},
      {"name": "Muscogee", "code": "muscogee", "population": 200000, "area": 216},
      {"name": "Richmond", "code": "richmond", "population": 200000, "area": 324},
      {"name": "Bibb", "code": "bibb", "population": 160000, "area": 250},
      {"name": "Houston", "code": "houston", "population": 160000, "area": 377},
      {"name": "Lowndes", "code": "lowndes", "population": 120000, "area": 496},
      {"name": "Dougherty", "code": "dougherty", "population": 90000, "area": 329},
      {"name": "Clarke", "code": "clarke", "population": 130000, "area": 121},
      {"name": "Columbia", "code": "columbia", "population": 160000, "area": 290},
      {"name": "Coweta", "code": "coweta", "population": 150000, "area": 441},
      {"name": "Paulding", "code": "paulding", "population": 170000, "area": 314}
    ]
  }
}
''';

  static Map<String, dynamic> get countiesData => json.decode(_countiesJson);

  /// Get all counties for a specific state
  static List<Map<String, dynamic>> getCountiesByState(String stateCode) {
    final counties = countiesData['counties'] as Map<String, dynamic>?;
    if (counties == null || !counties.containsKey(stateCode)) {
      return [];
    }
    return List<Map<String, dynamic>>.from(counties[stateCode]);
  }

  /// Get all states with county data
  static List<String> get statesWithCountyData {
    final counties = countiesData['counties'] as Map<String, dynamic>?;
    return counties?.keys.toList() ?? [];
  }

  /// Get county by name and state
  static Map<String, dynamic>? getCountyByName(
      String stateCode, String countyName) {
    final counties = getCountiesByState(stateCode);
    try {
      return counties.firstWhere((county) =>
          county['name'].toString().toLowerCase() == countyName.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// Get county by code and state
  static Map<String, dynamic>? getCountyByCode(
      String stateCode, String countyCode) {
    final counties = getCountiesByState(stateCode);
    try {
      return counties.firstWhere((county) =>
          county['code'].toString().toLowerCase() == countyCode.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// Get counties by population range
  static List<Map<String, dynamic>> getCountiesByPopulationRange(
      String stateCode, int minPopulation, int maxPopulation) {
    return getCountiesByState(stateCode).where((county) {
      final population = county['population'] as int? ?? 0;
      return population >= minPopulation && population <= maxPopulation;
    }).toList();
  }

  /// Get counties by area range
  static List<Map<String, dynamic>> getCountiesByAreaRange(
      String stateCode, double minArea, double maxArea) {
    return getCountiesByState(stateCode).where((county) {
      final area = (county['area'] as num).toDouble();
      return area >= minArea && area <= maxArea;
    }).toList();
  }

  /// Get largest counties by population
  static List<Map<String, dynamic>> getLargestCountiesByPopulation(
      String stateCode, int limit) {
    final counties = getCountiesByState(stateCode);
    counties.sort(
        (a, b) => (b['population'] as int).compareTo(a['population'] as int));
    return counties.take(limit).toList();
  }

  /// Get smallest counties by population
  static List<Map<String, dynamic>> getSmallestCountiesByPopulation(
      String stateCode, int limit) {
    final counties = getCountiesByState(stateCode);
    counties.sort(
        (a, b) => (a['population'] as int).compareTo(b['population'] as int));
    return counties.take(limit).toList();
  }

  /// Get total population for a state
  static int getTotalPopulationForState(String stateCode) {
    final counties = getCountiesByState(stateCode);
    return counties.fold(
        0, (sum, county) => sum + (county['population'] as int? ?? 0));
  }

  /// Get total area for a state
  static double getTotalAreaForState(String stateCode) {
    final counties = getCountiesByState(stateCode);
    return counties.fold(
        0.0, (sum, county) => sum + (county['area'] as num? ?? 0).toDouble());
  }

  /// Get average population density for a state
  static double getAveragePopulationDensityForState(String stateCode) {
    final totalPopulation = getTotalPopulationForState(stateCode);
    final totalArea = getTotalAreaForState(stateCode);
    return totalArea > 0 ? totalPopulation / totalArea : 0.0;
  }
}
