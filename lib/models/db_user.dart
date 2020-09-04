import 'dart:convert';

class DbUser {
  DbUser({
    this.crew,
  });

  factory DbUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DbUser(
      crew: map['crew'] as String,
    );
  }

  factory DbUser.fromJson(String source) =>
      DbUser.fromMap(json.decode(source) as Map<String, dynamic>);

  String crew;

  DbUser copyWith({
    String crew,
  }) {
    return DbUser(
      crew: crew ?? this.crew,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'crew': crew,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'User(crew: $crew)';
}
