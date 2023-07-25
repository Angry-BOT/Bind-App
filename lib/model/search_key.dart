class SearchKey {
  final String key;
  final KeyType type;

  SearchKey({
    required this.key,
    required this.type,
  });
}

enum KeyType { Store, Product }
