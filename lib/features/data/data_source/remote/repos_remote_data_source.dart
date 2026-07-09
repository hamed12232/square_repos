import 'package:dio/dio.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../model/repo_model.dart';

class ReposRemoteDataSource {
  final Dio dio;

  const ReposRemoteDataSource(this.dio);

  Future<List<RepoModel>> getRepos({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await dio.get(
        ApiConstant.reposEndPoint,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => RepoModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: response.statusCode ?? 500,
            statusMessage: 'Failed to fetch repositories',
          ),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
