import 'package:flutter/material.dart';
import '../core/models/tax_lien.dart';
import '../core/models/unified_asset.dart';
import '../services/unified_portfolio_service.dart';
import '../services/yuku_service.dart';

/// Tokenization Wizard
/// Multi-step wizard for converting traditional tax liens to NFTs
class TokenizationWizard extends StatefulWidget {
  final UnifiedPortfolioService portfolioService;
  final YukuService? yukuService;
  final String? walletAddress;

  const TokenizationWizard({
    super.key,
    required this.portfolioService,
    this.yukuService,
    this.walletAddress,
  });

  @override
  State<TokenizationWizard> createState() => _TokenizationWizardState();
}

class _TokenizationWizardState extends State<TokenizationWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  TaxLien? _selectedLien;
  final TokenizationOptions _options = TokenizationOptions();
  PriceSuggestion? _priceSuggestion;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header with close button
          _buildHeader(),

          // Progress Indicator
          _buildProgressIndicator(),

          // Step Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildSelectLienStep(),
                _buildNFTConfigStep(),
                _buildSaleOptionsStep(),
                _buildConfirmationStep(),
              ],
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.collections, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Создание NFT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(4, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                if (index > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? Colors.blue : Colors.grey.shade300,
                    ),
                  ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? Colors.blue
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectLienStep() {
    return FutureBuilder(
      future: widget.portfolioService.getTokenizableLiens(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final liens = snapshot.data!;
        return _buildSelectLienContent(liens);
      },
    );
  }

  Widget _buildSelectLienContent(List<TaxLien> liens) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Шаг 1: Выберите залог для токенизации',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Конвертируйте налоговый залог в NFT для продажи на маркетплейсе',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          if (liens.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.inbox_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Нет доступных залогов для токенизации',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: liens.length,
              itemBuilder: (context, index) {
                final lien = liens[index];
                final isSelected = _selectedLien?.id == lien.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedLien = lien);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Preview Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: lien.images.isNotEmpty
                                ? Image.network(
                                    lien.images.first,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholderImage(),
                                  )
                                : _buildPlaceholderImage(),
                          ),
                          const SizedBox(width: 16),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lien.propertyAddress,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${lien.county}, ${lien.state}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '\$${lien.lienAmount.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${lien.interestRate}% ROI',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Selection indicator
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: Colors.blue, size: 28)
                          else
                            Icon(Icons.circle_outlined,
                                color: Colors.grey.shade400, size: 28),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade200,
      child: const Icon(Icons.home, color: Colors.grey),
    );
  }

  Widget _buildNFTConfigStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Шаг 2: Настройте NFT',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // NFT Name
          TextField(
            decoration: InputDecoration(
              labelText: 'Название NFT',
              hintText: 'Tax Lien #${_selectedLien?.id}',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) => _options.nftName = value,
          ),
          const SizedBox(height: 16),

          // Description
          TextField(
            decoration: InputDecoration(
              labelText: 'Описание',
              hintText: 'Опишите этот актив для покупателей',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 3,
            onChanged: (value) => _options.description = value,
          ),
          const SizedBox(height: 24),

          // Tokenization Type
          const Text(
            'Тип токенизации',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SegmentedButton<TokenizationType>(
            segments: const [
              ButtonSegment(
                value: TokenizationType.full,
                label: Text('Полный NFT'),
                icon: Icon(Icons.confirmation_number),
              ),
              ButtonSegment(
                value: TokenizationType.fractional,
                label: Text('Дробный'),
                icon: Icon(Icons.pie_chart),
              ),
            ],
            selected: {_options.type},
            onSelectionChanged: (Set<TokenizationType> newSelection) {
              setState(() => _options.type = newSelection.first);
            },
          ),

          if (_options.type == TokenizationType.fractional) ...[
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Количество долей',
                hintText: 'Например: 10',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _options.fractionalShares = int.tryParse(value),
            ),
          ],

          const SizedBox(height: 24),

          // Preview Card
          _buildNFTPreview(),
        ],
      ),
    );
  }

  Widget _buildNFTPreview() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Предпросмотр NFT',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _selectedLien?.images.isNotEmpty ?? false
                  ? Image.network(
                      _selectedLien!.images.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholderPreview(),
                    )
                  : _buildPlaceholderPreview(),
            ),
            const SizedBox(height: 12),
            Text(
              _options.nftName.isEmpty
                  ? 'Tax Lien NFT #${_selectedLien?.id}'
                  : _options.nftName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _options.description.isEmpty
                  ? 'NFT representing ${_selectedLien?.propertyAddress}'
                  : _options.description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPreview() {
    return Container(
      height: 200,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildSaleOptionsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Шаг 3: Опции продажи (необязательно)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Вы можете сразу выставить NFT на Yuku Marketplace',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Выставить на Yuku сразу после создания'),
            value: _options.listOnYuku,
            onChanged: (value) {
              setState(() {
                _options.listOnYuku = value;
                if (value && widget.yukuService != null) {
                  _loadPriceSuggestion();
                }
              });
            },
          ),
          if (_options.listOnYuku) ...[
            const SizedBox(height: 24),

            // AI Price Suggestion
            if (_priceSuggestion != null)
              Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text(
                            'Рекомендуемая цена',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${_priceSuggestion!.recommended.toStringAsFixed(2)} ICP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Диапазон: ${_priceSuggestion!.minimum.toStringAsFixed(2)} - ${_priceSuggestion!.maximum.toStringAsFixed(2)} ICP',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 16),

            // Price Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Цена продажи',
                hintText: 'Введите цену в ICP',
                suffixText: 'ICP',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _options.price = double.tryParse(value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Шаг 4: Подтверждение',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Summary Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Вы создаёте:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Тип',
                    _options.type == TokenizationType.full
                        ? 'Полный NFT'
                        : 'Дробный NFT (${_options.fractionalShares} долей)',
                  ),
                  _buildSummaryRow('Актив', _selectedLien!.propertyAddress),
                  _buildSummaryRow('Стоимость актива',
                      '\$${_selectedLien!.lienAmount.toStringAsFixed(0)}'),
                  if (_options.listOnYuku) ...[
                    const Divider(height: 24),
                    _buildSummaryRow('Продажа на Yuku', 'Да'),
                    _buildSummaryRow('Цена', '${_options.price} ICP'),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'После создания NFT, оригинальный залог будет заблокирован. Вы сможете вернуть его, "сжигая" NFT.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _executeTokenization,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.rocket_launch),
              label: Text(
                _isLoading ? 'Создаём NFT...' : 'Создать NFT',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Назад'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          if (_currentStep < 3)
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Далее'),
              ),
            ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedLien != null;
      case 1:
        return _options.nftName.isNotEmpty;
      case 2:
        if (_options.listOnYuku) {
          return _options.price != null && _options.price! > 0;
        }
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  Future<void> _loadPriceSuggestion() async {
    // Mock price suggestion
    setState(() {
      _priceSuggestion = PriceSuggestion(
        recommended:
            (_selectedLien!.lienAmount / 100), // Convert to ICP equivalent
        minimum: (_selectedLien!.lienAmount / 100) * 0.85,
        maximum: (_selectedLien!.lienAmount / 100) * 1.15,
        confidence: 'medium',
        factors: [
          'Средняя цена аналогов в категории',
          'Текущий спрос на рынке: средний',
          'Волатильность: 15%',
        ],
      );
    });
  }

  Future<void> _executeTokenization() async {
    if (_selectedLien == null || widget.walletAddress == null) return;

    setState(() => _isLoading = true);

    try {
      final nft = await widget.portfolioService.tokenizeLien(
        lienId: _selectedLien!.id.toString(),
        options: _options,
        ownerAddress: widget.walletAddress!,
      );

      if (nft != null && mounted) {
        Navigator.of(context).pop(true); // Return success

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NFT успешно создан!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to create NFT');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
