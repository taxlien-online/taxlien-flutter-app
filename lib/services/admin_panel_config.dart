import 'package:flutter/material.dart';
import '../core/admin_panel/admin_config.dart';

/// Configuration for the Tax Lien Admin Panel
class TaxLienAdminConfig {
  /// Creates admin configuration for the Tax Lien system
  static AdminConfig createConfig() {
    return AdminConfig(
      appName: 'TaxLien Admin',
      supportedLanguages: ['en', 'ru', 'es', 'de', 'fr'],
      defaultLanguage: 'en',
    );
  }

  /// Creates resource definitions for the admin panel
  static List<AdminResource> createResources() {
    return [
      _createTaxLienResource(),
      _createDocumentResource(),
      _createPropertyMediaResource(),
      _createEducationalContentResource(),
      _createMarketIntelligenceResource(),
      _createLegalResourceResource(),
      _createUserResource(),
      _createNFTResource(),
      _createAuctionResource(),
    ];
  }

  /// Tax Lien / Properties Resource
  static AdminResource _createTaxLienResource() {
    return AdminResource(
      name: 'tax_liens',
      label: 'Tax Liens',
      icon: Icons.account_balance,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'parcel_id',
          label: 'Parcel ID',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'state',
          label: 'State',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'county',
          label: 'County',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'face_amount',
          label: 'Face Amount',
          type: ColumnType.number,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'property_amount',
          label: 'Property Amount',
          type: ColumnType.number,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'apr',
          label: 'APR (%)',
          type: ColumnType.number,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'status',
          label: 'Status',
          type: ColumnType.select,
          options: ['pending', 'active', 'sold', 'redeemed', 'cancelled'],
          sortable: true,
        ),
        const ColumnConfig(
          key: 'issue_date',
          label: 'Issue Date',
          type: ColumnType.date,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          visible: true,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Documents Resource
  static AdminResource _createDocumentResource() {
    return AdminResource(
      name: 'documents',
      label: 'Documents',
      icon: Icons.description,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'type',
          label: 'Type',
          type: ColumnType.select,
          options: ['pdf', 'image', 'audio', 'video'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'category',
          label: 'Category',
          type: ColumnType.select,
          options: ['legal', 'property', 'financial', 'educational'],
          sortable: true,
        ),
        const ColumnConfig(
          key: 'description',
          label: 'Description',
          type: ColumnType.richText,
        ),
        const ColumnConfig(
          key: 'file_size',
          label: 'File Size',
          type: ColumnType.number,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'path',
          label: 'Path',
          type: ColumnType.text,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Property Media Resource
  static AdminResource _createPropertyMediaResource() {
    return AdminResource(
      name: 'property_media',
      label: 'Property Media',
      icon: Icons.photo_library,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'property_id',
          label: 'Property ID',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'type',
          label: 'Type',
          type: ColumnType.select,
          options: ['photo', 'video', '360_tour', 'drone'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'description',
          label: 'Description',
          type: ColumnType.text,
        ),
        const ColumnConfig(
          key: 'path',
          label: 'Path',
          type: ColumnType.image,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Educational Content Resource
  static AdminResource _createEducationalContentResource() {
    return AdminResource(
      name: 'educational_content',
      label: 'Educational Content',
      icon: Icons.school,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'type',
          label: 'Type',
          type: ColumnType.select,
          options: ['video', 'article', 'webinar', 'course'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'difficulty',
          label: 'Difficulty',
          type: ColumnType.select,
          options: ['beginner', 'intermediate', 'advanced'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'description',
          label: 'Description',
          type: ColumnType.richText,
        ),
        const ColumnConfig(
          key: 'content',
          label: 'Content',
          type: ColumnType.richText,
        ),
        const ColumnConfig(
          key: 'duration',
          label: 'Duration (min)',
          type: ColumnType.number,
        ),
        const ColumnConfig(
          key: 'video_url',
          label: 'Video URL',
          type: ColumnType.url,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Market Intelligence Resource
  static AdminResource _createMarketIntelligenceResource() {
    return AdminResource(
      name: 'market_intelligence',
      label: 'Market Intelligence',
      icon: Icons.analytics,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'type',
          label: 'Type',
          type: ColumnType.select,
          options: ['report', 'analysis', 'forecast', 'news'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'description',
          label: 'Description',
          type: ColumnType.richText,
        ),
        const ColumnConfig(
          key: 'source',
          label: 'Source',
          type: ColumnType.text,
        ),
        const ColumnConfig(
          key: 'author',
          label: 'Author',
          type: ColumnType.text,
        ),
        const ColumnConfig(
          key: 'published_date',
          label: 'Published',
          type: ColumnType.date,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Legal Resource
  static AdminResource _createLegalResourceResource() {
    return AdminResource(
      name: 'legal_resources',
      label: 'Legal Resources',
      icon: Icons.gavel,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'type',
          label: 'Type',
          type: ColumnType.select,
          options: ['law', 'regulation', 'case_study', 'template'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'jurisdiction',
          label: 'Jurisdiction',
          type: ColumnType.text,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'category',
          label: 'Category',
          type: ColumnType.select,
          options: ['federal', 'state', 'local'],
        ),
        const ColumnConfig(
          key: 'description',
          label: 'Description',
          type: ColumnType.richText,
        ),
        const ColumnConfig(
          key: 'is_active',
          label: 'Active',
          type: ColumnType.bool,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'effective_date',
          label: 'Effective Date',
          type: ColumnType.date,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// Users Resource
  static AdminResource _createUserResource() {
    return AdminResource(
      name: 'users',
      label: 'Users',
      icon: Icons.people,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'email',
          label: 'Email',
          type: ColumnType.email,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'name',
          label: 'Name',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'role',
          label: 'Role',
          type: ColumnType.select,
          options: ['user', 'admin', 'super_admin'],
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'status',
          label: 'Status',
          type: ColumnType.select,
          options: ['active', 'inactive', 'suspended'],
          sortable: true,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'last_login',
          label: 'Last Login',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }

  /// NFT Resource
  static AdminResource _createNFTResource() {
    return AdminResource(
      name: 'nfts',
      label: 'NFTs',
      icon: Icons.token,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'Token ID',
          type: ColumnType.text,
          visible: true,
        ),
        const ColumnConfig(
          key: 'parcel_id',
          label: 'Parcel ID',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'owner',
          label: 'Owner',
          type: ColumnType.text,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'status',
          label: 'Status',
          type: ColumnType.select,
          options: ['pending', 'minted', 'invested', 'redeemed', 'cancelled'],
          sortable: true,
        ),
        const ColumnConfig(
          key: 'face_amount',
          label: 'Face Amount',
          type: ColumnType.number,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Minted',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: false,
      canEdit: true,
      canDelete: false,
    );
  }

  /// Auction Resource
  static AdminResource _createAuctionResource() {
    return AdminResource(
      name: 'auctions',
      label: 'Auctions',
      icon: Icons.gavel,
      columns: [
        const ColumnConfig(
          key: 'id',
          label: 'ID',
          type: ColumnType.text,
          visible: false,
        ),
        const ColumnConfig(
          key: 'title',
          label: 'Title',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'county',
          label: 'County',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'state',
          label: 'State',
          type: ColumnType.text,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'auction_date',
          label: 'Auction Date',
          type: ColumnType.datetime,
          required: true,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'status',
          label: 'Status',
          type: ColumnType.select,
          options: ['upcoming', 'live', 'completed', 'cancelled'],
          sortable: true,
        ),
        const ColumnConfig(
          key: 'total_liens',
          label: 'Total Liens',
          type: ColumnType.number,
          sortable: true,
        ),
        const ColumnConfig(
          key: 'created_at',
          label: 'Created',
          type: ColumnType.datetime,
          sortable: true,
        ),
      ],
      canCreate: true,
      canEdit: true,
      canDelete: true,
    );
  }
}
