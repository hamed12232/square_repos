import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final int statusCode;
  final String statusMessage;
  final bool? success;

  const ErrorMessageModel({
    required this.statusCode,
    required this.statusMessage,
    this.success,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      statusCode: json['status_code'] ?? json['statusCode'] ?? 500,
      statusMessage:
          json['status_message'] ??
          json['message'] ??
          json['statusMessage'] ??
          'Something went wrong',
      success: json['success'],
    );
  }

  @override
  List<Object?> get props => [statusCode, statusMessage, success];
}

class ServerException implements Exception {
  final ErrorMessageModel errorMessageModel;

  const ServerException({required this.errorMessageModel});
}

class LocalDatabaseException implements Exception {
  final String message;

  const LocalDatabaseException({required this.message});
}
