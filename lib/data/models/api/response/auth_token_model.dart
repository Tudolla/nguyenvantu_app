class AuthToken {
  final String refreshToken;
  final String accessToken;
  final int id;
  final String image;

  AuthToken({
    required this.refreshToken,
    required this.accessToken,
    required this.id,
    required this.image,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      refreshToken: json['refresh'],
      accessToken: json['access'],
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refreshToken,
      'access': accessToken,
      'id': id,
      'image': image,
    };
  }
}
