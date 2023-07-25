import '../../../../model/order.dart';
import '../../../../repository/credits_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderProvider = StreamProvider.family<Order, String>(
  (ref, id) => ref.read(creditsRepositoryProvider).streamOrder(id),
);
