// import 'package:flutter_magento/flutter_magento.dart';
import 'tax_lien_search_service.dart';

/// Service for converting between Magento products and TaxLiens
class TaxLienMagentoAdapter {
  final TaxLienAdapter _adapter = TaxLienAdapter();

  /// Convert Magento Product to TaxLien
  TaxLien fromMagentoProduct(Product product) {
    // Parse custom attributes using TaxLienAdapter
    final customAttrs = _adapter.fromCustomAttributes(
      product.customAttributes ?? [],
    );

    return TaxLien(
      id: product.id?.toString() ?? product.sku,
      parcelId: customAttrs.parcelId ?? product.sku,
      address: customAttrs.address ?? product.name,
      city: customAttrs.city ?? _extractFromName(product.name, 1),
      county: customAttrs.county ?? 'N/A',
      state: customAttrs.state ?? _extractFromName(product.name, 2),
      zipCode: customAttrs.zipCode ?? '',
      amount: customAttrs.taxAmount ?? product.price,
      interestRate: customAttrs.interestRate ?? 0.0,
      status: customAttrs.status ?? 'available',
      auctionDate: customAttrs.auctionDate,
      ownerName: customAttrs.ownerName,
      assessedValue: customAttrs.assessedValue,
    );
  }

  /// Convert TaxLien to Magento Product structure for saving
  Map<String, dynamic> toMagentoProduct(TaxLien lien) {
    final customAttrs = TaxLienAttributes(
      parcelId: lien.parcelId,
      taxAmount: lien.amount,
      interestRate: lien.interestRate,
      county: lien.county,
      state: lien.state,
      zipCode: lien.zipCode,
      address: lien.address,
      city: lien.city,
      status: lien.status,
      auctionDate: lien.auctionDate,
      ownerName: lien.ownerName,
      assessedValue: lien.assessedValue,
    );

    return {
      'sku': lien.parcelId,
      'name': '${lien.address}, ${lien.city}, ${lien.state}',
      'price': lien.amount,
      'status': 1,
      'type_id': 'simple',
      'attribute_set_id': 4,
      'custom_attributes': _adapter
          .toCustomAttributes(customAttrs)
          .map((attr) => {
                'attribute_code': attr.attributeCode,
                'value': attr.value,
              })
          .toList(),
    };
  }

  /// Build search filters for Magento API
  Map<String, dynamic> buildSearchFilters({
    String? state,
    String? county,
    String? city,
    double? minAmount,
    double? maxAmount,
    double? minInterestRate,
    double? maxInterestRate,
    String? status,
  }) {
    final filters = <String, dynamic>{};

    if (state != null) {
      filters['customAttributes.state'] = {'eq': state};
    }

    if (county != null) {
      filters['customAttributes.county'] = {'eq': county};
    }

    if (city != null) {
      filters['customAttributes.city'] = {'like': '%$city%'};
    }

    if (status != null) {
      filters['customAttributes.status'] = {'eq': status};
    }

    if (minAmount != null || maxAmount != null) {
      final rangeFilter = <String, String>{};
      if (minAmount != null) rangeFilter['from'] = minAmount.toString();
      if (maxAmount != null) rangeFilter['to'] = maxAmount.toString();
      filters['price'] = {'range': rangeFilter};
    }

    if (minInterestRate != null || maxInterestRate != null) {
      final rangeFilter = <String, String>{};
      if (minInterestRate != null)
        rangeFilter['from'] = minInterestRate.toString();
      if (maxInterestRate != null)
        rangeFilter['to'] = maxInterestRate.toString();
      filters['customAttributes.interest_rate'] = {'range': rangeFilter};
    }

    return filters;
  }

  /// Extract part from product name (e.g., "Address, City, ST")
  String _extractFromName(String name, int partIndex) {
    final parts = name.split(',');
    if (parts.length > partIndex) {
      return parts[partIndex].trim();
    }
    return 'N/A';
  }

  /// Validate TaxLien data
  ValidationResult validateTaxLien(TaxLien lien) {
    final customAttrs = TaxLienAttributes(
      parcelId: lien.parcelId,
      taxAmount: lien.amount,
      interestRate: lien.interestRate,
      county: lien.county,
      state: lien.state,
      assessedValue: lien.assessedValue,
    );

    return _adapter.validate(customAttrs);
  }
}

/// Extension methods for working with TaxLien products
extension TaxLienProductExtension on Product {
  /// Convert to TaxLien using adapter
  TaxLien toTaxLien() {
    return TaxLienMagentoAdapter().fromMagentoProduct(this);
  }

  /// Get custom attribute value by code
  String? getCustomAttributeValue(String code) {
    if (customAttributes == null) return null;

    try {
      final attr = customAttributes!.firstWhere(
        (attr) => attr.attributeCode == code,
      );
      return attr.value;
    } catch (_) {
      return null;
    }
  }

  /// Check if product is a tax lien
  bool isTaxLien() {
    return getCustomAttributeValue('parcel_id') != null ||
        getCustomAttributeValue('tax_amount') != null;
  }
}


