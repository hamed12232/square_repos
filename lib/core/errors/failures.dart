import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:square_repos/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

void handleDioException(Object e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 408,
            statusMessage: "Connection Timeout",
          ),
        );
      case DioExceptionType.sendTimeout:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 408,
            statusMessage: "Send Timeout",
          ),
        );
      case DioExceptionType.receiveTimeout:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 408,
            statusMessage: "Receive Timeout",
          ),
        );
      case DioExceptionType.badResponse:
        if (e.response != null && e.response?.data != null) {
          final dynamic data = e.response?.data;
          if (data is Map<String, dynamic>) {
            throw ServerException(
              errorMessageModel: ErrorMessageModel.fromJson(data),
            );
          }

          if (data is String) {
            try {
              final decoded = jsonDecode(data);
              if (decoded is Map<String, dynamic>) {
                throw ServerException(
                  errorMessageModel: ErrorMessageModel.fromJson(decoded),
                );
              } else {
                throw ServerException(
                  errorMessageModel: ErrorMessageModel(
                    statusCode: e.response?.statusCode ?? 500,
                    statusMessage: data,
                  ),
                );
              }
            } catch (_) {
              throw ServerException(
                errorMessageModel: ErrorMessageModel(
                  statusCode: e.response?.statusCode ?? 500,
                  statusMessage: data,
                ),
              );
            }
          }

          if (data is Map) {
            try {
              final converted = Map<String, dynamic>.from(data);
              throw ServerException(
                errorMessageModel: ErrorMessageModel.fromJson(converted),
              );
            } catch (_) {
              throw ServerException(
                errorMessageModel: ErrorMessageModel(
                  statusCode: e.response?.statusCode ?? 500,
                  statusMessage: data.toString(),
                ),
              );
            }
          }

          throw ServerException(
            errorMessageModel: ErrorMessageModel(
              statusCode: e.response?.statusCode ?? 500,
              statusMessage: data.toString(),
            ),
          );
        } else {
          throw ServerException(
            errorMessageModel: ErrorMessageModel(
              statusCode: e.response?.statusCode ?? 500,
              statusMessage:
                  "Received invalid status code: ${e.response?.statusCode}",
            ),
          );
        }
      case DioExceptionType.cancel:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 499,
            statusMessage: "Request to API server was cancelled",
          ),
        );
      case DioExceptionType.connectionError:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 503,
            statusMessage:
                "Connection to API server failed due to internet connection",
          ),
        );
      case DioExceptionType.unknown:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 520,
            statusMessage: "Unknown error occurred",
          ),
        );
      case DioExceptionType.badCertificate:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 526,
            statusMessage: "Bad certificate",
          ),
        );
      case DioExceptionType.transformTimeout:
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 408,
            statusMessage: "Transform Timeout",
          ),
        );
    }
  }
}
