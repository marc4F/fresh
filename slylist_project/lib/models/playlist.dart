import 'group.dart';

class Playlist {
  String name = "";
  List<String> sources;
  List<Group> groups;
  String groupsMatch;
  int songLimit;
  String sort;
  bool isPublic;
  bool isSynced;
  String id;

  Playlist(
      {this.name,
      this.sources,
      this.groups,
      this.groupsMatch,
      this.songLimit,
      this.sort,
      this.isPublic,
      this.isSynced});
}
