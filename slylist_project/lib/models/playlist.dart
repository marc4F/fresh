import 'package:json_annotation/json_annotation.dart';
import 'group.dart';

part 'playlist.g.dart';

@JsonSerializable(explicitToJson: true)
class Playlist {
  String name = "";
  List<String> sources;
  List<Group> groups;
  String groupsMatch;
  int songLimit;
  String sort;
  bool isPublic;
  bool isSynced;

  Playlist(
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

  updatePlaylist(
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

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
