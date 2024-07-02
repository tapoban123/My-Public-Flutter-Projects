// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postID;
  final String userName;
  final String profilePic;
  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postID,
    required this.userName,
    required this.profilePic,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postID,
    String? userName,
    String? profilePic,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postID: postID ?? this.postID,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postID': postID,
      'userName': userName,
      'profilePic': profilePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postID: map['postID'] as String,
      userName: map['userName'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postID: $postID, userName: $userName, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postID == postID &&
        other.userName == userName &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postID.hashCode ^
        userName.hashCode ^
        profilePic.hashCode;
  }
}
