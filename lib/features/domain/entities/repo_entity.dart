import 'package:equatable/equatable.dart';
import 'owner_entity.dart';

class RepoEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final bool fork;
  final String htmlUrl;
  final OwnerEntity owner;

  const RepoEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.fork,
    required this.htmlUrl,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, name, description, fork, htmlUrl, owner];
}
