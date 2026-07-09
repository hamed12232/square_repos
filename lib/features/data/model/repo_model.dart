import 'package:square_repos/features/data/model/owner_model.dart';

class RepoModel {
  final String name;
  final String? description;
  final bool fork;
  final String htmlUrl;
  final OwnerModel owner;

  RepoModel({
    required this.name,
    required this.description,
    required this.fork,
    required this.htmlUrl,
    required this.owner,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      name: json['name'],
      description: json['description'],
      fork: json['fork'] ?? false,
      htmlUrl: json['html_url'],
      owner: OwnerModel.fromJson(json['owner']),
    );
  }
}