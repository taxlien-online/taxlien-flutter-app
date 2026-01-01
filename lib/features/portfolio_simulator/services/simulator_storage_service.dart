import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/simulated_portfolio.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';

/// Local storage service for Portfolio Simulator data
///
/// Uses SQLite to persist portfolios, positions, and outcomes.
/// Provides CRUD operations and caching for offline support.
class SimulatorStorageService {
  static SimulatorStorageService? _instance;
  static Database? _database;

  SimulatorStorageService._internal();

  static SimulatorStorageService get instance {
    _instance ??= SimulatorStorageService._internal();
    return _instance!;
  }

  /// Get database instance (creates if not exists)
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize SQLite database with simulator tables
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'simulator_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Portfolios table
    await db.execute('''
      CREATE TABLE portfolios (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        available_capital REAL NOT NULL,
        invested_value REAL NOT NULL,
        position_count INTEGER NOT NULL,
        roi REAL NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_archived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Positions table
    await db.execute('''
      CREATE TABLE positions (
        id TEXT PRIMARY KEY,
        portfolio_id TEXT NOT NULL,
        property_id TEXT NOT NULL,
        property_address TEXT NOT NULL,
        county TEXT NOT NULL,
        state TEXT NOT NULL,
        purchase_price REAL NOT NULL,
        transaction_fees REAL NOT NULL,
        status TEXT NOT NULL,
        purchased_at TEXT NOT NULL,
        expected_outcome_at TEXT NOT NULL,
        outcome_at TEXT,
        outcome_id TEXT,
        simulation_speed REAL NOT NULL,
        FOREIGN KEY (portfolio_id) REFERENCES portfolios (id) ON DELETE CASCADE
      )
    ''');

    // Outcomes table
    await db.execute('''
      CREATE TABLE outcomes (
        id TEXT PRIMARY KEY,
        position_id TEXT NOT NULL,
        type TEXT NOT NULL,
        final_value REAL NOT NULL,
        profit_loss REAL NOT NULL,
        roi_percentage REAL NOT NULL,
        weeks_to_outcome INTEGER NOT NULL,
        probability REAL NOT NULL,
        is_ml_generated INTEGER NOT NULL,
        lesson_learned TEXT NOT NULL,
        explanation TEXT NOT NULL,
        generated_at TEXT NOT NULL,
        metadata TEXT,
        FOREIGN KEY (position_id) REFERENCES positions (id) ON DELETE CASCADE
      )
    ''');

    // Create indices for better query performance
    await db.execute('CREATE INDEX idx_portfolios_user_id ON portfolios(user_id)');
    await db.execute('CREATE INDEX idx_positions_portfolio_id ON positions(portfolio_id)');
    await db.execute('CREATE INDEX idx_outcomes_position_id ON outcomes(position_id)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations will go here
  }

  // ===== PORTFOLIO OPERATIONS =====

  /// Save a portfolio to database
  Future<void> savePortfolio(SimulatedPortfolio portfolio) async {
    final db = await database;
    await db.insert(
      'portfolios',
      {
        'id': portfolio.id,
        'user_id': portfolio.userId,
        'name': portfolio.name,
        'available_capital': portfolio.availableCapital,
        'invested_value': portfolio.investedValue,
        'position_count': portfolio.positionCount,
        'roi': portfolio.roi,
        'created_at': portfolio.createdAt.toIso8601String(),
        'updated_at': portfolio.updatedAt.toIso8601String(),
        'is_archived': portfolio.isArchived ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all portfolios for a user
  Future<List<SimulatedPortfolio>> getPortfolios(String userId, {bool includeArchived = false}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'portfolios',
      where: includeArchived ? 'user_id = ?' : 'user_id = ? AND is_archived = 0',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return maps.map((map) => _portfolioFromMap(map)).toList();
  }

  /// Get a single portfolio by ID
  Future<SimulatedPortfolio?> getPortfolio(String portfolioId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'portfolios',
      where: 'id = ?',
      whereArgs: [portfolioId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _portfolioFromMap(maps.first);
  }

  /// Update a portfolio
  Future<void> updatePortfolio(SimulatedPortfolio portfolio) async {
    final db = await database;
    await db.update(
      'portfolios',
      {
        'name': portfolio.name,
        'available_capital': portfolio.availableCapital,
        'invested_value': portfolio.investedValue,
        'position_count': portfolio.positionCount,
        'roi': portfolio.roi,
        'updated_at': portfolio.updatedAt.toIso8601String(),
        'is_archived': portfolio.isArchived ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [portfolio.id],
    );
  }

  /// Delete a portfolio and all its positions
  Future<void> deletePortfolio(String portfolioId) async {
    final db = await database;
    await db.delete(
      'portfolios',
      where: 'id = ?',
      whereArgs: [portfolioId],
    );
    // Positions will be cascade deleted due to FOREIGN KEY constraint
  }

  // ===== POSITION OPERATIONS =====

  /// Save a position to database
  Future<void> savePosition(SimulatedPosition position) async {
    final db = await database;
    await db.insert(
      'positions',
      {
        'id': position.id,
        'portfolio_id': position.portfolioId,
        'property_id': position.propertyId,
        'property_address': position.propertyAddress,
        'county': position.county,
        'state': position.state,
        'purchase_price': position.purchasePrice,
        'transaction_fees': position.transactionFees,
        'status': position.status.name,
        'purchased_at': position.purchasedAt.toIso8601String(),
        'expected_outcome_at': position.expectedOutcomeAt.toIso8601String(),
        'outcome_at': position.outcomeAt?.toIso8601String(),
        'outcome_id': position.outcomeId,
        'simulation_speed': position.simulationSpeed,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all positions for a portfolio
  Future<List<SimulatedPosition>> getPositions(String portfolioId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'positions',
      where: 'portfolio_id = ?',
      whereArgs: [portfolioId],
      orderBy: 'purchased_at DESC',
    );

    return maps.map((map) => _positionFromMap(map)).toList();
  }

  /// Get a single position by ID
  Future<SimulatedPosition?> getPosition(String positionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'positions',
      where: 'id = ?',
      whereArgs: [positionId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _positionFromMap(maps.first);
  }

  /// Update a position
  Future<void> updatePosition(SimulatedPosition position) async {
    final db = await database;
    await db.update(
      'positions',
      {
        'status': position.status.name,
        'outcome_at': position.outcomeAt?.toIso8601String(),
        'outcome_id': position.outcomeId,
      },
      where: 'id = ?',
      whereArgs: [position.id],
    );
  }

  /// Get positions with outcomes ready (past expected outcome time)
  Future<List<SimulatedPosition>> getPositionsWithOutcomesReady() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      'positions',
      where: 'expected_outcome_at <= ? AND status IN (?, ?)',
      whereArgs: [now, 'purchased', 'simulating'],
    );

    return maps.map((map) => _positionFromMap(map)).toList();
  }

  // ===== OUTCOME OPERATIONS =====

  /// Save an outcome to database
  Future<void> saveOutcome(SimulationOutcome outcome) async {
    final db = await database;
    await db.insert(
      'outcomes',
      {
        'id': outcome.id,
        'position_id': outcome.positionId,
        'type': outcome.type.name,
        'final_value': outcome.finalValue,
        'profit_loss': outcome.profitLoss,
        'roi_percentage': outcome.roiPercentage,
        'weeks_to_outcome': outcome.weeksToOutcome,
        'probability': outcome.probability,
        'is_ml_generated': outcome.isMlGenerated ? 1 : 0,
        'lesson_learned': outcome.lessonLearned,
        'explanation': outcome.explanation,
        'generated_at': outcome.generatedAt.toIso8601String(),
        'metadata': outcome.metadata != null ? jsonEncode(outcome.metadata) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get outcome for a position
  Future<SimulationOutcome?> getOutcome(String positionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'outcomes',
      where: 'position_id = ?',
      whereArgs: [positionId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _outcomeFromMap(maps.first);
  }

  // ===== HELPER METHODS =====

  /// Convert database map to SimulatedPortfolio
  SimulatedPortfolio _portfolioFromMap(Map<String, dynamic> map) {
    return SimulatedPortfolio(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      availableCapital: map['available_capital'] as double,
      investedValue: map['invested_value'] as double,
      positionCount: map['position_count'] as int,
      roi: map['roi'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      isArchived: map['is_archived'] == 1,
    );
  }

  /// Convert database map to SimulatedPosition
  SimulatedPosition _positionFromMap(Map<String, dynamic> map) {
    return SimulatedPosition(
      id: map['id'] as String,
      portfolioId: map['portfolio_id'] as String,
      propertyId: map['property_id'] as String,
      propertyAddress: map['property_address'] as String,
      county: map['county'] as String,
      state: map['state'] as String,
      purchasePrice: map['purchase_price'] as double,
      transactionFees: map['transaction_fees'] as double,
      status: PositionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PositionStatus.purchased,
      ),
      purchasedAt: DateTime.parse(map['purchased_at'] as String),
      expectedOutcomeAt: DateTime.parse(map['expected_outcome_at'] as String),
      outcomeAt: map['outcome_at'] != null ? DateTime.parse(map['outcome_at'] as String) : null,
      outcomeId: map['outcome_id'] as String?,
      simulationSpeed: map['simulation_speed'] as double,
    );
  }

  /// Convert database map to SimulationOutcome
  SimulationOutcome _outcomeFromMap(Map<String, dynamic> map) {
    return SimulationOutcome(
      id: map['id'] as String,
      positionId: map['position_id'] as String,
      type: OutcomeType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => OutcomeType.loss,
      ),
      finalValue: map['final_value'] as double,
      profitLoss: map['profit_loss'] as double,
      roiPercentage: map['roi_percentage'] as double,
      weeksToOutcome: map['weeks_to_outcome'] as int,
      probability: map['probability'] as double,
      isMlGenerated: map['is_ml_generated'] == 1,
      lessonLearned: map['lesson_learned'] as String,
      explanation: map['explanation'] as String,
      generatedAt: DateTime.parse(map['generated_at'] as String),
      metadata: map['metadata'] != null ? jsonDecode(map['metadata'] as String) as Map<String, dynamic> : null,
    );
  }

  /// Close database connection (for cleanup)
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Clear all simulator data (for testing/reset)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('portfolios');
    await db.delete('positions');
    await db.delete('outcomes');
  }
}
