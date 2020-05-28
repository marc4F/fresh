import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slylist_project/models/slylist.dart';

//Playlists that where created from our app
class SlylistProvider extends ChangeNotifier {
  final List<Slylist> slylists = [];

  SlylistProvider() {
    // Only for debugging:
    removeAllSlylists();

    loadAllSlylists();
  }

  createSlylist(
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced) {
    slylists.add(new Slylist(name, sources, groups, groupsMatch,
        songLimit, sort, isPublic, isSynced));
    saveAllSlylists();
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
    saveAllSlylists();
    notifyListeners();
  }

  saveAllSlylists() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    List<String> slylistsAsJsonString = [];

    slylists.forEach((slylist) => slylistsAsJsonString
        .add(json.encode(slylist.toJson())));

    prefs.setStringList('Slylists', slylistsAsJsonString);
  }

  loadAllSlylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> slylistsAsJsonString =
          prefs.getStringList('Slylists');
      slylistsAsJsonString.forEach((slylist) =>
          slylists.add(Slylist.fromJson(json.decode(slylist))));
    } catch (e) {
      // If there are no slylists in memory, it throws exception.
      // Its save to do nothing
    }
    notifyListeners();
  }

  removeAllSlylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('Slylists');
    } catch (e) {
      // If there are no slylists in memory, it throws exception.
      // Its save to do nothing
    }
    notifyListeners();
  }
}
