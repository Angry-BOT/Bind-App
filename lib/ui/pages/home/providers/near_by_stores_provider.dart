import '../../../../enums/survicableRadius.dart';
import '../../../../model/store.dart';
import '../../../../repository/store_repository.dart';
import 'home_view_model_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



final nearByStoresProvider = FutureProvider<List<Store>>((ref) async {
  final GeoPoint point =
      ref.watch(homeViewModelProvider.select((value) => value.address!.point));

  final repository = ref.read(storeRepositoryProvider);
  final f1 = repository.nearByStoresStrea(
      point: point, survicableRadius: SurvicableRadius.r10);
  final f2 = repository.nearByStoresStrea(
      point: point, survicableRadius: SurvicableRadius.r35);
  final f3 = repository.nearByStoresStrea(
      point: point, survicableRadius: SurvicableRadius.panIndia);

  final l1 = await f1;
  final l2 = await f2;
  final l3 = await f3;

  return (l1 + l2 + l3)
      .where((element) => element.products.isNotEmpty && element.enabled)
      .toList();
});
