import '../../../../core/services/local_database.dart';
import '../../model/repo_model.dart';

class ReposLocalDataSource {
  final LocalDataBaseService localDataBaseService;

  const ReposLocalDataSource({required this.localDataBaseService});

  Future<List<RepoModel>> getReposs({int skip = 0, int limit = 10}) async {
    final cachedData = await localDataBaseService.getData('cached_repos');
    if (cachedData.isEmpty) return [];

    final List<RepoModel> reposList = cachedData
        .map((map) => RepoModel.fromJson(Map<String, dynamic>.from(map as Map)))
        .toList();

    if (skip >= reposList.length) return [];

    final endIndex = skip + limit;
    return reposList.sublist(
      skip,
      endIndex > reposList.length ? reposList.length : endIndex,
    );
  }

  Future<void> saveRepossToCache({
    required List<RepoModel> repos,
    bool clear = false,
  }) async {
    final List<Map<String, dynamic>> newMaps =
        repos.map((e) => e.toJson()).toList();

    if (clear) {
      await localDataBaseService.saveData('cached_repos', newMaps);
    } else {
      final existingData = await localDataBaseService.getData('cached_repos');
      final List<RepoModel> existingReposs = existingData
          .map((map) => RepoModel.fromJson(Map<String, dynamic>.from(map as Map)))
          .toList();

      final existingIds = existingReposs.map((e) => e.id).toSet();
      final filteredNew = repos.where(
        (p) => !existingIds.contains(p.id),
      ).toList();

      if (filteredNew.isNotEmpty) {
        final newFilteredMaps = filteredNew.map((e) => e.toJson()).toList();
        await localDataBaseService.addData('cached_repos', newFilteredMaps);
      }
    }
  }
}
