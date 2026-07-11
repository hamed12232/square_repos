import '../../../../core/services/notification_service.dart';
import '../entities/repo_entity.dart';
import '../repositry/repos_repository.dart';

class SyncRepositoriesUseCase {
  final ReposRepository repository;
  final NotificationService notificationService;

  const SyncRepositoriesUseCase({
    required this.repository,
    required this.notificationService,
  });

  Future<void> call() async {
    // 1. Read cached repositories from Hive
    final cachedRepos = await repository.getCachedRepos();
    final Set<int> cachedIds = cachedRepos.map((e) => e.id).toSet();

    // 2. Request page 1 from GitHub API (10 items)
    final remoteResult = await repository.getRemoteRepos(page: 1, perPage: 10);

    await remoteResult.fold(
      (failure) async {
        // Do nothing on remote fetch error in background sync
      },
      (remoteRepos) async {
        // 3. Compare repositories using repository id and detect newly added repositories
        final List<RepoEntity> newRepos = remoteRepos
            .where((repo) => !cachedIds.contains(repo.id))
            .toList();

        // 4. If new repositories exist, update cache and show local notification
        if (newRepos.isNotEmpty) {
          await repository.saveReposToCache(newRepos, clear: false);

          await notificationService.showNotification(
            title: 'New repositories found',
            body: '${newRepos.length} new repositories are available.',
          );
        }
      },
    );
  }
}
