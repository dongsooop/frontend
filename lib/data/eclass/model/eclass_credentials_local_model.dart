class EclassCredentialsLocalModel {
  final String eclassId;
  final String password;

  const EclassCredentialsLocalModel({
    required this.eclassId,
    required this.password,
  });

  factory EclassCredentialsLocalModel.fromJson(Map<String, dynamic> json) {
    final eclassId = json['eclassId'];
    final password = json['password'];

    if (eclassId is! String ||
        eclassId.trim().isEmpty ||
        password is! String ||
        password.isEmpty) {
      throw const FormatException('Invalid stored Eclass credentials.');
    }

    return EclassCredentialsLocalModel(
      eclassId: eclassId.trim(),
      password: password,
    );
  }

  Map<String, dynamic> toJson() => {
        'eclassId': eclassId,
        'password': password,
      };
}
