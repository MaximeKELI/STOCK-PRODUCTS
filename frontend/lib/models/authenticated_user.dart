import 'dart:convert';

AuthenticatedUser authenticatedUserFromJson(String str) =>
    AuthenticatedUser.fromJson(json.decode(str));

String authenticatedUserToJson(AuthenticatedUser data) =>
    json.encode(data.toJson());

class AuthenticatedUser {
  String? accessToken;
  Authentication? authentication;
  User? user;

  AuthenticatedUser({
    this.accessToken,
    this.authentication,
    this.user,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) =>
      AuthenticatedUser(
        accessToken: json["accessToken"],
        authentication: json["authentication"] == null
            ? null
            : Authentication.fromJson(json["authentication"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "authentication": authentication?.toJson(),
        "user": user?.toJson(),
      };
}

class Authentication {
  String? strategy;
  Payload? payload;

  Authentication({
    this.strategy,
    this.payload,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        strategy: json["strategy"],
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "strategy": strategy,
        "payload": payload?.toJson(),
      };
}

class Payload {
  int? iat;
  int? exp;
  String? aud;
  String? sub;
  String? jti;

  Payload({
    this.iat,
    this.exp,
    this.aud,
    this.sub,
    this.jti,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        iat: json["iat"],
        exp: json["exp"],
        aud: json["aud"],
        sub: json["sub"],
        jti: json["jti"],
      );

  Map<String, dynamic> toJson() => {
        "iat": iat,
        "exp": exp,
        "aud": aud,
        "sub": sub,
        "jti": jti,
      };
}

class User {
  int id;
  String username;
  String email;
  String? firstName;
  String? lastName;
  String? password;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.password,
  });

  // Getters
  int get userId => id;
  String get fullname => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "password": password,
      };

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
    );
  }
}
