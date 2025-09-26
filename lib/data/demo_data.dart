import 'dart:convert';

/// Demo data for TaxLien.online mobile app
/// Compatible with flutter_magento 3.2.0
class TaxLienDemoData {
  static const String _demoDataJson = '''
{
  "store": {
    "id": 1,
    "code": "default",
    "name": "TaxLien.online",
    "website_id": 1,
    "store_group_id": 1,
    "is_active": true
  },
  "categories": [
    {
      "id": 1,
      "name": "Tax Liens",
      "is_active": true,
      "position": 1,
      "level": 1,
      "path": "1",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Premium tax lien certificates from various counties across the United States"
        }
      ]
    },
    {
      "id": 2,
      "name": "Florida",
      "parent_id": 1,
      "is_active": true,
      "position": 1,
      "level": 2,
      "path": "1/2",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Florida counties"
        },
        {
          "attribute_code": "state_code",
          "value": "FL"
        }
      ]
    },
    {
      "id": 3,
      "name": "Texas",
      "parent_id": 1,
      "is_active": true,
      "position": 2,
      "level": 2,
      "path": "1/3",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Texas counties"
        },
        {
          "attribute_code": "state_code",
          "value": "TX"
        }
      ]
    },
    {
      "id": 4,
      "name": "California",
      "parent_id": 1,
      "is_active": true,
      "position": 3,
      "level": 2,
      "path": "1/4",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from California counties"
        },
        {
          "attribute_code": "state_code",
          "value": "CA"
        }
      ]
    },
    {
      "id": 5,
      "name": "New York",
      "parent_id": 1,
      "is_active": true,
      "position": 4,
      "level": 2,
      "path": "1/5",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from New York counties"
        },
        {
          "attribute_code": "state_code",
          "value": "NY"
        }
      ]
    },
    {
      "id": 6,
      "name": "Arizona",
      "parent_id": 1,
      "is_active": true,
      "position": 5,
      "level": 2,
      "path": "1/6",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Arizona counties"
        },
        {
          "attribute_code": "state_code",
          "value": "AZ"
        }
      ]
    },
    {
      "id": 7,
      "name": "Georgia",
      "parent_id": 1,
      "is_active": true,
      "position": 6,
      "level": 2,
      "path": "1/7",
      "available_sort_by": ["position", "name", "price"],
      "include_in_menu": true,
      "custom_attributes": [
        {
          "attribute_code": "description",
          "value": "Tax lien certificates from Georgia counties"
        },
        {
          "attribute_code": "state_code",
          "value": "GA"
        }
      ]
    }
  ],
  "products": [
    {
      "id": 1,
      "sku": "TL-FL-001",
      "name": "Columbia County Tax Lien - 123 Main St",
      "type_id": "tax_lien",
      "attribute_set_id": 4,
      "price": 1250.00,
      "status": 1,
      "visibility": 4,
      "weight": 0,
      "created_at": "2024-01-15 10:00:00",
      "updated_at": "2024-01-15 10:00:00",
      "extension_attributes": {
        "stock_item": {
          "item_id": 1,
          "product_id": 1,
          "stock_id": 1,
          "qty": 1,
          "is_in_stock": true,
          "is_qty_decimal": false,
          "use_config_min_qty": true,
          "min_qty": 0,
          "use_config_min_sale_qty": 1,
          "min_sale_qty": 1,
          "use_config_max_sale_qty": true,
          "max_sale_qty": 10000,
          "use_config_backorders": true,
          "backorders": 0,
          "use_config_notify_stock_qty": true,
          "notify_stock_qty": 1,
          "use_config_qty_increments": true,
          "qty_increments": 1,
          "use_config_enable_qty_inc": true,
          "enable_qty_increments": false,
          "use_config_manage_stock": true,
          "manage_stock": true,
          "low_stock_date": null,
          "is_decimal_divided": false,
          "stock_status_changed_auto": 0
        }
      },
      "custom_attributes": [
        {
          "attribute_code": "parcel_id",
          "value": "R00051-000"
        },
        {
          "attribute_code": "property_address",
          "value": "123 Main St, Columbia, FL 32025"
        },
        {
          "attribute_code": "county",
          "value": "Columbia"
        },
        {
          "attribute_code": "state",
          "value": "FL"
        },
        {
          "attribute_code": "owner_name",
          "value": "John Smith"
        },
        {
          "attribute_code": "assessed_value",
          "value": "85000.00"
        },
        {
          "attribute_code": "tax_amount",
          "value": "1250.00"
        },
        {
          "attribute_code": "interest_rate",
          "value": "18.0"
        },
        {
          "attribute_code": "auction_date",
          "value": "2024-01-15"
        },
        {
          "attribute_code": "redemption_deadline",
          "value": "2025-01-15"
        },
        {
          "attribute_code": "lien_status",
          "value": "available"
        },
        {
          "attribute_code": "description",
          "value": "Premium tax lien certificate for residential property in Columbia County, Florida. High assessed value with competitive interest rate."
        },
        {
          "attribute_code": "short_description",
          "value": "Columbia County Tax Lien - Residential Property"
        }
      ]
    },
    {
      "id": 2,
      "sku": "TL-FL-002",
      "name": "Dixie County Tax Lien - 456 Oak Ave",
      "type_id": "tax_lien",
      "attribute_set_id": 4,
      "price": 1800.00,
      "status": 1,
      "visibility": 4,
      "weight": 0,
      "created_at": "2024-02-20 10:00:00",
      "updated_at": "2024-02-20 10:00:00",
      "extension_attributes": {
        "stock_item": {
          "item_id": 2,
          "product_id": 2,
          "stock_id": 1,
          "qty": 1,
          "is_in_stock": true,
          "is_qty_decimal": false,
          "use_config_min_qty": true,
          "min_qty": 0,
          "use_config_min_sale_qty": 1,
          "min_sale_qty": 1,
          "use_config_max_sale_qty": true,
          "max_sale_qty": 10000,
          "use_config_backorders": true,
          "backorders": 0,
          "use_config_notify_stock_qty": true,
          "notify_stock_qty": 1,
          "use_config_qty_increments": true,
          "qty_increments": 1,
          "use_config_enable_qty_inc": true,
          "enable_qty_increments": false,
          "use_config_manage_stock": true,
          "manage_stock": true,
          "low_stock_date": null,
          "is_decimal_divided": false,
          "stock_status_changed_auto": 0
        }
      },
      "custom_attributes": [
        {
          "attribute_code": "parcel_id",
          "value": "340913449600000040"
        },
        {
          "attribute_code": "property_address",
          "value": "456 Oak Ave, Dixie, FL 32329"
        },
        {
          "attribute_code": "county",
          "value": "Dixie"
        },
        {
          "attribute_code": "state",
          "value": "FL"
        },
        {
          "attribute_code": "owner_name",
          "value": "Mary Johnson"
        },
        {
          "attribute_code": "assessed_value",
          "value": "120000.00"
        },
        {
          "attribute_code": "tax_amount",
          "value": "1800.00"
        },
        {
          "attribute_code": "interest_rate",
          "value": "18.0"
        },
        {
          "attribute_code": "auction_date",
          "value": "2024-02-20"
        },
        {
          "attribute_code": "redemption_deadline",
          "value": "2025-02-20"
        },
        {
          "attribute_code": "lien_status",
          "value": "available"
        },
        {
          "attribute_code": "description",
          "value": "High-value tax lien certificate for commercial property in Dixie County, Florida. Excellent investment opportunity with strong assessed value."
        },
        {
          "attribute_code": "short_description",
          "value": "Dixie County Tax Lien - Commercial Property"
        }
      ]
    },
    {
      "id": 3,
      "sku": "TL-FL-003",
      "name": "Lafayette County Tax Lien - 789 Pine Rd",
      "type_id": "tax_lien",
      "attribute_set_id": 4,
      "price": 1425.00,
      "status": 1,
      "visibility": 4,
      "weight": 0,
      "created_at": "2024-03-10 10:00:00",
      "updated_at": "2024-03-10 10:00:00",
      "extension_attributes": {
        "stock_item": {
          "item_id": 3,
          "product_id": 3,
          "stock_id": 1,
          "qty": 1,
          "is_in_stock": true,
          "is_qty_decimal": false,
          "use_config_min_qty": true,
          "min_qty": 0,
          "use_config_min_sale_qty": 1,
          "min_sale_qty": 1,
          "use_config_max_sale_qty": true,
          "max_sale_qty": 10000,
          "use_config_backorders": true,
          "backorders": 0,
          "use_config_notify_stock_qty": true,
          "notify_stock_qty": 1,
          "use_config_qty_increments": true,
          "qty_increments": 1,
          "use_config_enable_qty_inc": true,
          "enable_qty_increments": false,
          "use_config_manage_stock": true,
          "manage_stock": true,
          "low_stock_date": null,
          "is_decimal_divided": false,
          "stock_status_changed_auto": 0
        }
      },
      "custom_attributes": [
        {
          "attribute_code": "parcel_id",
          "value": "L00001-000"
        },
        {
          "attribute_code": "property_address",
          "value": "789 Pine Rd, Lafayette, FL 32060"
        },
        {
          "attribute_code": "county",
          "value": "Lafayette"
        },
        {
          "attribute_code": "state",
          "value": "FL"
        },
        {
          "attribute_code": "owner_name",
          "value": "Robert Wilson"
        },
        {
          "attribute_code": "assessed_value",
          "value": "95000.00"
        },
        {
          "attribute_code": "tax_amount",
          "value": "1425.00"
        },
        {
          "attribute_code": "interest_rate",
          "value": "18.0"
        },
        {
          "attribute_code": "auction_date",
          "value": "2024-03-10"
        },
        {
          "attribute_code": "redemption_deadline",
          "value": "2025-03-10"
        },
        {
          "attribute_code": "lien_status",
          "value": "available"
        },
        {
          "attribute_code": "description",
          "value": "Residential tax lien certificate in Lafayette County, Florida. Moderate assessed value with standard interest rate."
        },
        {
          "attribute_code": "short_description",
          "value": "Lafayette County Tax Lien - Residential Property"
        }
      ]
    },
    {
      "id": 4,
      "sku": "TL-TX-001",
      "name": "Harris County Tax Lien - 321 Elm St",
      "type_id": "tax_lien",
      "attribute_set_id": 4,
      "price": 2250.00,
      "status": 1,
      "visibility": 4,
      "weight": 0,
      "created_at": "2024-04-05 10:00:00",
      "updated_at": "2024-04-05 10:00:00",
      "extension_attributes": {
        "stock_item": {
          "item_id": 4,
          "product_id": 4,
          "stock_id": 1,
          "qty": 1,
          "is_in_stock": true,
          "is_qty_decimal": false,
          "use_config_min_qty": true,
          "min_qty": 0,
          "use_config_min_sale_qty": 1,
          "min_sale_qty": 1,
          "use_config_max_sale_qty": true,
          "max_sale_qty": 10000,
          "use_config_backorders": true,
          "backorders": 0,
          "use_config_notify_stock_qty": true,
          "notify_stock_qty": 1,
          "use_config_qty_increments": true,
          "qty_increments": 1,
          "use_config_enable_qty_inc": true,
          "enable_qty_increments": false,
          "use_config_manage_stock": true,
          "manage_stock": true,
          "low_stock_date": null,
          "is_decimal_divided": false,
          "stock_status_changed_auto": 0
        }
      },
      "custom_attributes": [
        {
          "attribute_code": "parcel_id",
          "value": "P00001-000"
        },
        {
          "attribute_code": "property_address",
          "value": "321 Elm St, Houston, TX 77001"
        },
        {
          "attribute_code": "county",
          "value": "Harris"
        },
        {
          "attribute_code": "state",
          "value": "TX"
        },
        {
          "attribute_code": "owner_name",
          "value": "Sarah Davis"
        },
        {
          "attribute_code": "assessed_value",
          "value": "150000.00"
        },
        {
          "attribute_code": "tax_amount",
          "value": "2250.00"
        },
        {
          "attribute_code": "interest_rate",
          "value": "12.0"
        },
        {
          "attribute_code": "auction_date",
          "value": "2024-04-05"
        },
        {
          "attribute_code": "redemption_deadline",
          "value": "2025-04-05"
        },
        {
          "attribute_code": "lien_status",
          "value": "available"
        },
        {
          "attribute_code": "description",
          "value": "High-value tax lien certificate in Harris County, Texas. Urban location with strong assessed value and competitive interest rate."
        },
        {
          "attribute_code": "short_description",
          "value": "Harris County Tax Lien - Urban Property"
        }
      ]
    }
  ],
  "customers": [
    {
      "id": 1,
      "email": "john.investor@example.com",
      "firstname": "John",
      "lastname": "Investor",
      "created_at": "2024-01-01 10:00:00",
      "updated_at": "2024-01-01 10:00:00",
      "store_id": 1,
      "website_id": 1,
      "group_id": 1,
      "created_in": "Default Store View",
      "email": "john.investor@example.com",
      "firstname": "John",
      "lastname": "Investor",
      "middlename": null,
      "prefix": null,
      "suffix": null,
      "dob": "1980-01-15",
      "taxvat": null,
      "gender": 1,
      "is_active": 1,
      "disable_auto_group_change": 0,
      "custom_attributes": [
        {
          "attribute_code": "investor_type",
          "value": "individual"
        },
        {
          "attribute_code": "investment_experience",
          "value": "intermediate"
        },
        {
          "attribute_code": "preferred_counties",
          "value": "FL, TX, CA"
        },
        {
          "attribute_code": "max_investment_amount",
          "value": "50000.00"
        }
      ]
    },
    {
      "id": 2,
      "email": "sarah.trader@example.com",
      "firstname": "Sarah",
      "lastname": "Trader",
      "created_at": "2024-01-15 10:00:00",
      "updated_at": "2024-01-15 10:00:00",
      "store_id": 1,
      "website_id": 1,
      "group_id": 1,
      "created_in": "Default Store View",
      "email": "sarah.trader@example.com",
      "firstname": "Sarah",
      "lastname": "Trader",
      "middlename": null,
      "prefix": null,
      "suffix": null,
      "dob": "1975-05-20",
      "taxvat": null,
      "gender": 2,
      "is_active": 1,
      "disable_auto_group_change": 0,
      "custom_attributes": [
        {
          "attribute_code": "investor_type",
          "value": "professional"
        },
        {
          "attribute_code": "investment_experience",
          "value": "expert"
        },
        {
          "attribute_code": "preferred_counties",
          "value": "FL, TX, NY, CA"
        },
        {
          "attribute_code": "max_investment_amount",
          "value": "200000.00"
        }
      ]
    }
  ],
  "orders": [
    {
      "entity_id": 1,
      "state": "complete",
      "status": "complete",
      "coupon_code": null,
      "protect_code": "a1b2c3d4",
      "shipping_description": "Digital Delivery",
      "is_virtual": 1,
      "store_id": 1,
      "customer_id": 1,
      "base_discount_amount": 0.00,
      "base_discount_canceled": null,
      "base_discount_invoiced": null,
      "base_discount_refunded": null,
      "base_grand_total": 1250.00,
      "base_shipping_amount": 0.00,
      "base_shipping_canceled": null,
      "base_shipping_invoiced": null,
      "base_shipping_refunded": null,
      "base_shipping_tax_amount": 0.00,
      "base_shipping_tax_refunded": null,
      "base_subtotal": 1250.00,
      "base_tax_amount": 0.00,
      "base_tax_canceled": null,
      "base_tax_invoiced": null,
      "base_tax_refunded": null,
      "base_to_global_rate": 1.0000,
      "base_to_order_rate": 1.0000,
      "base_total_canceled": null,
      "base_total_invoiced": 1250.00,
      "base_total_invoiced_cost": null,
      "base_total_offline_refunded": null,
      "base_total_online_refunded": null,
      "base_total_paid": 1250.00,
      "base_total_qty_ordered": 1,
      "base_total_refunded": null,
      "discount_amount": 0.00,
      "discount_canceled": null,
      "discount_invoiced": null,
      "discount_refunded": null,
      "grand_total": 1250.00,
      "shipping_amount": 0.00,
      "shipping_canceled": null,
      "shipping_invoiced": null,
      "shipping_refunded": null,
      "shipping_tax_amount": 0.00,
      "shipping_tax_refunded": null,
      "store_to_base_rate": 1.0000,
      "store_to_order_rate": 1.0000,
      "subtotal": 1250.00,
      "tax_amount": 0.00,
      "tax_canceled": null,
      "tax_invoiced": null,
      "tax_refunded": null,
      "total_canceled": null,
      "total_invoiced": 1250.00,
      "total_offline_refunded": null,
      "total_online_refunded": null,
      "total_paid": 1250.00,
      "total_qty_ordered": 1,
      "total_refunded": null,
      "can_ship_partially": null,
      "can_ship_partially_item": null,
      "customer_is_guest": 0,
      "customer_note_notify": 1,
      "billing_address_id": 1,
      "customer_group_id": 1,
      "edit_increment": null,
      "email_sent": 1,
      "send_email": null,
      "forced_shipment_with_invoice": null,
      "payment_auth_expiration": null,
      "quote_address_id": null,
      "quote_id": null,
      "adjustment_negative": null,
      "adjustment_positive": null,
      "base_adjustment_negative": null,
      "base_adjustment_positive": null,
      "base_shipping_discount_amount": 0.00,
      "base_subtotal_incl_tax": 1250.00,
      "base_total_due": null,
      "payment_authorization_amount": null,
      "shipping_discount_amount": 0.00,
      "subtotal_incl_tax": 1250.00,
      "total_due": null,
      "weight": 0.0000,
      "customer_dob": "1980-01-15 00:00:00",
      "increment_id": "000000001",
      "applied_rule_ids": null,
      "base_currency_code": "USD",
      "customer_email": "john.investor@example.com",
      "customer_firstname": "John",
      "customer_lastname": "Investor",
      "customer_middlename": null,
      "customer_prefix": null,
      "customer_suffix": null,
      "customer_taxvat": null,
      "discount_description": null,
      "ext_customer_id": null,
      "ext_order_id": null,
      "global_currency_code": "USD",
      "hold_before_state": null,
      "hold_before_status": null,
      "order_currency_code": "USD",
      "original_increment_id": null,
      "relation_child_id": null,
      "relation_child_real_id": null,
      "relation_parent_id": null,
      "relation_parent_real_id": null,
      "remote_ip": "192.168.1.100",
      "shipping_method": "digital_delivery",
      "store_currency_code": "USD",
      "store_name": "TaxLien.online",
      "x_forwarded_for": null,
      "customer_note": "First tax lien investment",
      "created_at": "2024-01-15 10:30:00",
      "updated_at": "2024-01-15 10:30:00",
      "total_item_count": 1,
      "customer_gender": 1,
      "discount_tax_compensation_amount": null,
      "base_discount_tax_compensation_amount": null,
      "shipping_discount_tax_compensation_amount": null,
      "base_shipping_discount_tax_compensation_amnt": null,
      "discount_tax_compensation_invoiced": null,
      "base_discount_tax_compensation_invoiced": null,
      "discount_tax_compensation_refunded": null,
      "base_discount_tax_compensation_refunded": null,
      "shipping_incl_tax": 0.00,
      "base_shipping_incl_tax": 0.00,
      "coupon_rule_name": null,
      "gift_message_id": null,
      "payment_authorization_expiration": null,
      "paypal_ipn_customer_notified": null,
      "items": [
        {
          "item_id": 1,
          "order_id": 1,
          "parent_item_id": null,
          "quote_item_id": 1,
          "store_id": 1,
          "created_at": "2024-01-15 10:30:00",
          "updated_at": "2024-01-15 10:30:00",
          "product_id": 1,
          "product_type": "tax_lien",
          "product_options": "{\\"info_buyRequest\\":{\\"uenc\\":\\"aHR0cHM6Ly90YXhsaWVuLm9ubGluZS9yZXN0L1YxL2NhdGVnb3JpZXMvMi9wcm9kdWN0cy\\",\\"product\\":\\"MSIs\\",\\"qty\\":1}}",
          "weight": 0.0000,
          "is_virtual": 1,
          "sku": "TL-FL-001",
          "name": "Columbia County Tax Lien - 123 Main St",
          "description": null,
          "applied_rule_ids": null,
          "additional_data": null,
          "is_qty_decimal": 0,
          "no_discount": 0,
          "qty_backordered": null,
          "qty_canceled": null,
          "qty_invoiced": 1,
          "qty_ordered": 1,
          "qty_refunded": null,
          "qty_shipped": null,
          "base_cost": null,
          "price": 1250.00,
          "base_price": 1250.00,
          "original_price": 1250.00,
          "base_original_price": 1250.00,
          "tax_percent": 0.00,
          "tax_amount": 0.00,
          "base_tax_amount": 0.00,
          "tax_invoiced": 0.00,
          "base_tax_invoiced": 0.00,
          "tax_refunded": null,
          "base_tax_refunded": null,
          "discount_amount": 0.00,
          "base_discount_amount": 0.00,
          "discount_invoiced": 0.00,
          "base_discount_invoiced": 0.00,
          "discount_refunded": null,
          "base_discount_refunded": null,
          "amount_refunded": null,
          "base_amount_refunded": null,
          "row_total": 1250.00,
          "base_row_total": 1250.00,
          "row_invoiced": 1250.00,
          "base_row_invoiced": 1250.00,
          "row_weight": 0.0000,
          "base_tax_before_discount": null,
          "tax_before_discount": null,
          "ext_order_item_id": null,
          "locked_do_invoice": null,
          "locked_do_ship": null,
          "price_incl_tax": 1250.00,
          "base_price_incl_tax": 1250.00,
          "row_total_incl_tax": 1250.00,
          "base_row_total_incl_tax": 1250.00,
          "discount_tax_compensation_amount": null,
          "base_discount_tax_compensation_amount": null,
          "discount_tax_compensation_invoiced": null,
          "base_discount_tax_compensation_invoiced": null,
          "discount_tax_compensation_refunded": null,
          "base_discount_tax_compensation_refunded": null,
          "tax_canceled": null,
          "discount_canceled": null,
          "tax_refunded": null,
          "base_tax_refunded": null,
          "discount_refunded": null,
          "base_discount_refunded": null,
          "gift_message_id": null,
          "gift_message_available": null,
          "free_shipping": null,
          "weee_tax_applied": null,
          "weee_tax_applied_amount": null,
          "weee_tax_applied_row_amount": null,
          "base_weee_tax_applied_amount": null,
          "base_weee_tax_applied_row_amnt": null,
          "weee_tax_disposition": null,
          "weee_tax_row_disposition": null,
          "base_weee_tax_disposition": null,
          "base_weee_tax_row_disposition": null,
          "event_id": null,
          "gw_id": null,
          "gw_base_price": null,
          "gw_price": null,
          "gw_base_price_invoiced": null,
          "gw_price_invoiced": null,
          "gw_base_price_refunded": null,
          "gw_price_refunded": null,
          "gw_base_tax_amount": null,
          "gw_tax_amount": null,
          "gw_base_tax_amount_invoiced": null,
          "gw_tax_amount_invoiced": null,
          "gw_base_tax_amount_refunded": null,
          "gw_tax_amount_refunded": null,
          "qty_returned": null,
          "qty_canceled": null,
          "qty_invoiced": 1,
          "qty_ordered": 1,
          "qty_refunded": null,
          "qty_shipped": null,
          "product_options": "{\\"info_buyRequest\\":{\\"uenc\\":\\"aHR0cHM6Ly90YXhsaWVuLm9ubGluZS9yZXN0L1YxL2NhdGVnb3JpZXMvMi9wcm9kdWN0cy\\",\\"product\\":\\"MSIs\\",\\"qty\\":1}}"
        }
      ],
      "billing_address": {
        "address_type": "billing",
        "customer_address_id": 1,
        "customer_id": 1,
        "email": "john.investor@example.com",
        "firstname": "John",
        "lastname": "Investor",
        "middlename": null,
        "prefix": null,
        "suffix": null,
        "company": null,
        "street": ["123 Investment Ave", "Suite 100"],
        "city": "Miami",
        "region": "Florida",
        "region_id": 12,
        "region_code": "FL",
        "postcode": "33101",
        "country_id": "US",
        "telephone": "305-555-0123",
        "fax": null,
        "vat_id": null,
        "vat_is_valid": null,
        "vat_request_id": null,
        "vat_request_date": null,
        "vat_request_success": null,
        "gift_registry_item_id": null
      },
      "payment": {
        "entity_id": 1,
        "parent_id": 1,
        "base_shipping_captured": null,
        "shipping_captured": null,
        "amount_refunded": null,
        "base_amount_paid": 1250.00,
        "amount_canceled": null,
        "base_amount_authorized": 1250.00,
        "base_amount_paid_online": 1250.00,
        "base_amount_refunded_online": null,
        "base_shipping_amount": 0.00,
        "shipping_amount": 0.00,
        "amount_paid": 1250.00,
        "amount_authorized": 1250.00,
        "base_amount_ordered": 1250.00,
        "base_shipping_refunded": null,
        "shipping_refunded": null,
        "base_amount_canceled": null,
        "quote_payment_id": 1,
        "additional_data": null,
        "additional_information": [
          "Credit Card ending in 1234",
          "Transaction ID: TXN123456789"
        ],
        "cc_exp_month": "12",
        "cc_ss_start_month": null,
        "echeck_bank_name": null,
        "method": "creditcard",
        "cc_debug_request_body": null,
        "cc_secure_verify": null,
        "protection_eligibility": null,
        "cc_approval": "AUTH123456",
        "cc_last_4": "1234",
        "cc_status_description": "Approved",
        "echeck_type": null,
        "cc_debug_response_serialized": null,
        "cc_ss_issue": null,
        "echeck_bank_acct_type": null,
        "cc_avs_status": "Y",
        "cc_number_enc": "encrypted_card_number",
        "cc_trans_id": "TXN123456789",
        "address_status": null,
        "additional_information": [
          "Credit Card ending in 1234",
          "Transaction ID: TXN123456789"
        ],
        "cc_exp_year": "2025",
        "cc_ss_start_year": null,
        "echeck_routing_number": null,
        "cc_debug_response_body": null,
        "cc_ss_status": null,
        "echeck_account_name": null,
        "cc_avs_address_verification": "Y",
        "cc_number": "encrypted_card_number",
        "cc_status": "1",
        "cc_owner": "John Investor",
        "cc_type": "VI",
        "po_number": null,
        "cc_exp_month": "12",
        "cc_ss_start_month": null,
        "echeck_bank_name": null,
        "method": "creditcard",
        "cc_debug_request_body": null,
        "cc_secure_verify": null,
        "protection_eligibility": null,
        "cc_approval": "AUTH123456",
        "cc_last_4": "1234",
        "cc_status_description": "Approved",
        "echeck_type": null,
        "cc_debug_response_serialized": null,
        "cc_ss_issue": null,
        "echeck_bank_acct_type": null,
        "cc_avs_status": "Y",
        "cc_number_enc": "encrypted_card_number",
        "cc_trans_id": "TXN123456789",
        "address_status": null,
        "additional_information": [
          "Credit Card ending in 1234",
          "Transaction ID: TXN123456789"
        ],
        "cc_exp_year": "2025",
        "cc_ss_start_year": null,
        "echeck_routing_number": null,
        "cc_debug_response_body": null,
        "cc_ss_status": null,
        "echeck_account_name": null,
        "cc_avs_address_verification": "Y",
        "cc_number": "encrypted_card_number",
        "cc_status": "1",
        "cc_owner": "John Investor",
        "cc_type": "VI",
        "po_number": null
      }
    }
  ],
  "cart": {
    "id": 1,
    "created_at": "2024-01-15 10:00:00",
    "updated_at": "2024-01-15 10:30:00",
    "converted_at": "2024-01-15 10:30:00",
    "is_active": 1,
    "is_virtual": 1,
    "is_multi_shipping": 0,
    "items_count": 1,
    "items_qty": 1,
    "orig_order_id": null,
    "store_id": 1,
    "trigger_recollect": 0,
    "abandoned_cart_notification": 0,
    "is_persistent": 0,
    "items": [
      {
        "item_id": 1,
        "sku": "TL-FL-001",
        "qty": 1,
        "name": "Columbia County Tax Lien - 123 Main St",
        "price": 1250.00,
        "product_type": "tax_lien",
        "quote_id": 1
      }
    ],
    "billing_address": {
      "id": 1,
      "region": "Florida",
      "region_id": 12,
      "region_code": "FL",
      "country_id": "US",
      "street": ["123 Investment Ave", "Suite 100"],
      "telephone": "305-555-0123",
      "postcode": "33101",
      "city": "Miami",
      "firstname": "John",
      "lastname": "Investor",
      "email": "john.investor@example.com"
    },
    "payment": {
      "method": "creditcard",
      "po_number": null,
      "additional_data": null,
      "additional_information": [
        "Credit Card ending in 1234"
      ]
    }
  }
}
''';

