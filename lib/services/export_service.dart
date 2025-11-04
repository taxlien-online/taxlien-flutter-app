import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/models/tax_lien_models.dart';
import '../services/tax_lien_service.dart';

/// Сервис для экспорта данных в CSV
class ExportService {
  /// Прибрежные округа Флориды
  static const List<String> floridaCoastalCounties = [
    'Monroe',
    'Miami-Dade',
    'Broward',
    'Palm Beach',
    'Martin',
    'St. Lucie',
    'St Lucie',
    'Indian River',
    'Brevard',
    'Volusia',
    'Flagler',
    'St. Johns',
    'St Johns',
    'Duval',
    'Nassau',
    'Escambia',
    'Santa Rosa',
    'Okaloosa',
    'Walton',
    'Bay',
    'Franklin',
    'Gulf',
    'Pinellas',
    'Hillsborough',
    'Hillsbrough',
    'Manatee',
    'Sarasota',
    'Charlotte',
    'Lee',
    'Collier',
  ];

  /// Экспортировать список tax liens в CSV
  static Future<String?> exportToCSV({
    required List<TaxLien> liens,
    required String filename,
  }) async {
    try {
      // Создать CSV данные
      final csvData = <List<String>>[];

      // Заголовки
      csvData.add([
        'Parcel ID',
        'County',
        'State',
        'Address',
        'City',
        'Zip Code',
        'Tax Amount',
        'Interest Rate (%)',
        'Assessed Value',
        'Estimated Value',
        'Property Type',
        'Owner',
        'Auction Date',
        'Status',
        'Location Type',
        'Redemption Deadline',
        'Years Delinquent',
      ]);

      // Данные
      for (final lien in liens) {
        csvData.add([
          lien.parcelId ?? '',
          lien.county,
          lien.state,
          lien.propertyAddress,
          lien.city ?? '',
          lien.zipCode ?? '',
          lien.taxAmount.toStringAsFixed(2),
          lien.interestRate.toStringAsFixed(2),
          lien.assessedValue.toStringAsFixed(2),
          lien.estimatedValue.toStringAsFixed(2),
          lien.propertyType,
          lien.owner ?? lien.ownerName ?? '',
          lien.auctionDate.toIso8601String(),
          lien.status,
          _getLocationType(lien.county),
          lien.redemptionDeadline?.toIso8601String() ?? '',
          _getYearsDelinquent(lien).toString(),
        ]);
      }

      // Конвертировать в CSV строку
      final csvString = const ListToCsvConverter(fieldDelimiter: ',').convert(csvData);

      // Сохранить файл
      final directory = await _getDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(csvString);

      if (kDebugMode) {
        print('✅ CSV экспортирован: ${file.path}');
        print('   Записей: ${liens.length}');
      }

      return file.path;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка экспорта CSV: $e');
      }
      return null;
    }
  }

  /// Экспортировать список legacy tax liens в CSV
  static Future<String?> exportLegacyToCSV({
    required List<LegacyTaxLien> liens,
    required String filename,
  }) async {
    try {
      final csvData = <List<String>>[];

      csvData.add([
        'Parcel ID',
        'County',
        'State',
        'Address',
        'City',
        'Zip Code',
        'Tax Amount',
        'Interest Rate (%)',
        'Assessed Value',
        'Estimated Value',
        'Property Type',
        'Owner',
        'Auction Date',
        'Status',
        'Location Type',
      ]);

      for (final lien in liens) {
        csvData.add([
          lien.parcelId,
          lien.county,
          lien.state,
          lien.address,
          '', // city - not available in LegacyTaxLien
          '', // zipCode - not available in LegacyTaxLien
          lien.taxAmount.toStringAsFixed(2),
          lien.interestRate.toStringAsFixed(2),
          lien.assessedValue.toStringAsFixed(2),
          lien.assessedValue.toStringAsFixed(2), // estimatedValue = assessedValue
          '', // propertyType - not available in LegacyTaxLien
          lien.owner,
          lien.auctionDate.toIso8601String(),
          lien.status,
          _getLocationType(lien.county),
        ]);
      }

      final csvString = const ListToCsvConverter(fieldDelimiter: ',').convert(csvData);

      final directory = await _getDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(csvString);

      if (kDebugMode) {
        print('✅ CSV экспортирован: ${file.path}');
        print('   Записей: ${liens.length}');
      }

      return file.path;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка экспорта CSV: $e');
      }
      return null;
    }
  }

  /// Поделиться файлом
  static Future<void> shareFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final xFile = XFile(filePath);
        // Use SharePlus.instance.share() instead of deprecated Share.shareXFiles()
        final result = await Share.shareXFiles([xFile], text: 'Tax Liens Export');
        if (kDebugMode) {
          print('✅ File shared: ${result.status}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка шаринга: $e');
      }
      rethrow;
    }
  }

  /// Получить директорию для сохранения
  static Future<Directory> _getDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return directory ?? await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  /// Определить тип локации (Coastal/Inland)
  static String _getLocationType(String county) {
    return getLocationType(county);
  }

  /// Публичный метод для определения типа локации
  static String getLocationType(String county) {
    if (county.isEmpty) return 'Unknown';

    final countyUpper = county.toUpperCase();
    final isCoastal = floridaCoastalCounties.any((c) =>
        countyUpper.contains(c.toUpperCase()) ||
        countyUpper == c.toUpperCase());

    return isCoastal ? 'Coastal' : 'Inland';
  }

  /// Вычислить количество лет просрочки
  static int _getYearsDelinquent(TaxLien lien) {
    if (lien.taxYear != null) {
      final now = DateTime.now();
      final taxYear = lien.taxYear!;
      return now.year - taxYear.year;
    }
    return 0;
  }

  /// Проверить, является ли lien OTP (Over-The-Counter)
  static bool isOTP(TaxLien lien) {
    // OTP - если auction date в прошлом или отсутствует
    final now = DateTime.now();
    return lien.auctionDate.isBefore(now) || lien.auctionDate.isAtSameMomentAs(now);
  }

  /// Проверить, является ли lien прибрежным
  static bool isCoastal(TaxLien lien) {
    return _getLocationType(lien.county) == 'Coastal';
  }

  /// Рассчитать score для сортировки (выше = лучше)
  static double calculateScore(TaxLien lien) {
    double score = 0.0;

    // Приоритет прибрежным округам
    if (isCoastal(lien)) {
      score += 100;
    }

    // Приоритет высокой процентной ставке
    score += lien.interestRate * 2;

    // Приоритет меньшей сумме (быстрее купить)
    if (lien.taxAmount > 0) {
      score += (2000 - lien.taxAmount).clamp(0, 2000) / 10;
    }

    // Приоритет более высокой оценочной стоимости
    if (lien.assessedValue > 0) {
      score += lien.assessedValue / 10000;
    }

    return score;
  }

  /// Фильтровать liens по критериям Шона
  static List<TaxLien> filterForSean({
    required List<TaxLien> liens,
    double minTaxAmount = 200.0,
    double maxTaxAmount = 2000.0,
    bool preferFlorida = true,
    bool preferCoastal = true,
    String? lienType, // 'otp' or 'auction'
    int limit = 108,
  }) {
    var filtered = liens.where((lien) {
      // Бюджет
      if (lien.taxAmount < minTaxAmount || lien.taxAmount > maxTaxAmount) {
        return false;
      }

      // Флорида
      if (preferFlorida && lien.state.toUpperCase() != 'FL') {
        return false;
      }

      // Тип lien
      if (lienType != null) {
        final isOTPLien = isOTP(lien);
        if (lienType == 'otp' && !isOTPLien) return false;
        if (lienType == 'auction' && isOTPLien) return false;
      }

      return true;
    }).toList();

    // Сортировать (приоритет прибрежным, затем по score)
    filtered.sort((a, b) {
      final aCoastal = isCoastal(a);
      final bCoastal = isCoastal(b);

      if (aCoastal && !bCoastal) return -1;
      if (!aCoastal && bCoastal) return 1;

      // Затем по score
      final scoreDiff = calculateScore(b).compareTo(calculateScore(a));
      if (scoreDiff != 0) return scoreDiff;

      // Затем по процентной ставке
      return b.interestRate.compareTo(a.interestRate);
    });

    // Взять топ N
    return filtered.take(limit).toList();
  }
}

