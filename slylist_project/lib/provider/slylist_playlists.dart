import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slylist_project/models/slylist.dart';

//Playlists that where created from our app
class SlylistPlaylistsProvider extends ChangeNotifier {
  final List<Slylist> slylistPlaylists = [];

  SlylistPlaylistsProvider() {
    // Only for debugging:
    removeAllPlaylists();

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
    slylistPlaylists.add(new Slylist(name, sources, groups, groupsMatch,
        songLimit, sort, isPublic, isSynced));
    saveAllPlaylists();
    notifyListeners();
  }

  updatePlaylist(
      Slylist existingPlaylist,
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
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> slylistPlaylistsAsJsonString =
          prefs.getStringList('SlylistPlaylists');
      slylistPlaylistsAsJsonString.forEach((slylistPlaylist) =>
          slylistPlaylists.add(Slylist.fromJson(json.decode(slylistPlaylist))));
    } catch (e) {
      // If there are no slylists in memory, it throws exception.
      // Its save to do nothing
    }
    notifyListeners();
  }

  removeAllPlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('SlylistPlaylists');
    } catch (e) {
      // If there are no slylists in memory, it throws exception.
      // Its save to do nothing
    }
    notifyListeners();
  }
}
