import 'dart:io';

import '../../../../../model/product.dart';
import '../../../../../model/store.dart';
import '../../../../../repository/products_repository.dart';

import '../../providers/admin_store_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeProductViewModelProvider =
    ChangeNotifierProvider((ref) => WriteProductViewModel(ref));

class WriteProductViewModel extends ChangeNotifier {
  final Ref _ref;
  WriteProductViewModel(this._ref);

  ProductsRepository get _repository => _ref.read(productsRepositoryProvider);

  // Profile get _profile => _ref.read(profileProvider).value!;

  Store get _store => _ref.read(adminStoreProvider).value!;

  Product inital = Product.empty();

  String? get id => inital.id.isEmpty ? null : inital.id;

  String? get image => inital.image.isEmpty ? null : inital.image;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String? _description;
  String get description => _description ?? inital.description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  String? _name;
  String get name => _name ?? inital.name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  bool get priceOn {
    switch (priceOnEnquire) {
      case "Yes":
        return true;
      default:
        return false;
    }
  }

  List<String> get images => inital.images;
  
  void removeImage(String value){
     inital.images.remove(value);
     notifyListeners();
  }

  List<File> files = [];

  void addfile(File value){
    files.add(value);
    notifyListeners();
  }

  void removeFile(File value){
    files.remove(value);
    notifyListeners();
  }


  String? _priceOnEnquire;
  String? get priceOnEnquire =>
      _priceOnEnquire ??
      (inital.priceOnEnquire != null
          ? (inital.priceOnEnquire! ? "Yes" : "No")
          : null);
  set priceOnEnquire(String? priceOnEnquire) {
    _priceOnEnquire = priceOnEnquire;
    notifyListeners();
  }

  String? _unit;
  String? get unit => _unit ?? inital.unit;
  set unit(String? unit) {
    _unit = unit;
    notifyListeners();
  }

  double? _price;
  double? get price => _price ?? inital.price;
  set price(double? price) {
    _price = price;
    notifyListeners();
  }

  bool get isReady =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      (_file != null || inital.image.isNotEmpty) &&
      (!priceOn ? price != null && unit != null && unit!.isNotEmpty : true);

  void writeProduct({required VoidCallback onWrite}) async {
    final product = inital.copyWith(
      storeId: _store.id,
      name: name,
      description: description,
      priceOnEnquire: priceOn,
      unit: unit,
    );
    product.price = priceOn ? null : price;
    loading = true;

    try {
      await _repository.writeProduct(
        product: product,
        file: file,
        oldName: inital.name != name ? inital.name : null,
        files: files,
      );
      loading = false;
      onWrite();
    } catch (e) {
      print(e);
      loading = false;
    }
  }

  void clear() {
    inital = Product.empty();
    _name = null;
    _description = null;
    _price = null;
    _priceOnEnquire = null;
    _unit = null;
    file = null;
    files = [];
  }
}
