import '../model/faq.dart';
import '../model/profile.dart';
import '../ui/pages/profile/providers/profile_provider.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final faqRepositoryProvider = Provider((ref) => FaqRepository(ref));

class FaqRepository {
  final Ref _ref;
  FaqRepository(this._ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Profile get _profile => _ref.read(profileProvider).value!;

  Future<List<String>> get categoriesFuture => _firestore
      .collection(Constants.faqCategories)
      .doc(Constants.faqCategories)
      .get()
      .then((event) => event.data()![Constants.values].cast<String>());

  Future<List<Faq>> faqsFuture(String category) => _firestore
      .collection(Constants.faqs)
      .where(Constants.category, isEqualTo: category)
      .orderBy(Constants.createdAt)
      .get()
      .then(
        (value) => value.docs
            .map(
              (e) => Faq.fromMap(e),
            )
            .toList(),
      );

  void review(String id, bool value) {
    final _batch = _firestore.batch();
    _batch.update(
        _firestore.collection(Constants.faqs).doc(id),
        value
            ? {
                Constants.helpful: FieldValue.increment(1),
              }
            : {
                Constants.notHelpful: FieldValue.increment(1),
              });

    _batch.update(_firestore.collection(Constants.users).doc(_profile.id), {
      Constants.reviewedFaqs:
          _profile.reviewedFaqs != null ? FieldValue.arrayUnion([id]) : [id],
    });
    _batch.commit();
  }
}
