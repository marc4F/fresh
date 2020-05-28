import 'package:json_annotation/json_annotation.dart';
import 'package:slylist_project/models/playlist.dart';
import 'group.dart';

part 'slylist.g.dart';

@JsonSerializable(explicitToJson: true)
class Slylist extends Playlist {
  Slylist(
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced)
      : super(name, sources, groups, groupsMatch, songLimit, sort, isPublic,
            isSynced);

  updateSlylist(
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced) {
    this.name = name;
    this.sources = sources;
    this.groups = groups;
    this.groupsMatch = groupsMatch;
    this.songLimit = songLimit;
    this.sort = sort;
    this.isPublic = isPublic;
    this.isSynced = isSynced;
  }

  factory Slylist.fromJson(Map<String, dynamic> json) =>
      _$SlylistFromJson(json);

  Map<String, dynamic> toJson() => _$SlylistToJson(this);
}
