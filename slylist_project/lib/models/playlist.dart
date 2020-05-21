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
}
