class UserModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? token;
  final String? userType;
  final int? isVerified;
  final String? nickname;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.token,
    this.userType,
    this.isVerified,
    this.nickname,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // API returns user_id, user_name, user_phone, user_email OR id, name, phone, email
    dynamic rawId = json['id'] ?? json['user_id'];
    int? id;
    if (rawId is int) id = rawId;
    else if (rawId != null) id = int.tryParse('$rawId');

    String? name = json['name']?.toString() ??
        json['user_name']?.toString() ??
        json['user_nickname']?.toString() ??
        json['nickname']?.toString();

    String? phone = json['phone']?.toString() ?? json['user_phone']?.toString();

    String? email = json['email']?.toString() ?? json['user_email']?.toString();

    String? nickname = json['user_nickname']?.toString() ?? json['nickname']?.toString();

    String? image = json['user_img']?.toString() ?? json['image']?.toString() ?? json['avatar']?.toString();

    String? token = json['token']?.toString() ??
        json['access_token']?.toString() ??
        json['api_token']?.toString();

    String? userType = json['user_type']?.toString();

    dynamic v = json['is_verified'] ?? json['phone_verified'] ?? json['user_active'];
    int? isVerified;
    if (v is int) isVerified = v;
    else if (v is bool) isVerified = v ? 1 : 0;
    else if (v != null) isVerified = int.tryParse('$v');

    return UserModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      token: token,
      userType: userType,
      isVerified: isVerified,
      nickname: nickname,
      image: image,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'token': token,
        'user_type': userType,
        'nickname': nickname,
        'image': image,
      };
}
