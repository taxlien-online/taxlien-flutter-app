import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/models/tax_lien.dart';
import '../core/models/tax_lien_nft.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._internal();

  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'taxlien_database.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tax liens table
    await db.execute('''
      CREATE TABLE tax_liens (
        id TEXT PRIMARY KEY,
        property_address TEXT NOT NULL,
        county TEXT NOT NULL,
        state TEXT NOT NULL,
        tax_amount REAL NOT NULL,
        interest_rate REAL NOT NULL,
        auction_date TEXT NOT NULL,
        status TEXT NOT NULL,
        property_type TEXT NOT NULL,
        estimated_value REAL NOT NULL,
        description TEXT NOT NULL,
        images TEXT NOT NULL,
        metadata TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_locked INTEGER DEFAULT 0,
        locked_for_nft TEXT
      )
    ''');

    // Create tax lien NFTs table
    await db.execute('''
      CREATE TABLE tax_lien_nfts (
        id TEXT PRIMARY KEY,
        token_id TEXT NOT NULL,
        contract_address TEXT NOT NULL,
        owner_address TEXT NOT NULL,
        original_lien_id TEXT NOT NULL,
        nft_metadata TEXT NOT NULL,
        image_url TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        attributes TEXT NOT NULL,
        minted_at TEXT NOT NULL,
        sold_at TEXT,
        sale_price REAL,
        status TEXT NOT NULL,
        metadata TEXT,
        FOREIGN KEY (original_lien_id) REFERENCES tax_liens (id)
      )
    ''');

    // Create user preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    
    // Create locked assets table
    await db.execute('''
      CREATE TABLE locked_assets (
        id TEXT PRIMARY KEY,
        asset_id TEXT NOT NULL,
        asset_type TEXT NOT NULL,
        locked_at TEXT NOT NULL,
        unlock_at TEXT NOT NULL,
        collateral_value REAL NOT NULL,
        loan_amount REAL NOT NULL,
        repayment_amount REAL NOT NULL,
        status TEXT NOT NULL,
        purpose TEXT NOT NULL,
        contract_id TEXT
      )
    ''');
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to tax_liens
      await db.execute('ALTER TABLE tax_liens ADD COLUMN is_locked INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE tax_liens ADD COLUMN locked_for_nft TEXT');
      
      // Create locked assets table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS locked_assets (
          id TEXT PRIMARY KEY,
          asset_id TEXT NOT NULL,
          asset_type TEXT NOT NULL,
          locked_at TEXT NOT NULL,
          unlock_at TEXT NOT NULL,
          collateral_value REAL NOT NULL,
          loan_amount REAL NOT NULL,
          repayment_amount REAL NOT NULL,
          status TEXT NOT NULL,
          purpose TEXT NOT NULL,
          contract_id TEXT
        )
      ''');
    }
  }

  // Tax Lien CRUD operations
  Future<int> insertTaxLien(TaxLien taxLien) async {
    final db = await database;
    return await db.insert('tax_liens', taxLien.toJson());
  }

  Future<List<TaxLien>> getAllTaxLiens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tax_liens');
    return List.generate(maps.length, (i) => TaxLien.fromJson(maps[i]));
  }

  Future<TaxLien?> getTaxLienById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tax_liens',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaxLien.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateTaxLien(TaxLien taxLien) async {
    final db = await database;
    return await db.update(
      'tax_liens',
      taxLien.toJson(),
      where: 'id = ?',
      whereArgs: [taxLien.id],
    );
  }

  Future<int> deleteTaxLien(String id) async {
    final db = await database;
    return await db.delete('tax_liens', where: 'id = ?', whereArgs: [id]);
  }

  // Tax Lien NFT CRUD operations
  Future<int> insertTaxLienNFT(TaxLienNFT nft) async {
    final db = await database;
    return await db.insert('tax_lien_nfts', nft.toJson());
  }

  Future<List<TaxLienNFT>> getAllTaxLienNFTs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tax_lien_nfts');
    return List.generate(maps.length, (i) => TaxLienNFT.fromJson(maps[i]));
  }

  Future<TaxLienNFT?> getTaxLienNFTById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tax_lien_nfts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaxLienNFT.fromJson(maps.first);
    }
    return null;
  }

  Future<List<TaxLienNFT>> getTaxLienNFTsByOwner(String ownerAddress) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tax_lien_nfts',
      where: 'owner_address = ?',
      whereArgs: [ownerAddress],
    );
    return List.generate(maps.length, (i) => TaxLienNFT.fromJson(maps[i]));
  }

  Future<int> updateTaxLienNFT(TaxLienNFT nft) async {
    final db = await database;
    return await db.update(
      'tax_lien_nfts',
      nft.toJson(),
      where: 'id = ?',
      whereArgs: [nft.id],
    );
  }

  Future<int> deleteTaxLienNFT(String id) async {
    final db = await database;
    return await db.delete('tax_lien_nfts', where: 'id = ?', whereArgs: [id]);
  }

  // User preferences
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert('user_preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }

  // Search functionality
  Future<List<TaxLien>> searchTaxLiens(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tax_liens',
      where: 'property_address LIKE ? OR county LIKE ? OR state LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => TaxLien.fromJson(maps[i]));
  }

  // Search history methods
  Future<List<String>> getSearchHistory({int limit = 10}) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user_preferences',
        where: 'key LIKE ?',
        whereArgs: ['search_history_%'],
        orderBy: 'value DESC',
        limit: limit,
      );
      return maps.map((map) => map['value'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveSearchHistory({required String query}) async {
    try {
      final db = await database;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await db.insert('user_preferences', {
        'key': 'search_history_$timestamp',
        'value': query,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      // Ignore errors
    }
  }

  // Cart methods
  Future<String?> getCartId() async {
    try {
      return await getPreference('cart_id');
    } catch (e) {
      return null;
    }
  }

  Future<void> saveCartId(String cartId) async {
    try {
      await setPreference('cart_id', cartId);
    } catch (e) {
      // Ignore errors
    }
  }

  // Favorites methods
  Future<bool> isFavorite(String sku, {String? type}) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user_preferences',
        where: 'key = ?',
        whereArgs: ['favorite_$sku'],
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> addToFavorites(String sku) async {
    try {
      await setPreference('favorite_$sku', 'true');
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> removeFromFavorites(String sku) async {
    try {
      final db = await database;
      await db.delete(
        'user_preferences',
        where: 'key = ?',
        whereArgs: ['favorite_$sku'],
      );
    } catch (e) {
      // Ignore errors
    }
  }

  // Locked Assets CRUD operations
  Future<int> insertLockedAsset(Map<String, dynamic> lockedAsset) async {
    final db = await database;
    return await db.insert('locked_assets', lockedAsset);
  }

  Future<List<Map<String, dynamic>>> getLockedAssetsRaw() async {
    final db = await database;
    return await db.query('locked_assets', where: 'status = ?', whereArgs: ['locked']);
  }

  Future<List<dynamic>> getLockedAssets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locked_assets',
      where: 'status = ?',
      whereArgs: ['locked'],
    );
    
    // Import needed
    // return List.generate(maps.length, (i) => LockedAsset.fromJson(maps[i]));
    // For now return raw maps
    return maps;
  }

  Future<Map<String, dynamic>?> getLockedAssetById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locked_assets',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<Map<String, dynamic>?> getLockedAssetByAssetId(String assetId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locked_assets',
      where: 'asset_id = ? AND status = ?',
      whereArgs: [assetId, 'locked'],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> updateLockedAsset(String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'locked_assets',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateLockedAssetStatus(String id, String status) async {
    final db = await database;
    return await db.update(
      'locked_assets',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteLockedAsset(String id) async {
    final db = await database;
    return await db.delete('locked_assets', where: 'id = ?', whereArgs: [id]);
  }

  // Initialize method
  Future<void> initialize() async {
    try {
      await database; // This will create the database if it doesn't exist
    } catch (e) {
      // Ignore errors
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
