import 'package:flutter/material.dart';
import '../services/tax_lien_service.dart';
import '../services/database_service.dart';

class TaxLienCard extends StatefulWidget {
  final TaxLien lien;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const TaxLienCard({
    super.key,
    required this.lien,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  State<TaxLienCard> createState() => _TaxLienCardState();
}

class _TaxLienCardState extends State<TaxLienCard> {
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    // Здесь нужно получить доступ к DatabaseService
    // Пока что используем заглушку
    setState(() {
      _isFavorite = false;
      _isLoadingFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с адресом и кнопкой избранного
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.lien.address,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isLoadingFavorite
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : null,
                          ),
                    onPressed: _isLoadingFavorite ? null : () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      widget.onFavoriteToggle();
                    },
                    tooltip: _isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Владелец
              Text(
                'Владелец: ${widget.lien.owner}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Основные параметры
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Сумма налога',
                      '\$${widget.lien.taxAmount.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      'Ставка',
                      '${widget.lien.interestRate.toStringAsFixed(1)}%',
                      Icons.percent,
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Оценка',
                      '\$${widget.lien.assessedValue.toStringAsFixed(0)}',
                      Icons.assessment,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      'Аукцион',
                      _formatDate(widget.lien.auctionDate),
                      Icons.event,
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Нижняя часть с дополнительной информацией
              Row(
                children: [
                  // ID участка
                  Expanded(
                    child: Text(
                      'ID: ${widget.lien.parcelId}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  
                  // Статус
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.lien.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(widget.lien.status).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusLabel(widget.lien.status),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(widget.lien.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Срок погашения
              if (widget.lien.redemptionDeadline.isAfter(DateTime.now()))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Срок погашения: ${_formatDate(widget.lien.redemptionDeadline)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'available':
        return 'Доступна';
      case 'sold':
        return 'Продана';
      case 'redeemed':
        return 'Погашена';
      case 'foreclosed':
        return 'Обращена';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'sold':
        return Colors.blue;
      case 'redeemed':
        return Colors.orange;
      case 'foreclosed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
