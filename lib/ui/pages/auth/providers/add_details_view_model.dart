import 'package:bind_app/ui/pages/auth/providers/add_documents_view_model_provider.dart';

import '../../home/providers/sub_categories_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../enums/bussiness_type.dart';
import '../../../../model/profile.dart';
import '../../profile/providers/profile_provider.dart';

final addDetailsViewModelProvider =
    ChangeNotifierProvider((ref) => AddDetailsViewModel(ref));

class AddDetailsViewModel extends ChangeNotifier {
  final Ref _ref;
  AddDetailsViewModel(this._ref);


  Profile get _profile => _ref.read(profileProvider).value!;

  String? _category;
  String? get category => _category;
  set category(String? category) {
    _category = category;
    notifyListeners();
  }

  List<String> _subCategories = [];
  List<String> get subCategories => _subCategories;
  set subCategories(List<String> subCategories) {
    _subCategories = subCategories;
    notifyListeners();
  }

  BussinessType? _type;
  BussinessType? get type => _type;
  set type(BussinessType? type) {
    _type = type;
    notifyListeners();
  }

  String? _survicableRadius;
  String? get survicableRadius => _survicableRadius;
  set survicableRadius(String? survicableRadius) {
    _survicableRadius = survicableRadius;
    notifyListeners();
  }

  bool get isReady =>
      _category != null &&
      _subCategories.isNotEmpty &&
      _type != null &&
      _survicableRadius != null;

  void update() async {
    final updated = _profile.copyWith(
      isEntrepreneur: true,
      category: category,
      subCategories: _ref
          .watch(subcategoriesProvider(category!))
          .value!
          .where((element) => subCategories.contains(element.name))
          .map((e) => e.id)
          .toList(),
      type: type! == BussinessType.Both
          ? [BussinessType.Product, BussinessType.Service]
          : [type!],
      survicableRadius: survicableRadius,
    );
    
    _ref.read(addDocumentsViewModelProvider).profile = updated;
    
  }
}
