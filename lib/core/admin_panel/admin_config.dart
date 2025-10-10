import 'package:flutter/material.dart';

/// Admin panel configuration
class AdminConfig {
  final String appName;
  final List<String> supportedLanguages;
  final String defaultLanguage;
  final ThemeData? theme;

  AdminConfig({
    required this.appName,
    this.supportedLanguages = const ['en'],
    this.defaultLanguage = 'en',
    this.theme,
  });
}

/// Resource definition for admin panel
class AdminResource {
  final String name;
  final String label;
  final IconData icon;
  final List<ColumnConfig> columns;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canExport;

  AdminResource({
    required this.name,
    required this.label,
    required this.icon,
    required this.columns,
    this.canCreate = true,
    this.canEdit = true,
    this.canDelete = true,
    this.canExport = true,
  });
}

/// Column configuration
class ColumnConfig {
  final String key;
  final String label;
  final ColumnType type;
  final bool required;
  final bool sortable;
  final bool visible;
  final List<String>? options;
  final String? reference;

  const ColumnConfig({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.sortable = false,
    this.visible = true,
    this.options,
    this.reference,
  });
}

enum ColumnType {
  text,
  number,
  bool,
  date,
  datetime,
  email,
  url,
  phone,
  select,
  multiSelect,
  image,
  file,
  richText,
  reference,
  json,
}
