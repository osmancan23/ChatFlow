import 'package:chat_flow/core/base/model/i_network_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends INetworkModel<PostModel> {
  PostModel({
    this.id,
    this.title,
    this.body,
    this.userId,
  });
  @override
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return _$PostModelFromJson(json);
  }
  final int? id;
  final String? title;
  final String? body;
  final int? userId;
  @override
  Map<String, dynamic> toJson() {
    return _$PostModelToJson(this);
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return _$PostModelFromJson(json);
  }
}
