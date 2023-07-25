import 'package:algolia/algolia.dart';
import 'package:bind_app/enums/survicableRadius.dart';
import 'package:bind_app/model/store_result.dart';
import 'package:bind_app/providers/keys_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'FYG6YAT7CN',
    apiKey: 'd7479ad625f7ceb09d1ff191b8ecf2df',
  );
}

final algoliaRepositoryProvider = Provider((ref) => AlgoliaRepository(ref.read));

class AlgoliaRepository {
  final Reader _reader;
  Algolia algolia = Application.algolia;

  AlgoliaRepository(this._reader);
  Future<List<StoreResult>> search(String key) async {
    AlgoliaQuery query = algolia.instance.index(_reader(keysProvider).algoliaIndex).query(key);
    query = query
        .facetFilter('enabled:true')
        .facetFilter('survicableRadius:${SurvicableRadius.panIndia}');
    AlgoliaQuerySnapshot snap = await query.getObjects();
    print(snap.nbHits);
    return snap.hits
        .map((e) => StoreResult.fromMap(e.data))
        .where((element) => element.products.isNotEmpty)
        .toList();
  }
}
