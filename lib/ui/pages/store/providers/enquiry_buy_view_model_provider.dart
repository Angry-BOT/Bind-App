import '../../../../repository/credits_repository_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final enquiryBuyViewModelProvider =
    ChangeNotifierProvider((ref) => EnquiryBuyModel(ref));

class EnquiryBuyModel extends ChangeNotifier {
  final Ref ref;
  EnquiryBuyModel(this.ref);

  CreditsRepository get _repository => ref.read(creditsRepositoryProvider);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> buy(String id) async {
    loading = true;
    try {
      await _repository.buyEnquiry(enquiryId: id);
    } catch (e) {
      print(e);
    }
    loading = false;
  }
}
