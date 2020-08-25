import 'package:slylist_project/models/playlist.dart';

import 'group.dart';

abstract class Applist extends Playlist {
  List<String> sources;
  List<Group> groups;
  String groupsMatch;
  int songLimit;
  String sort;
  bool isPublic;
  bool isSynced;

  Applist(
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced)
      : super(name) {
    this.sources = sources;
    this.groups = groups;
    this.groupsMatch = groupsMatch;
    this.songLimit = songLimit;
    this.sort = sort;
    this.isPublic = isPublic;
    this.isSynced = isSynced;
  }
}
