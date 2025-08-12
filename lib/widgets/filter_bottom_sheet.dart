import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedState;
  final String? selectedCounty;
  final double? minAmount;
  final double? maxAmount;
  final double? minInterestRate;
  final String sortBy;
  final bool sortAscending;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedState,
    this.selectedCounty,
    this.minAmount,
    this.maxAmount,
    this.minInterestRate,
    required this.sortBy,
    required this.sortAscending,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedState;
  late String? _selectedCounty;
  late double? _minAmount;
  late double? _maxAmount;
  late double? _minInterestRate;
  late String _sortBy;
  late bool _sortAscending;

  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _minInterestRateController = TextEditingController();

  // Список штатов (можно расширить)
  final List<String> _states = [
    'Florida',
    'Texas',
    'California',
    'New York',
    'Illinois',
    'Pennsylvania',
    'Ohio',
    'Georgia',
    'North Carolina',
    'Michigan',
  ];

  // Список округов (можно расширить)
  final List<String> _counties = [
    'Miami-Dade County',
    'Broward County',
    'Palm Beach County',
    'Hillsborough County',
    'Orange County',
    'Pinellas County',
    'Duval County',
    'Lee County',
    'Polk County',
    'Brevard County',
  ];

  @override
  void initState() {
    super.initState();
    _selectedState = widget.selectedState;
    _selectedCounty = widget.selectedCounty;
    _minAmount = widget.minAmount;
    _maxAmount = widget.maxAmount;
    _minInterestRate = widget.minInterestRate;
    _sortBy = widget.sortBy;
    _sortAscending = widget.sortAscending;

    _minAmountController.text = _minAmount?.toString() ?? '';
    _maxAmountController.text = _maxAmount?.toString() ?? '';
    _minInterestRateController.text = _minInterestRate?.toString() ?? '';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _minInterestRateController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'state': _selectedState,
      'county': _selectedCounty,
      'minAmount': _minAmount,
      'maxAmount': _maxAmount,
      'minInterestRate': _minInterestRate,
      'sortBy': _sortBy,
      'sortAscending': _sortAscending,
    };

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedState = null;
      _selectedCounty = null;
      _minAmount = null;
      _maxAmount = null;
      _minInterestRate = null;
      _sortBy = 'auctionDate';
      _sortAscending = true;

      _minAmountController.clear();
      _maxAmountController.clear();
      _minInterestRateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Заголовок
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(width: 8),
                      const Text(
                        'Фильтры и сортировка',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Очистить'),
                      ),
                    ],
                  ),
                ),

                // Содержимое
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Штат
                      _buildSection(
                        'Штат',
                        DropdownButtonFormField<String>(
                          value: _selectedState,
                          decoration: const InputDecoration(
                            labelText: 'Выберите штат',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Все штаты'),
                            ),
                            ..._states.map((state) => DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedState = value;
                              if (value != null) {
                                _selectedCounty = null;
                              }
                            });
                          },
                        ),
                      ),

                      // Округ
                      _buildSection(
                        'Округ',
                        DropdownButtonFormField<String>(
                          value: _selectedCounty,
                          decoration: const InputDecoration(
                            labelText: 'Выберите округ',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Все округа'),
                            ),
                            ..._counties.map((county) => DropdownMenuItem<String>(
                              value: county,
                              child: Text(county),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCounty = value;
                            });
                          },
                        ),
                      ),

                      // Сумма налога
                      _buildSection(
                        'Сумма налога',
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minAmountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'От',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _minAmount = double.tryParse(value);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _maxAmountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'До',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _maxAmount = double.tryParse(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Процентная ставка
                      _buildSection(
                        'Процентная ставка',
                        TextField(
                          controller: _minInterestRateController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Минимальная ставка',
                            suffixText: '%',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _minInterestRate = double.tryParse(value);
                            });
                          },
                        ),
                      ),

                      // Сортировка
                      _buildSection(
                        'Сортировка',
                        Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _sortBy,
                              decoration: const InputDecoration(
                                labelText: 'Сортировать по',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'auctionDate',
                                  child: Text('Дата аукциона'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'taxAmount',
                                  child: Text('Сумма налога'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'interestRate',
                                  child: Text('Процентная ставка'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'assessedValue',
                                  child: Text('Оценочная стоимость'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'redemptionDeadline',
                                  child: Text('Срок погашения'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sortBy = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: const Text('По возрастанию'),
                                    value: true,
                                    groupValue: _sortAscending,
                                    onChanged: (value) {
                                      setState(() {
                                        _sortAscending = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: const Text('По убыванию'),
                                    value: false,
                                    groupValue: _sortAscending,
                                    onChanged: (value) {
                                      setState(() {
                                        _sortAscending = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопки
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          child: const Text('Применить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}
