import '../../../../model/address.dart';
import '../../../../model/enquiry.dart';
import '../../../../model/profile.dart';
import '../../../../model/store.dart';
import '../../../../repository/enquiry_repository.dart';
import '../../home/providers/home_view_model_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final enquireViewModelProvider =
    ChangeNotifierProvider.family<EnquireViewModel, String>(
        (ref, id) => EnquireViewModel(ref, id));

class EnquireViewModel extends ChangeNotifier {
  final Ref _ref;
  final String id;
  EnquireViewModel(this._ref, this.id);

  List<String> products = [];

  EnquiryRepository get _repository => _ref.read(enquiryRepositoryProvider);

  late Store  _store;
  void setStore(Store store){
    _store = store;
  }
  
  Profile get _profile => _ref.read(profileProvider).value!;

  void toggle(String value) {
    if (products.contains(value)) {
      products.remove(value);
    } else {
      products.add(value);
    }
    notifyListeners();
  }

  String _message = '';
  String get message => _message;
  set message(String message) {
    _message = message;
    notifyListeners();
  }

  bool get ready => message.isNotEmpty && products.isNotEmpty;

  Enquiry get enquiry => Enquiry(
        id: '',
        storeId: id,
        storeType: _store.type,
        customerId: _profile.id,
        storeName: _store.name,
        customerName: "${_profile.firstName} ${_profile.lastName}",
        address: _ref.read(homeViewModelProvider).address ??
            Address.empty(),
        message: message,
        products: products,
        createdAt: DateTime.now(),
        reviewed: false,
        username: _store.username,
        enquiryId: '',
        bought: false,
      );

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void enquire({required Function(Enquiry) onDone}) async {
    loading = true;
    try {
      final e = await _repository.sendEnquiry(
          enquiry: enquiry,
          categoryId: _store.category,
          subcategories: _store.subCategories);
      products = [];
      _message = '';
      onDone(e);
      _loading = false;
    } catch (e) {
      print(e);
      loading = false;
    }
  }
}
