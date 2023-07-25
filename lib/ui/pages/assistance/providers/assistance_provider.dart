import '../../../../model/order.dart';
import '../../../../repository/order_repository.dart';
import '../../auth/providers/auth_view_model_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final assistanceProvider = StreamProvider<Order?>(
  (ref) => ref.read(orderRepositoryProvider).assistanceOrder(
        ref.watch(authViewModelProvider).user!.uid,
      ),
);
