import '../../../../repository/master_data_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataProvider = StreamProvider(
  (ref) => ref.read(masterDataRepositoryProvider).masterDataStream,
);
