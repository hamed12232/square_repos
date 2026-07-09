class OwnerModel {
  final String login;
  final String htmlUrl;

  OwnerModel({
    required this.login,
    required this.htmlUrl,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      login: json['login'],
      htmlUrl: json['html_url'],
    );
  }
}