import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tax_lien_service.dart';
import 'auth_service.dart';

class DatabaseService extends ChangeNotifier {
  static Database? _database;
  static const String _databaseName = 'taxlien_app.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String _tableTaxLiens = 'tax_liens';
  static const String _tableUserProfile = 'user_profile';
  static const String _tableTransactions = 'transactions';
  static const String _tableFavorites = 'favorites';
  static const String _tableSearchHistory = 'search_history';

  Future<void> initialize() async {
    await _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tax liens table
    await db.execute('''
      CREATE TABLE $_tableTaxLiens (
        id TEXT PRIMARY KEY,
        parcelId TEXT NOT NULL,
        owner TEXT NOT NULL,
        address TEXT NOT NULL,
        county TEXT NOT NULL,
        state TEXT NOT NULL,
        assessedValue REAL NOT NULL,
        taxAmount REAL NOT NULL,
        interestRate REAL NOT NULL,
        auctionDate TEXT NOT NULL,
        redemptionDeadline TEXT NOT NULL,
        status TEXT NOT NULL,
        salePrice REAL,
        buyerId TEXT,
        additionalData TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // User profile table
    await db.execute('''
      CREATE TABLE $_tableUserProfile (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        zipCode TEXT,
        balance REAL NOT NULL,
        createdAt TEXT NOT NULL,
        isVerified INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE $_tableTransactions (
        id TEXT PRIMARY KEY,
        lienId TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        timestamp TEXT NOT NULL,
        status TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (lienId) REFERENCES $_tableTaxLiens (id)
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE $_tableFavorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lienId TEXT NOT NULL,
        addedAt TEXT NOT NULL,
        FOREIGN KEY (lienId) REFERENCES $_tableTaxLiens (id)
      )
    ''');

    // Search history table
    await db.execute('''
      CREATE TABLE $_tableSearchHistory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        filters TEXT,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Methods for working with tax liens
  Future<void> saveTaxLiens(List<TaxLien> liens) async {
    if (_database == null) return;

    final batch = _database!.batch();
    final now = DateTime.now().toIso8601String();

    for (final lien in liens) {
      batch.insert(
        _tableTaxLiens,
        {
          'id': lien.id,
          'parcelId': lien.parcelId,
          'owner': lien.owner,
          'address': lien.address,
          'county': lien.county,
          'state': lien.state,
          'assessedValue': lien.assessedValue,
          'taxAmount': lien.taxAmount,
          'interestRate': lien.interestRate,
          'auctionDate': lien.auctionDate.toIso8601String(),
          'redemptionDeadline': lien.redemptionDeadline.toIso8601String(),
          'status': lien.status,
          'salePrice': lien.salePrice,
          'buyerId': lien.buyerId,
          'additionalData': lien.additionalData != null ? jsonEncode(lien.additionalData) : null,
          'lastUpdated': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<TaxLien>> getTaxLiens({String? status}) async {
    if (_database == null) return [];

    final whereClause = status != null ? 'WHERE status = ?' : '';
    final whereArgs = status != null ? [status] : [];

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableTaxLiens,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return maps.map((map) => TaxLien.fromJson(map)).toList();
  }

  Future<TaxLien?> getTaxLien(String id) async {
    if (_database == null) return null;

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableTaxLiens,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return TaxLien.fromJson(maps.first);
  }

  // Methods for working with user profile
  Future<void> saveUserProfile(User user) async {
    if (_database == null) return;

    await _database!.insert(
      _tableUserProfile,
      {
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
        'address': user.address,
        'city': user.city,
        'state': user.state,
        'zipCode': user.zipCode,
        'balance': user.balance,
        'createdAt': user.createdAt.toIso8601String(),
        'isVerified': user.isVerified ? 1 : 0,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserProfile(String id) async {
    if (_database == null) return null;

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableUserProfile,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return User.fromJson(maps.first);
  }

  // Methods for working with transactions
  Future<void> saveTransaction({
    required String id,
    required String lienId,
    required String type,
    required double amount,
    required String status,
    String? description,
  }) async {
    if (_database == null) return;

    await _database!.insert(
      _tableTransactions,
      {
        'id': id,
        'lienId': lienId,
        'type': type,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
        'status': status,
        'description': description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions({String? lienId}) async {
    if (_database == null) return [];

    final whereClause = lienId != null ? 'WHERE lienId = ?' : '';
    final whereArgs = lienId != null ? [lienId] : [];

    return await _database!.query(
      _tableTransactions,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
    );
  }

  // Methods for working with favorites
  Future<void> addToFavorites(String lienId) async {
    if (_database == null) return;

    await _database!.insert(
      _tableFavorites,
      {
        'lienId': lienId,
        'addedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFromFavorites(String lienId) async {
    if (_database == null) return;

    await _database!.delete(
      _tableFavorites,
      where: 'lienId = ?',
      whereArgs: [lienId],
    );
  }

  Future<List<String>> getFavoriteLienIds() async {
    if (_database == null) return [];

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableFavorites,
      columns: ['lienId'],
      orderBy: 'addedAt DESC',
    );

    return maps.map((map) => map['lienId'] as String).toList();
  }

  Future<bool> isFavorite(String lienId) async {
    if (_database == null) return false;

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableFavorites,
      where: 'lienId = ?',
      whereArgs: [lienId],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  // Methods for working with search history
  Future<void> saveSearchHistory({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    if (_database == null) return;

    await _database!.insert(
      _tableSearchHistory,
      {
        'query': query,
        'filters': filters != null ? jsonEncode(filters) : null,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getSearchHistory({int limit = 10}) async {
    if (_database == null) return [];

    return await _database!.query(
      _tableSearchHistory,
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  Future<void> clearSearchHistory() async {
    if (_database == null) return;

    await _database!.delete(_tableSearchHistory);
  }

  // Methods for clearing data
  Future<void> clearAllData() async {
    if (_database == null) return;

    await _database!.delete(_tableTaxLiens);
    await _database!.delete(_tableUserProfile);
    await _database!.delete(_tableTransactions);
    await _database!.delete(_tableFavorites);
    await _database!.delete(_tableSearchHistory);
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
