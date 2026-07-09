import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/repo_entity.dart';
import '../../domain/repositry/repos_repository.dart';
import '../data_source/local/repos_local_data_source.dart';
import '../data_source/remote/repos_remote_data_source.dart';

class ReposRepositoryImpl implements ReposRepository {
  final ReposRemoteDataSource remoteDataSource;
  final ReposLocalDataSource localDataSource;

  const ReposRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<Failure, List<RepoEntity>>> getRepos({
    required int page,
    required int perPage,
  }) async* {
    final skip = (page - 1) * perPage;

    try {
      final cachedRepos = await localDataSource.getReposs(skip: skip, limit: perPage);
      if (cachedRepos.isNotEmpty) {
        yield Right(cachedRepos);
      }
    } catch (_) {
      // Ignore cache retrieval exceptions and proceed to network fetch
    }
    try {
      final remoteRepos = await remoteDataSource.getRepos(
        page: page,
        perPage: perPage,
      );
      await localDataSource.saveRepossToCache(
        repos: remoteRepos,
        clear: page == 1,
      );
      yield Right(remoteRepos);
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }
}