  static Map<String, dynamic> get demoData => json.decode(_demoDataJson);

  /// Get demo products
  static List<Map<String, dynamic>> get demoProducts {
    return List<Map<String, dynamic>>.from(demoData['products']);
  }

  /// Get demo categories
  static List<Map<String, dynamic>> get demoCategories {
    return List<Map<String, dynamic>>.from(demoData['categories']);
  }

  /// Get demo customers
  static List<Map<String, dynamic>> get demoCustomers {
    return List<Map<String, dynamic>>.from(demoData['customers']);
  }

  /// Get demo orders
  static List<Map<String, dynamic>> get demoOrders {
    return List<Map<String, dynamic>>.from(demoData['orders']);
  }

  /// Get demo cart
  static Map<String, dynamic> get demoCart {
    return Map<String, dynamic>.from(demoData['cart']);
  }

  /// Get demo store configuration
  static Map<String, dynamic> get demoStore {
    return Map<String, dynamic>.from(demoData['store']);
  }

  /// Get tax lien products by county
  static List<Map<String, dynamic>> getTaxLienProductsByCounty(String county) {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final countyAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'county',
        orElse: () => null,
      );

      return countyAttr != null && countyAttr['value'] == county;
    }).toList();
  }

  /// Get tax lien products by state
  static List<Map<String, dynamic>> getTaxLienProductsByState(String state) {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final stateAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'state',
        orElse: () => null,
      );

      return stateAttr != null && stateAttr['value'] == state;
    }).toList();
  }

  /// Get available tax liens (status = 'available')
  static List<Map<String, dynamic>> getAvailableTaxLiens() {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final statusAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'lien_status',
        orElse: () => null,
      );

      return statusAttr != null && statusAttr['value'] == 'available';
    }).toList();
  }

  /// Get sold tax liens (status = 'sold')
  static List<Map<String, dynamic>> getSoldTaxLiens() {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final statusAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'lien_status',
        orElse: () => null,
      );

      return statusAttr != null && statusAttr['value'] == 'sold';
    }).toList();
  }

  /// Get tax liens by price range
  static List<Map<String, dynamic>> getTaxLiensByPriceRange(
      double minPrice, double maxPrice) {
    return demoProducts.where((product) {
      final price = (product['price'] as num).toDouble();
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  /// Get tax liens by interest rate range
  static List<Map<String, dynamic>> getTaxLiensByInterestRateRange(
      double minRate, double maxRate) {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final rateAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'interest_rate',
        orElse: () => null,
      );

      if (rateAttr == null) return false;
      final rate = double.tryParse(rateAttr['value'].toString()) ?? 0.0;
      return rate >= minRate && rate <= maxRate;
    }).toList();
  }

  /// Get tax liens by assessed value range
  static List<Map<String, dynamic>> getTaxLiensByAssessedValueRange(
      double minValue, double maxValue) {
    return demoProducts.where((product) {
      final attributes = product['custom_attributes'] as List<dynamic>?;
      if (attributes == null) return false;

      final valueAttr = attributes.firstWhere(
        (attr) => attr['attribute_code'] == 'assessed_value',
        orElse: () => null,
      );

      if (valueAttr == null) return false;
      final value = double.tryParse(valueAttr['value'].toString()) ?? 0.0;
      return value >= minValue && value <= maxValue;
    }).toList();
  }
}
