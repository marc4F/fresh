import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Playlists that where created from our app
class SlylistPlaylistsProvider extends ChangeNotifier {
  final List<Playlist> slylistPlaylists = [];

  SlylistPlaylistsProvider() {
    loadAllPlaylists();
  }

  createPlaylist(
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced) {
    slylistPlaylists.add(new Playlist(name, sources, groups, groupsMatch,
        songLimit, sort, isPublic, isSynced));
    saveAllPlaylists();
    notifyListeners();
  }

  updatePlaylist(
      Playlist existingPlaylist,
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced) {
    existingPlaylist.updatePlaylist(name, sources, groups, groupsMatch,
        songLimit, sort, isPublic, isSynced);
    saveAllPlaylists();
    notifyListeners();
  }

  saveAllPlaylists() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    List<String> slylistPlaylistsAsJsonString = [];

    slylistPlaylists.forEach((slylistPlaylist) => slylistPlaylistsAsJsonString
        .add(json.encode(slylistPlaylist.toJson())));

    prefs.setStringList('SlylistPlaylists', slylistPlaylistsAsJsonString);
  }

  loadAllPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> slylistPlaylistsAsJsonString =
        prefs.getStringList('SlylistPlaylists');
    slylistPlaylistsAsJsonString.forEach((slylistPlaylist) =>
        slylistPlaylists.add(Playlist.fromJson(json.decode(slylistPlaylist))));
    notifyListeners();
  }
}
