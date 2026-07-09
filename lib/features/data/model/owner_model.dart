import 'package:square_repos/features/domain/entities/owner_entity.dart';

class OwnerModel extends OwnerEntity {
  const OwnerModel({
    required super.login,
    required super.htmlUrl,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      login: json['login'] ?? '',
      htmlUrl: json['html_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'html_url': htmlUrl,
    };
  }
}