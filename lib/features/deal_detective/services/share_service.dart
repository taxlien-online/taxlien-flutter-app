import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/models/tax_lien_models.dart';

/// Service for sharing properties via social platforms
///
/// Generates share images and handles social integration
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  static ShareService get instance => _instance;

  /// Share a property via various platforms
  Future<void> shareProperty({
    required TaxLien property,
    String? referralCode,
    GlobalKey? imageKey,
  }) async {
    try {
      // Generate share text
      final shareText = _generateShareText(property, referralCode);

      // If imageKey provided, capture and share image
      if (imageKey != null) {
        final imageFile = await _captureImage(imageKey);
        if (imageFile != null) {
          await Share.shareXFiles(
            [XFile(imageFile.path)],
            text: shareText,
            subject: 'Check out this tax lien deal!',
          );
          return;
        }
      }

      // Otherwise, share text only
      await Share.share(
        shareText,
        subject: 'Check out this tax lien deal!',
      );
    } catch (e) {
      debugPrint('Error sharing property: $e');
      rethrow;
    }
  }

  /// Share property via SMS
  Future<void> shareViaSMS({
    required TaxLien property,
    String? phoneNumber,
    String? referralCode,
  }) async {
    final text = _generateShareText(property, referralCode);
    final uri = phoneNumber != null
        ? 'sms:$phoneNumber?body=${Uri.encodeComponent(text)}'
        : 'sms:?body=${Uri.encodeComponent(text)}';

    // Use share_plus for cross-platform SMS
    await Share.share(text);
  }

  /// Share property via Email
  Future<void> shareViaEmail({
    required TaxLien property,
    String? email,
    String? referralCode,
  }) async {
    final subject = 'Tax Lien Deal: ${property.propertyAddress}';
    final body = _generateEmailBody(property, referralCode);

    // Use share_plus
    await Share.share(
      body,
      subject: subject,
    );
  }

  /// Generate share text
  String _generateShareText(TaxLien property, String? referralCode) {
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100)
        .toStringAsFixed(1);

    String text = '''
🏡 Found an amazing tax lien deal!

📍 ${property.propertyAddress}
💰 Tax Owed: \$${property.taxAmount.toStringAsFixed(0)}
📈 Est. Value: \$${property.estimatedValue.toStringAsFixed(0)}
🎯 Potential ROI: $roi%
📊 Interest Rate: ${property.interestRate}% APR

Check it out on TaxLien.online!
''';

    if (referralCode != null) {
      text += '\n👉 Use my referral code: $referralCode';
    }

    return text;
  }

  /// Generate detailed email body
  String _generateEmailBody(TaxLien property, String? referralCode) {
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100)
        .toStringAsFixed(1);

    String body = '''
Hi!

I found this tax lien deal on TaxLien.online and thought you might be interested:

Property Details:
━━━━━━━━━━━━━━━━━━━━
📍 Address: ${property.propertyAddress}
🏙️ Location: ${property.county}, ${property.state}
🆔 Parcel ID: ${property.parcelId}

Financial Details:
━━━━━━━━━━━━━━━━━━━━
💰 Tax Amount: \$${property.taxAmount.toStringAsFixed(2)}
📈 Estimated Value: \$${property.estimatedValue.toStringAsFixed(2)}
🎯 Potential ROI: $roi%
📊 Interest Rate: ${property.interestRate}% APR
📅 Sale Date: ${property.saleDate.toString().split(' ')[0]}

Property Info:
━━━━━━━━━━━━━━━━━━━━
🏘️ Type: ${property.propertyType}
📐 Land Size: ${property.landSize} sq ft
🏠 Building Size: ${property.buildingSize} sq ft

Why this is interesting:
• High ROI potential
• Competitive interest rate
• Verified property information

Learn more at: https://taxlien.online
''';

    if (referralCode != null) {
      body +=
          '\n\n👉 Sign up with my referral code "$referralCode" for exclusive benefits!\n';
    }

    return body;
  }

  /// Capture widget as image
  Future<File?> _captureImage(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/share_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(byteData.buffer.asUint8List());

      return imageFile;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }

  /// Generate shareable card widget (can be captured)
  Widget buildShareCard(TaxLien property) {
    final roi = ((property.estimatedValue - property.taxAmount) /
            property.taxAmount *
            100)
        .toStringAsFixed(1);

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TaxLien.online',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$roi% ROI',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Property address
          Text(
            property.propertyAddress,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${property.county}, ${property.state}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stats grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  'Tax Owed',
                  '\$${property.taxAmount.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  'Est. Value',
                  '\$${property.estimatedValue.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  'Interest Rate',
                  '${property.interestRate}% APR',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          const Text(
            'Discover tax lien deals on TaxLien.online',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Track share event for analytics
  void trackShare({
    required String propertyId,
    required String platform,
    String? userId,
  }) {
    // TODO: Send to analytics service
    debugPrint('Share tracked: $propertyId via $platform');
  }
}
