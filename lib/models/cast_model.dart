class CastMember {
  final int id;
  final String name;
  final String? profilepath;
  final String character;

  CastMember({
    required this.id,
    required this.name,
    required this.profilepath,
    required this.character,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilepath: json['profile_path'],
      character: json['character'],
    );
  }
}
