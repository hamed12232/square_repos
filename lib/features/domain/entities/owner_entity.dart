import 'package:equatable/equatable.dart';

class OwnerEntity extends Equatable {
  final String login;
  final String htmlUrl;

  const OwnerEntity({
    required this.login,
    required this.htmlUrl,
  });

  @override
  List<Object?> get props => [login, htmlUrl];
}
