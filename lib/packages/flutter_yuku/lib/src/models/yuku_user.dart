/// Yuku User Profile model
class YukuUser {
  final String principal;
  final String? username;
  final String? avatar;
  final String? bio;
  final DateTime? joinedAt;
  final Map<String, dynamic>? stats;

  YukuUser({
    required this.principal,
    this.username,
    this.avatar,
    this.bio,
    this.joinedAt,
    this.stats,
  });

  factory YukuUser.fromJson(Map<String, dynamic> json) {
    return YukuUser(
      principal: json['principal'] ?? '',
      username: json['username'],
      avatar: json['avatar'],
      bio: json['bio'],
      joinedAt: json['joined_at'] != null || json['joinedAt'] != null
          ? DateTime.parse(json['joined_at'] ?? json['joinedAt'])
          : null,
      stats: json['stats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'principal': principal,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'joined_at': joinedAt?.toIso8601String(),
      'stats': stats,
    };
  }
}
