import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/models/unified_asset.dart';
import '../services/asset_lock_service.dart';

/// Locked Assets Panel
/// Displays locked assets (collateralized for loans) for Anna's use case
class LockedAssetsPanel extends StatelessWidget {
  final AssetLockService lockService;

  const LockedAssetsPanel({
    super.key,
    required this.lockService,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: lockService,
      builder: (context, _) {
        final lockedAssets = lockService.lockedAssets;

        if (lockedAssets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock, color: Colors.orange, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Заблокированные Активы',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showLockedAssetsScreen(context),
                  icon: const Icon(Icons.settings),
                  label: const Text('Управление'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lockedAssets.length > 3 ? 3 : lockedAssets.length,
              itemBuilder: (context, index) {
                return LockedAssetCard(
                  lockedAsset: lockedAssets[index],
                  lockService: lockService,
                );
              },
            ),
            if (lockedAssets.length > 3)
              TextButton(
                onPressed: () => _showLockedAssetsScreen(context),
                child: Text('Смотреть все (${lockedAssets.length})'),
              ),
          ],
        );
      },
    );
  }

  void _showLockedAssetsScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LockedAssetsScreen(lockService: lockService),
    );
  }
}

/// Locked Asset Card
class LockedAssetCard extends StatelessWidget {
  final LockedAsset lockedAsset;
  final AssetLockService lockService;

  const LockedAssetCard({
    super.key,
    required this.lockedAsset,
    required this.lockService,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = lockedAsset.daysRemaining;
    final canUnlock = lockedAsset.canUnlock;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Asset Image
                if (lockedAsset.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      lockedAsset.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    ),
                  )
                else
                  _buildPlaceholder(),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lockedAsset.assetName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Разблокировка: ${_formatDate(lockedAsset.unlockAt)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: canUnlock ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: canUnlock ? Colors.green : Colors.orange,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        canUnlock ? Icons.lock_open : Icons.lock,
                        size: 16,
                        color: canUnlock ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        canUnlock ? 'Доступно' : '$daysRemaining дн.',
                        style: TextStyle(
                          color: canUnlock ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Loan Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Залог', '${lockedAsset.collateralValue.toStringAsFixed(0)} ICP'),
                _buildInfoColumn('Получено', '${lockedAsset.loanAmount.toStringAsFixed(0)} ICP', Colors.green),
                _buildInfoColumn('К возврату', '${lockedAsset.repaymentAmount.toStringAsFixed(2)} ICP', Colors.red),
              ],
            ),

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canUnlock
                    ? () => _showUnlockDialog(context)
                    : null,
                icon: const Icon(Icons.lock_open),
                label: Text(
                  canUnlock
                      ? 'Разблокировать NFT'
                      : 'Заблокировано до ${_formatDate(lockedAsset.unlockAt)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canUnlock ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.lock, color: Colors.orange),
    );
  }

  Widget _buildInfoColumn(String label, String value, [Color? valueColor]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _showUnlockDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Разблокировать актив?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Вы уверены, что хотите разблокировать этот актив?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Необходимо вернуть:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lockedAsset.repaymentAmount.toStringAsFixed(2)} ICP',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Разблокировать'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await lockService.unlockAsset(lockedAsset.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Актив разблокирован!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

/// Full Locked Assets Screen
class LockedAssetsScreen extends StatelessWidget {
  final AssetLockService lockService;

  const LockedAssetsScreen({
    super.key,
    required this.lockService,
  });

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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Заблокированные Активы',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Summary
          AnimatedBuilder(
            animation: lockService,
            builder: (context, _) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Всего заблокировано',
                      '${lockService.lockedAssets.length}',
                      Icons.lock,
                    ),
                    _buildSummaryItem(
                      'Общий займ',
                      '${lockService.getTotalLoanAmount().toStringAsFixed(0)} ICP',
                      Icons.attach_money,
                    ),
                    _buildSummaryItem(
                      'К возврату',
                      '${lockService.getTotalRepaymentAmount().toStringAsFixed(0)} ICP',
                      Icons.payment,
                    ),
                  ],
                ),
              );
            },
          ),

          // List
          Expanded(
            child: AnimatedBuilder(
              animation: lockService,
              builder: (context, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lockService.lockedAssets.length,
                  itemBuilder: (context, index) {
                    return LockedAssetCard(
                      lockedAsset: lockService.lockedAssets[index],
                      lockService: lockService,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

