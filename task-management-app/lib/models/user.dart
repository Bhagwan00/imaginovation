class User {
  final int? id;
  final String name;
  final String email;

  User({
    this.id,
    required this.name,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
