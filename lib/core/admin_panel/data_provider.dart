/// Data provider interface for admin panel
abstract class AdminDataProvider {
  Future<ListResult> getList(
    String resource, {
    PaginationConfig? pagination,
    List<FilterConfig>? filters,
    SortConfig? sort,
  });

  Future<Map<String, dynamic>> getOne(String resource, String id);
  Future<Map<String, dynamic>> create(
      String resource, Map<String, dynamic> data);
  Future<Map<String, dynamic>> update(
      String resource, String id, Map<String, dynamic> data);
  Future<void> delete(String resource, String id);
  Future<List<Map<String, dynamic>>> getMany(String resource, List<String> ids);
  Future<void> deleteMany(String resource, List<String> ids);
  Future<void> updateMany(
      String resource, List<String> ids, Map<String, dynamic> data);
}

class ListResult {
  final List<Map<String, dynamic>> data;
  final int total;

  ListResult({required this.data, required this.total});
}

class PaginationConfig {
  final int page;
  final int pageSize;

  PaginationConfig({required this.page, required this.pageSize});
}

class FilterConfig {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  FilterConfig({
    required this.field,
    required this.operator,
    required this.value,
  });
}

enum FilterOperator {
  equals,
  notEquals,
  contains,
  startsWith,
  endsWith,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
  inList,
  notInList,
}

class SortConfig {
  final String field;
  final bool ascending;

  SortConfig({required this.field, required this.ascending});
}
