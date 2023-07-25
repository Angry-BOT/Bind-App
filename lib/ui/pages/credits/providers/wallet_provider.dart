import '../../../../model/wallet.dart';
import '../../../../repository/credits_repository_provider.dart';
import '../../auth/providers/auth_view_model_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletProvider = StreamProvider<Wallet>(
  (ref) => ref.read(creditsRepositoryProvider).streamWallet(ref.watch(authViewModelProvider).user?.uid??''),
);
