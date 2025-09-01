import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/tax_lien_service.dart';
import '../services/ai_investment_advisor_service.dart';
import '../widgets/tax_lien_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AIAdvisorScreen extends StatefulWidget {
  final TaxLienService taxLienService;
  final AIInvestmentAdvisorService aiService;

  const AIAdvisorScreen({
    super.key,
    required this.taxLienService,
    required this.aiService,
  });

  @override
  State<AIAdvisorScreen> createState() => _AIAdvisorScreenState();
}

class _AIAdvisorScreenState extends State<AIAdvisorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAnalyzing = false;
  AIAnalysisResult? _currentAnalysis;
  TaxLien? _selectedLien;
  List<TaxLien> _recommendations = [];
  bool _loadingRecommendations = false;

  // Настройки пользователя
  InvestmentGoal _investmentGoal = InvestmentGoal.balanced;
  double _maxInvestment = 5000.0;
  InvestmentRiskLevel _riskTolerance = InvestmentRiskLevel.medium;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecommendations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _loadingRecommendations = true);
    
    try {
      await widget.taxLienService.loadAvailableLiens();
      final recommendations = await widget.aiService.getPersonalizedRecommendations(
        widget.taxLienService.availableLiens,
        _investmentGoal,
        _maxInvestment,
        _riskTolerance,
      );
      
      setState(() {
        _recommendations = recommendations;
        _loadingRecommendations = false;
      });
    } catch (e) {
      setState(() => _loadingRecommendations = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки рекомендаций: $e')),
      );
    }
  }

  Future<void> _analyzeLien(TaxLien lien) async {
    setState(() {
      _isAnalyzing = true;
      _selectedLien = lien;
      _currentAnalysis = null;
    });

    try {
      final analysis = await widget.aiService.analyzeTaxLien(lien);
      setState(() {
        _currentAnalysis = analysis;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка анализа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Консультант'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.psychology), text: 'Анализ'),
            Tab(icon: Icon(Icons.recommend), text: 'Рекомендации'),
            Tab(icon: Icon(Icons.settings), text: 'Настройки'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalysisTab(),
          _buildRecommendationsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return Column(
      children: [
        // Выбор закладной для анализа
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          color: AppColors.surface,
          child: Row(
            children: [
              const Icon(Icons.analytics, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите закладную для анализа',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'AI проанализирует риски и потенциал прибыли',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: _isAnalyzing
              ? _buildAnalyzingIndicator()
              : _currentAnalysis != null
                  ? _buildAnalysisResults()
                  : _buildLienSelector(),
        ),
      ],
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator()
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 1000.ms)
              .then()
              .shake(duration: 500.ms),
          const SizedBox(height: AppDimensions.lg),
          Text(
            '🤖 AI анализирует закладную...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Оценка рисков, потенциала прибыли и рыночных условий',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_currentAnalysis == null || _selectedLien == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Информация о закладной
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedLien!.address,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_selectedLien!.county}, ${_selectedLien!.state}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideX(begin: -0.3, end: 0),

          const SizedBox(height: AppDimensions.md),

          // Основная рекомендация
          Card(
            color: _getRecommendationColor().withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getRecommendationIcon(),
                        color: _getRecommendationColor(),
                        size: 28,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          'AI Рекомендация',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getRecommendationColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    _currentAnalysis!.recommendation,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).scale(begin: Offset(0.8, 0.8)),

          const SizedBox(height: AppDimensions.md),

          // Метрики
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Риск',
                  '${_currentAnalysis!.riskScore.toStringAsFixed(0)}%',
                  _getRiskColor(_currentAnalysis!.riskScore),
                  Icons.warning,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: _buildMetricCard(
                  'Потенциал',
                  '${_currentAnalysis!.profitPotential.toStringAsFixed(0)}%',
                  AppColors.success,
                  Icons.trending_up,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.sm),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Ожидаемый ROI',
                  '${_currentAnalysis!.expectedROI.toStringAsFixed(1)}%',
                  AppColors.primary,
                  Icons.percent,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: _buildMetricCard(
                  'Срок окупаемости',
                  '${_currentAnalysis!.paybackMonths} мес.',
                  AppColors.secondary,
                  Icons.schedule,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.md),

          // Преимущества
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, color: AppColors.success),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        'Преимущества',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ...(_currentAnalysis!.pros.map((pro) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.success)),
                            Expanded(child: Text(pro)),
                          ],
                        ),
                      ))),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0),

          const SizedBox(height: AppDimensions.md),

          // Недостатки
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_down, color: AppColors.error),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        'Риски и недостатки',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ...(_currentAnalysis!.cons.map((con) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.error)),
                            Expanded(child: Text(con)),
                          ],
                        ),
                      ))),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3, end: 0),

          const SizedBox(height: AppDimensions.lg),

          // Кнопка анализа другой закладной
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentAnalysis = null;
                  _selectedLien = null;
                });
              },
              icon: const Icon(Icons.analytics),
              label: const Text('Анализировать другую закладную'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.xs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: Offset(0.8, 0.8));
  }

  Widget _buildLienSelector() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: widget.taxLienService.availableLiens.length,
      itemBuilder: (context, index) {
        final lien = widget.taxLienService.availableLiens[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: TaxLienCard(
            lien: lien,
            onTap: () => _analyzeLien(lien),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.xs),
              ),
              child: const Text(
                'Анализ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 100)),
        );
      },
    );
  }

  Widget _buildRecommendationsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          color: AppColors.surface,
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.secondary),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Персональные рекомендации',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Подобраны специально для ваших целей',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loadRecommendations,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: _loadingRecommendations
              ? const Center(child: CircularProgressIndicator())
              : _recommendations.isEmpty
                  ? _buildEmptyRecommendations()
                  : _buildRecommendationsList(),
        ),
      ],
    );
  }

  Widget _buildEmptyRecommendations() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Нет подходящих рекомендаций',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Попробуйте изменить настройки на вкладке "Настройки"',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final lien = _recommendations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(lien.address),
                  subtitle: Text('${lien.county}, ${lien.state}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.xs),
                    ),
                    child: Text(
                      'Рекомендую',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          'Сумма',
                          '\$${lien.taxAmount.toStringAsFixed(0)}',
                          Icons.attach_money,
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          'Ставка',
                          '${lien.interestRate.toStringAsFixed(1)}%',
                          Icons.percent,
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          'Стоимость',
                          '\$${(lien.assessedValue / 1000).toStringAsFixed(0)}K',
                          Icons.home,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _analyzeLien(lien),
                          icon: const Icon(Icons.analytics, size: 16),
                          label: const Text('Анализ'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Переход к деталям закладной
                          },
                          icon: const Icon(Icons.info, size: 16),
                          label: const Text('Детали'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 150)).slideX(begin: 0.3, end: 0),
        );
      },
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Инвестиционная цель',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ...InvestmentGoal.values.map((goal) => RadioListTile<InvestmentGoal>(
                        title: Text(_getGoalTitle(goal)),
                        subtitle: Text(_getGoalDescription(goal)),
                        value: goal,
                        groupValue: _investmentGoal,
                        onChanged: (value) {
                          setState(() => _investmentGoal = value!);
                          _loadRecommendations();
                        },
                      )),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Максимальная инвестиция: \$${_maxInvestment.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _maxInvestment,
                    min: 1000,
                    max: 10000,
                    divisions: 9,
                    label: '\$${_maxInvestment.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() => _maxInvestment = value);
                    },
                    onChangeEnd: (value) => _loadRecommendations(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Толерантность к риску',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ...InvestmentRiskLevel.values.map((risk) => RadioListTile<InvestmentRiskLevel>(
                        title: Text(_getRiskTitle(risk)),
                        subtitle: Text(_getRiskDescription(risk)),
                        value: risk,
                        groupValue: _riskTolerance,
                        onChanged: (value) {
                          setState(() => _riskTolerance = value!);
                          _loadRecommendations();
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGoalTitle(InvestmentGoal goal) {
    switch (goal) {
      case InvestmentGoal.quickReturn:
        return 'Быстрая прибыль';
      case InvestmentGoal.longTerm:
        return 'Долгосрочные инвестиции';
      case InvestmentGoal.balanced:
        return 'Сбалансированный подход';
    }
  }

  String _getGoalDescription(InvestmentGoal goal) {
    switch (goal) {
      case InvestmentGoal.quickReturn:
        return 'Фокус на быстрое получение прибыли';
      case InvestmentGoal.longTerm:
        return 'Максимизация долгосрочной доходности';
      case InvestmentGoal.balanced:
        return 'Баланс между риском и доходностью';
    }
  }

  String _getRiskTitle(InvestmentRiskLevel risk) {
    switch (risk) {
      case InvestmentRiskLevel.low:
        return 'Низкий риск';
      case InvestmentRiskLevel.medium:
        return 'Средний риск';
      case InvestmentRiskLevel.high:
        return 'Высокий риск';
    }
  }

  String _getRiskDescription(InvestmentRiskLevel risk) {
    switch (risk) {
      case InvestmentRiskLevel.low:
        return 'Консервативные инвестиции';
      case InvestmentRiskLevel.medium:
        return 'Умеренные инвестиции';
      case InvestmentRiskLevel.high:
        return 'Агрессивные инвестиции';
    }
  }

  Color _getRecommendationColor() {
    if (_currentAnalysis == null) return AppColors.primary;
    
    final profitPotential = _currentAnalysis!.profitPotential;
    final riskScore = _currentAnalysis!.riskScore;
    
    if (profitPotential > 70 && riskScore < 40) return AppColors.success;
    if (profitPotential > 50 || riskScore < 35) return AppColors.primary;
    if (riskScore > 70) return AppColors.error;
    return AppColors.warning;
  }

  IconData _getRecommendationIcon() {
    if (_currentAnalysis == null) return Icons.psychology;
    
    final profitPotential = _currentAnalysis!.profitPotential;
    final riskScore = _currentAnalysis!.riskScore;
    
    if (profitPotential > 70 && riskScore < 40) return Icons.star;
    if (profitPotential > 50 || riskScore < 35) return Icons.thumb_up;
    if (riskScore > 70) return Icons.warning;
    return Icons.info;
  }

  Color _getRiskColor(double riskScore) {
    if (riskScore < 30) return AppColors.success;
    if (riskScore < 60) return AppColors.warning;
    return AppColors.error;
  }
}
