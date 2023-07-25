import 'dart:io';

import '../ui/pages/auth/providers/auth_view_model_provider.dart';
import '../ui/pages/profile/providers/profile_provider.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firebase_utils/constants.dart';
import '../model/address.dart';
import '../model/profile.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository(ref));

class ProfileRepository {
  final Ref ref;
  ProfileRepository(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User get user => ref.read(authViewModelProvider).user!;
  Profile get _profile => ref.read(profileProvider).value!;

  Stream<Profile> profileStream(String id) => _firestore
      .collection(FirebaseKeys.users)
      .doc(id)
      .snapshots()
      .map((event) => Profile.fromFirestore(event));

  Future<Profile> profileFuture(String id) {
    return _firestore
        .collection(FirebaseKeys.users)
        .doc(id)
        .get()
        .then((event) => Profile.fromFirestore(event));
  }

  Stream<Profile> sellerProfileStream(String id) => _firestore
      .collection(FirebaseKeys.users)
      .doc(id)
      .snapshots()
      .map((event) => Profile.fromFirestore(event));

  Future<void> createProfile(Profile profile) async {
    await _firestore.collection(FirebaseKeys.users).doc(user.uid).set(
          profile.copyWith(mobile: user.phoneNumber).toCreateMap(),
        );
  }

  Future<void> addAddress(Address address) async {
    _firestore.collection(FirebaseKeys.users).doc(user.uid).update({
      FirebaseKeys.addresses: FieldValue.arrayUnion([address.toMap()])
    });
  }

  Future<void> completeEnterprenaurProfile({
    required Profile profile,
    File? aadhar,
    File? aadhar2,
    File? verification,
  }) async {
    String? aadharUrl;
    if (aadhar != null) {
      aadharUrl = await _uploadImage(FirebaseKeys.aadhar, aadhar);
    }
    String? aadharUrl2 = aadhar2 != null
        ? await _uploadImage(FirebaseKeys.aadhar + '2', aadhar2)
        : null;
    String? verificationUrl = verification != null
        ? await _uploadImage(FirebaseKeys.verification, verification)
        : null;

    _firestore.collection(FirebaseKeys.users).doc(profile.id).update(
          profile
              .copyWith(
                aadharImage: aadharUrl,
                verificationImage: verificationUrl,
                aadharImage2: aadharUrl2,
              )
              .toDetailsMap(),
        );
  }

  Future<String?> _uploadImage(String key, File file) async {
    final task = await _storage
        .ref(FirebaseKeys.documents)
        .child(user.uid + "_" + key)
        .putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<String?> getAlreadyExistedEmail(String email) async {
    return _firestore
        .collection(Constants.users)
        .where(Constants.emailAddress, isEqualTo: email)
        .get()
        .then(
          (value) => value.docs.isNotEmpty
              ? value.docs.first[Constants.emailAddress]
              : null,
        );
  }

  Future<String?> getAlreadyExistedAadhar(String aadhar) async {
    return _firestore
        .collection(Constants.users)
        .where(Constants.aadharId, isEqualTo: aadhar)
        .get()
        .then(
          (value) => value.docs.isNotEmpty
              ? value.docs.first[Constants.aadharId]
              : null,
        );
  }

  Future<String?> getAlreadyExistedUdyogAadhar(String aadhar) async {
    return _firestore
        .collection(Constants.users)
        .where(Constants.udyogAadharNumber, isEqualTo: aadhar)
        .get()
        .then(
          (value) => value.docs.isNotEmpty
              ? value.docs.first[Constants.udyogAadharNumber]
              : null,
        );
  }

  Future<String?> getAlreadyExistedMobile(String mobile) async {
    return _firestore
        .collection(Constants.users)
        .where(Constants.mobile, isEqualTo: mobile)
        .get()
        .then(
          (value) =>
              value.docs.isNotEmpty ? value.docs.first[Constants.mobile] : null,
        );
  }

  void toggleFavorite({required String id}) {
    if (!_profile.favorites.contains(id)) {
      _firestore.collection(Constants.users).doc(_profile.id).update({
        Constants.favorites: FieldValue.arrayUnion([id])
      });
    } else {
      _firestore.collection(Constants.users).doc(_profile.id).update({
        Constants.favorites: FieldValue.arrayRemove([id])
      });
    }
  }

  void toggleLike({required String id}) {
    final batch = _firestore.batch();
    if (!_profile.likes.contains(id)) {
      batch.update(_firestore.collection(Constants.users).doc(_profile.id), {
        Constants.likes: FieldValue.arrayUnion([id])
      });
    } else {
      batch.update(_firestore.collection(Constants.users).doc(_profile.id), {
        Constants.likes: FieldValue.arrayRemove([id])
      });
    }
    batch.update(_firestore.collection(Constants.posts).doc(id), {
      Constants.likes:
          FieldValue.increment(!_profile.likes.contains(id) ? 1 : -1)
    });
    batch.commit();
  }

  void toggleBookmark({required String id}) {
    final batch = _firestore.batch();
    if (!_profile.bookmarks.contains(id)) {
      batch.update(_firestore.collection(Constants.users).doc(_profile.id), {
        Constants.bookmarks: FieldValue.arrayUnion([id])
      });
    } else {
      batch.update(_firestore.collection(Constants.users).doc(_profile.id), {
        Constants.bookmarks: FieldValue.arrayRemove([id])
      });
    }
    batch.update(_firestore.collection(Constants.posts).doc(id), {
      Constants.bookmarks:
          FieldValue.increment(!_profile.bookmarks.contains(id) ? 1 : -1)
    });
    batch.commit();
  }

  Future<void> addUdyogAadhar({
    required String udyogAadharNumber,
    required File file,
  }) async {
    final String? udyogAadharUrl =
        await _uploadImage(FirebaseKeys.udyogAadhar, file);
    if (udyogAadharUrl == null) {
      return;
    }
    await _firestore.collection(FirebaseKeys.users).doc(user.uid).update({
      "udyogAadharNumber": udyogAadharNumber,
      "udyogAadhar": udyogAadharUrl,
      "isUdyogVerified": false,
    });
  }

  Future<void> update(Profile profile, {File? file}) async {
    String? image;

    if (file != null) {
      image = await _uploadImage('image', file);
    }
    await _firestore
        .collection(FirebaseKeys.users)
        .doc(profile.id)
        .update(profile
            .copyWith(
              image: image,
            )
            .editMap());
  }

  Future<void> deleteAddress(Address address, {Address? storeAddress}) async{
    final _batch = _firestore.batch();

    _batch.update(_firestore.collection(FirebaseKeys.users).doc(user.uid), {
      Constants.addresses: FieldValue.arrayRemove([address.toMap()])
    });

    // if (storeAddress != null) {
    //   _batch.update(
    //     _firestore.collection(Constants.stores).doc(user.uid),
    //     {
    //       Constants.point: Geoflutterfire()
    //           .point(
    //             latitude: storeAddress.point.latitude,
    //             longitude: storeAddress.point.longitude,
    //           )
    //           .data,
    //     },
    //   );
    // }
   await _batch.commit();
  }

  void saveToken(String token) {
    _firestore.collection(Constants.users).doc(user.uid).update({
      Constants.token: token,
    });
  }

  void saveSubCategories({required List<String> subcategories}) {
    final _batch = _firestore.batch();
    _batch.update(_firestore.collection(Constants.users).doc(user.uid), {
      Constants.subCategories: subcategories,
    });
    _batch.update(_firestore.collection(Constants.stores).doc(user.uid), {
      Constants.subCategories: subcategories,
    });
    _batch.commit();
  }

  // void deleteProfile(){
  //   _firestore.collection(Constants.users).doc(user.uid).delete();
  // }

}
