import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../constants/app_constants.dart';
import '../models/magento_models.dart';
import 'secure_storage_service.dart';

/// GraphQL service for Magento cloud integration
/// Provides advanced GraphQL queries and mutations for Magento backend
class MagentoGraphQLService extends ChangeNotifier {
  late GraphQLClient _client;
  bool _isInitialized = false;
  bool _isOnline = false;
  String? _customerToken;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isOnline => _isOnline;
  bool get isAuthenticated => _customerToken != null;
  String? get customerToken => _customerToken;

  MagentoGraphQLService() {
    _initializeClient();
    _checkConnectivity();
  }

  void _initializeClient() {
    final httpLink = HttpLink(
      AppConstants.magentoGraphQLEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Store': 'default',
      },
    );

    final authLink = AuthLink(
      getToken: () async {
        if (_customerToken != null) {
          return 'Bearer $_customerToken';
        }
        return null;
      },
    );

    final link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;

    // Listen for connectivity changes
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final wasOnline = _isOnline;
      _isOnline = results.isNotEmpty &&
          !results.every((result) => result == ConnectivityResult.none);

      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    });
  }

  // Authentication Methods

  /// Authenticate customer using GraphQL
  Future<bool> authenticateCustomer({
    required String email,
    required String password,
  }) async {
    if (!_isOnline) return false;

    const String mutation = '''
      mutation GenerateCustomerToken(\$email: String!, \$password: String!) {
        generateCustomerToken(email: \$email, password: \$password) {
          token
        }
      }
    ''';

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {
            'email': email,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Authentication Error: ${result.exception}');
        }
        return false;
      }

      final token = result.data?['generateCustomerToken']?['token'];
      if (token != null) {
        _customerToken = token;
        await SecureStorageService.saveString('customer_token', token);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Authentication error: $e');
      }
      return false;
    }
  }

  /// Create customer account using GraphQL
  Future<MagentoCustomer?> createCustomer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (!_isOnline) return null;

    const String mutation = '''
      mutation CreateCustomer(\$input: CustomerCreateInput!) {
        createCustomer(input: \$input) {
          customer {
            id
            email
            firstname
            lastname
            created_at
            updated_at
          }
        }
      }
    ''';

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
              'firstname': firstName,
              'lastname': lastName,
            },
          },
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Create Customer Error: ${result.exception}');
        }
        return null;
      }

      final customerData = result.data?['createCustomer']?['customer'];
      if (customerData != null) {
        return MagentoCustomer.fromJson(customerData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Create customer error: $e');
      }
      return null;
    }
  }

  /// Get current customer information
  Future<MagentoCustomer?> getCurrentCustomer() async {
    if (!_isOnline || !isAuthenticated) return null;

    const String query = '''
      query GetCustomer {
        customer {
          id
          email
          firstname
          lastname
          middlename
          prefix
          suffix
          date_of_birth
          taxvat
          gender
          group_id
          created_at
          updated_at
          addresses {
            id
            customer_id
            region {
              region_code
              region
              region_id
            }
            country_code
            street
            company
            telephone
            fax
            postcode
            city
            firstname
            lastname
            middlename
            prefix
            suffix
            vat_id
            default_shipping
            default_billing
          }
        }
      }
    ''';

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Get Customer Error: ${result.exception}');
        }
        return null;
      }

      final customerData = result.data?['customer'];
      if (customerData != null) {
        return MagentoCustomer.fromJson(customerData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get customer error: $e');
      }
      return null;
    }
  }

  // Product Methods

  /// Get products using GraphQL with advanced filtering
  Future<MagentoProductList?> getProducts({
    int currentPage = 1,
    int pageSize = AppConstants.defaultPageSize,
    String? searchQuery,
    List<String>? categoryIds,
    String? sortBy,
    String? sortDirection,
    Map<String, dynamic>? filters,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (!_isOnline) return null;

    String query = '''
      query GetProducts(
        \$currentPage: Int!,
        \$pageSize: Int!,
        \$search: String,
        \$filter: ProductAttributeFilterInput,
        \$sort: ProductAttributeSortInput
      ) {
        products(
          currentPage: \$currentPage,
          pageSize: \$pageSize,
          search: \$search,
          filter: \$filter,
          sort: \$sort
        ) {
          total_count
          page_info {
            current_page
            page_size
            total_pages
          }
          items {
            id
            sku
            name
            description {
              html
            }
            short_description {
              html
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                }
                final_price {
                  value
                  currency
                }
                discount {
                  amount_off
                  percent_off
                }
              }
            }
            weight
            type_id
            url_key
            status
            visibility
            categories {
              id
              name
              url_key
            }
            media_gallery_entries {
              id
              media_type
              label
              position
              disabled
              types
              file
            }
            stock_status
            only_x_left_in_stock
            created_at
            updated_at
          }
        }
      }
    ''';

    Map<String, dynamic> variables = {
      'currentPage': currentPage,
      'pageSize': pageSize,
    };

    if (searchQuery != null && searchQuery.isNotEmpty) {
      variables['search'] = searchQuery;
    }

    Map<String, dynamic> filterInput = {};

    if (categoryIds != null && categoryIds.isNotEmpty) {
      filterInput['category_id'] = {'in': categoryIds};
    }

    if (minPrice != null || maxPrice != null) {
      Map<String, dynamic> priceFilter = {};
      if (minPrice != null) priceFilter['from'] = minPrice.toString();
      if (maxPrice != null) priceFilter['to'] = maxPrice.toString();
      filterInput['price'] = priceFilter;
    }

    if (filters != null) {
      filterInput.addAll(filters);
    }

    if (filterInput.isNotEmpty) {
      variables['filter'] = filterInput;
    }

    if (sortBy != null) {
      variables['sort'] = {
        sortBy: sortDirection?.toUpperCase() ?? 'ASC',
      };
    }

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(query),
          variables: variables,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Get Products Error: ${result.exception}');
        }
        return null;
      }

      final productsData = result.data?['products'];
      if (productsData != null) {
        return _parseProductListFromGraphQL(productsData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get products error: $e');
      }
      return null;
    }
  }

  /// Get product by SKU using GraphQL
  Future<MagentoProduct?> getProduct(String sku) async {
    if (!_isOnline) return null;

    const String query = '''
      query GetProduct(\$sku: String!) {
        products(filter: { sku: { eq: \$sku } }) {
          items {
            id
            sku
            name
            description {
              html
            }
            short_description {
              html
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                }
                final_price {
                  value
                  currency
                }
                discount {
                  amount_off
                  percent_off
                }
              }
            }
            weight
            type_id
            url_key
            status
            visibility
            categories {
              id
              name
              url_key
            }
            media_gallery_entries {
              id
              media_type
              label
              position
              disabled
              types
              file
            }
            stock_status
            only_x_left_in_stock
            created_at
            updated_at
            ... on ConfigurableProduct {
              configurable_options {
                id
                attribute_code
                label
                position
                use_default
                attribute_id
                values {
                  value_index
                  label
                  store_label
                  default_label
                  use_default_value
                }
              }
              variants {
                product {
                  id
                  sku
                  name
                  stock_status
                  price_range {
                    minimum_price {
                      regular_price {
                        value
                        currency
                      }
                      final_price {
                        value
                        currency
                      }
                    }
                  }
                }
                attributes {
                  code
                  value_index
                  label
                }
              }
            }
          }
        }
      }
    ''';

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(query),
          variables: {'sku': sku},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Get Product Error: ${result.exception}');
        }
        return null;
      }

      final products = result.data?['products']?['items'];
      if (products != null && products.isNotEmpty) {
        return _parseProductFromGraphQL(products[0]);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get product error: $e');
      }
      return null;
    }
  }

  /// Get categories using GraphQL
  Future<List<MagentoCategory>?> getCategories() async {
    if (!_isOnline) return null;

    const String query = '''
      query GetCategories {
        categories {
          items {
            id
            name
            url_key
            description
            meta_title
            meta_description
            meta_keywords
            is_active
            position
            level
            product_count
            children {
              id
              name
              url_key
              description
              is_active
              position
              level
              product_count
            }
          }
        }
      }
    ''';

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Get Categories Error: ${result.exception}');
        }
        return null;
      }

      final categoriesData = result.data?['categories']?['items'];
      if (categoriesData != null) {
        return List<MagentoCategory>.from(
          categoriesData.map((json) => _parseCategoryFromGraphQL(json)),
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get categories error: $e');
      }
      return null;
    }
  }

  // Cart Methods

  /// Create cart using GraphQL
  Future<String?> createCart() async {
    if (!_isOnline) return null;

    const String mutation = '''
      mutation CreateEmptyCart {
        createEmptyCart
      }
    ''';

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(mutation),
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Create Cart Error: ${result.exception}');
        }
        return null;
      }

      return result.data?['createEmptyCart'];
    } catch (e) {
      if (kDebugMode) {
        print('Create cart error: $e');
      }
      return null;
    }
  }

  /// Add item to cart using GraphQL
  Future<bool> addToCart({
    required String cartId,
    required String sku,
    required int quantity,
    Map<String, dynamic>? selectedOptions,
  }) async {
    if (!_isOnline) return false;

    const String mutation = '''
      mutation AddProductsToCart(\$cartId: String!, \$cartItems: [CartItemInput!]!) {
        addProductsToCart(cartId: \$cartId, cartItems: \$cartItems) {
          cart {
            id
            items {
              id
              quantity
              product {
                sku
                name
              }
            }
          }
        }
      }
    ''';

    Map<String, dynamic> cartItem = {
      'sku': sku,
      'quantity': quantity,
    };

    if (selectedOptions != null) {
      cartItem['selected_options'] = selectedOptions;
    }

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {
            'cartId': cartId,
            'cartItems': [cartItem],
          },
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Add to Cart Error: ${result.exception}');
        }
        return false;
      }

      return result.data?['addProductsToCart']?['cart'] != null;
    } catch (e) {
      if (kDebugMode) {
        print('Add to cart error: $e');
      }
      return false;
    }
  }

  /// Get cart using GraphQL
  Future<MagentoCart?> getCart(String cartId) async {
    if (!_isOnline) return null;

    const String query = '''
      query GetCart(\$cartId: String!) {
        cart(cart_id: \$cartId) {
          id
          is_virtual
          items {
            id
            quantity
            product {
              id
              sku
              name
              price_range {
                minimum_price {
                  regular_price {
                    value
                    currency
                  }
                  final_price {
                    value
                    currency
                  }
                }
              }
            }
            prices {
              row_total {
                value
                currency
              }
              row_total_including_tax {
                value
                currency
              }
              total_item_discount {
                value
                currency
              }
            }
          }
          prices {
            grand_total {
              value
              currency
            }
            subtotal_excluding_tax {
              value
              currency
            }
            subtotal_including_tax {
              value
              currency
            }
            applied_taxes {
              amount {
                value
                currency
              }
              label
            }
            discounts {
              amount {
                value
                currency
              }
              label
            }
          }
          total_quantity
        }
      }
    ''';

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(query),
          variables: {'cartId': cartId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        if (kDebugMode) {
          print('GraphQL Get Cart Error: ${result.exception}');
        }
        return null;
      }

      final cartData = result.data?['cart'];
      if (cartData != null) {
        return _parseCartFromGraphQL(cartData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get cart error: $e');
      }
      return null;
    }
  }

  // Utility Methods

  /// Parse product list from GraphQL response
  MagentoProductList _parseProductListFromGraphQL(Map<String, dynamic> data) {
    final items = List<MagentoProduct>.from(
      data['items'].map((json) => _parseProductFromGraphQL(json)),
    );

    return MagentoProductList(
      items: items,
      totalCount: data['total_count'],
      searchCriteria: MagentoSearchCriteria(
        filterGroups: [],
        sortOrders: [],
        pageSize: data['page_info']['page_size'],
        currentPage: data['page_info']['current_page'],
      ),
    );
  }

  /// Parse product from GraphQL response
  MagentoProduct _parseProductFromGraphQL(Map<String, dynamic> json) {
    final priceRange = json['price_range']?['minimum_price'];
    final regularPrice = priceRange?['regular_price']?['value']?.toDouble();
    final finalPrice = priceRange?['final_price']?['value']?.toDouble();

    return MagentoProduct(
      sku: json['sku'],
      name: json['name'],
      description: json['description']?['html'],
      shortDescription: json['short_description']?['html'],
      price: regularPrice,
      specialPrice: finalPrice != regularPrice ? finalPrice : null,
      typeId: json['type_id'],
      urlKey: json['url_key'],
      isActive: json['status'] == 1,
      isVisible: json['visibility'] != 1,
      isInStock: json['stock_status'] == 'IN_STOCK',
      qty: json['only_x_left_in_stock'],
      categoryIds: json['categories'] != null
          ? List<String>.from(json['categories'].map((c) => c['id'].toString()))
          : null,
      mediaGalleryEntries: json['media_gallery_entries'] != null
          ? List<MagentoProductImage>.from(
              json['media_gallery_entries']
                  .map((x) => MagentoProductImage.fromJson(x)),
            )
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Parse category from GraphQL response
  MagentoCategory _parseCategoryFromGraphQL(Map<String, dynamic> json) {
    return MagentoCategory(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      position: json['position'],
      level: json['level'],
      urlKey: json['url_key'],
      description: json['description'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
      productCount: json['product_count'],
      childrenData: json['children'] != null
          ? List<MagentoCategory>.from(
              json['children'].map((x) => _parseCategoryFromGraphQL(x)),
            )
          : null,
    );
  }

  /// Parse cart from GraphQL response
  MagentoCart _parseCartFromGraphQL(Map<String, dynamic> json) {
    final items = json['items'] != null
        ? List<MagentoCartItem>.from(
            json['items'].map((x) => _parseCartItemFromGraphQL(x)),
          )
        : <MagentoCartItem>[];

    return MagentoCart(
      id: int.parse(json['id']),
      createdAt: DateTime.now(), // GraphQL doesn't return this
      updatedAt: DateTime.now(), // GraphQL doesn't return this
      isActive: true,
      isVirtual: json['is_virtual'] ?? false,
      items: items,
      itemsCount: items.length,
      itemsQty: json['total_quantity'] ?? 0,
      totals: json['prices'] != null
          ? _parseCartTotalsFromGraphQL(json['prices'])
          : null,
      currencyCode: json['prices']?['grand_total']?['currency'],
    );
  }

  /// Parse cart item from GraphQL response
  MagentoCartItem _parseCartItemFromGraphQL(Map<String, dynamic> json) {
    final product = json['product'];
    final prices = json['prices'];

    return MagentoCartItem(
      itemId: int.parse(json['id']),
      sku: product['sku'],
      qty: json['quantity'],
      name: product['name'],
      price: product['price_range']['minimum_price']['final_price']['value']
          .toDouble(),
      rowTotal: prices?['row_total']?['value']?.toDouble(),
      rowTotalWithDiscount:
          prices?['row_total_including_tax']?['value']?.toDouble(),
      discountAmount: prices?['total_item_discount']?['value']?.toDouble(),
    );
  }

  /// Parse cart totals from GraphQL response
  MagentoCartTotals _parseCartTotalsFromGraphQL(Map<String, dynamic> json) {
    return MagentoCartTotals(
      grandTotal: json['grand_total']['value'].toDouble(),
      baseGrandTotal: json['grand_total']['value'].toDouble(),
      subtotal: json['subtotal_excluding_tax']['value'].toDouble(),
      baseSubtotal: json['subtotal_excluding_tax']['value'].toDouble(),
      taxAmount: json['applied_taxes']?.isNotEmpty == true
          ? json['applied_taxes'][0]['amount']['value'].toDouble()
          : 0.0,
      discountAmount: json['discounts']?.isNotEmpty == true
          ? json['discounts'][0]['amount']['value'].toDouble()
          : 0.0,
      currencyCode: json['grand_total']['currency'],
    );
  }

  /// Logout and clear tokens
  void logout() {
    _customerToken = null;
    SecureStorageService.delete('customer_token');
    notifyListeners();
  }

  /// Initialize authentication from stored token
  Future<void> initializeAuth() async {
    final token = await SecureStorageService.getString('customer_token');
    if (token != null) {
      _customerToken = token;
      notifyListeners();
    }
  }
}
