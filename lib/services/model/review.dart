import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  Review({
    required this.reviewerName,
    required this.profileImage,
    required this.createdAt,
    required this.contents,
  });
  String reviewerName;
  String profileImage;
  String createdAt;
  String contents;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
