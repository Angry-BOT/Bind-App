import '../../../../../model/product.dart';
import '../../../../../repository/products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsProvider = StreamProvider.family<List<Product>, String>(
  (ref, id) => ref.read(productsRepositoryProvider).productsStream(id),
);
