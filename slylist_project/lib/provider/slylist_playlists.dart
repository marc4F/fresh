import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/playlist.dart';

//Playlists that where created from our app
class SlylistPlaylistsProvider extends ChangeNotifier {
  final List<Playlist> slylistPlaylists = [];

  SlylistPlaylistsProvider() {
    //Playlist pl1 = Playlist();
    //pl1.name = "Slylist Playlist 1";
    //_playlists.add(pl1);
    //notifyListeners();
  }

  createPlaylist(String name, List<String> sources, List<Group> groups,
      String groupsMatch, int songLimit, String sort, bool isPublic, bool isSynced) {
    slylistPlaylists.add(new Playlist(
        name: name,
        sources: sources,
        groups: groups,
        groupsMatch: groupsMatch,
        songLimit: songLimit,
        sort: sort,
        isPublic: isPublic,
        isSynced: isSynced));
  }
}
