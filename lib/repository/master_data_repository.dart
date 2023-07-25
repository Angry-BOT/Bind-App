import '../model/master_data.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataRepositoryProvider = Provider(
  (ref) => MasterDataRepository(),
);

class MasterDataRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<MasterData> get masterDataStream => _firestore
      .collection(Constants.masterData)
      .doc(Constants.masterDataV1)
      .snapshots()
      .map(
        (value) => MasterData.fromMap(value),
      );

  // Future<MasterData> get masterDataFuture => _firestore
  //     .collection(Constants.masterData)
  //     .doc(Constants.masterDataV1)
  //     .get()
  //     .then(
  //       (value) => MasterData.fromMap(value),
  //     );
}
