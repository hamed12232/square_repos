import 'package:square_repos/features/domain/entities/repo_entity.dart';
import 'owner_model.dart';

class RepoModel extends RepoEntity {
  const RepoModel({
    required super.id,
    required super.name,
    required super.description,
    required super.fork,
    required super.htmlUrl,
    required OwnerModel super.owner,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fork: json['fork'] ?? false,
      htmlUrl: json['html_url'] ?? '',
      owner: OwnerModel.fromJson(json['owner'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fork': fork,
      'html_url': htmlUrl,
      'owner': (owner as OwnerModel).toJson(),
    };
  }
}
