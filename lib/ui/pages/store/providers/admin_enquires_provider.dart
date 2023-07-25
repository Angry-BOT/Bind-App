import '../../../../utils/labels.dart';

import '../../../../model/enquiry.dart';
import '../../../../repository/enquiry_repository.dart';
import 'admin_store_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeEnquiresProvider = StreamProvider<List<Enquiry>>(
  (ref) => ref
      .read(enquiryRepositoryProvider)
      .pendingEnquiriesFuture(ref.watch(adminStoreProvider).value!.id),
);

// final updatedEnquiresProvider = StreamProvider<List<Enquiry>>(
//   (ref) => ref
//       .read(enquiryRepositoryProvider)
//       .updatedEnquiriesFuture(ref.watch(adminStoreProvider).value!.id),
// );

final storeEnquriesViewModelProvider =
    ChangeNotifierProvider.family<StoreEnquiriesViewModel, String>(
  (ref, type) {
    final model = StoreEnquiriesViewModel(
        ref, ref.watch(adminStoreProvider).value!.id, type);
    model.init();
    return model;
  },
);

class StoreEnquiriesViewModel extends ChangeNotifier {
  final Ref ref;
  final String id;
  final String key;
  StoreEnquiriesViewModel(this.ref, this.id, this.key);

  EnquiryRepository get _repository => ref.read(enquiryRepositoryProvider);

  List<DocumentSnapshot> _snapshots = [];

  List<Enquiry> get enquiries => _snapshots
      .map(
        (e) => Enquiry.fromMap(e),
      )
      .toList();

  List<Enquiry> get activeEnquires =>
      ref.watch(activeEnquiresProvider).asData?.value ?? [];

  Future<void> init() async {
    if (key == Labels.active) {
      return;
    }
    try {
      _snapshots = await _repository.otherEnquriesFuture(
          limit: 6, storeId: id, bought: key == Labels.bought);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool loading = true;
  bool busy = false;
  Future<void> loadMore() async {
    if (key == Labels.active) {
      return;
    }
    busy = true;
    var previous = _snapshots;
    try {
      _snapshots = _snapshots +
          await _repository.otherEnquriesFuture(
              limit: 4,
              last: _snapshots.last,
              storeId: id,
              bought: key == Labels.bought);
      if (_snapshots.length == previous.length) {
        loading = false;
      } else {
        loading = true;
      }
    } catch (e) {
      print(e.toString());
    }
    busy = false;
    notifyListeners();
  }
}
