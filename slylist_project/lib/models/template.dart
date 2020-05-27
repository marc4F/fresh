import 'package:json_annotation/json_annotation.dart';
import 'package:slylist_project/models/playlist.dart';
import 'group.dart';

part 'template.g.dart';

@JsonSerializable(explicitToJson: true)
class Template extends Playlist {
  String description;

  Template(
      String name,
      String description,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced)
      : super(name, sources, groups, groupsMatch, songLimit, sort, isPublic,
            isSynced) {
    this.description = description;
  }

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}
