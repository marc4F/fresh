import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/services/data-cache.dart';

//Playlists that where created from our app
class SlylistProvider extends ChangeNotifier {
  final List<Slylist> slylists = [];
  bool _isSpotifyUpdating = false;

  bool get isSpotifyUpdating => _isSpotifyUpdating;

  set isSpotifyUpdating(bool isSpotifyUpdating) {
    _isSpotifyUpdating = isSpotifyUpdating;
    notifyListeners();
  }

  final _dataCache = new DataCache();

  SlylistProvider() {
    // Only for debugging:
    //removeAllSlylists();

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
      bool isSynced,
      String spotifyId) {
    slylists.add(new Slylist(name, sources, groups, groupsMatch, songLimit,
        sort, isPublic, isSynced, spotifyId));
    saveAllSlylists();
    notifyListeners();
  }

  updateSlylist(
      Slylist existingPlaylist,
      String name,
      List<String> sources,
      List<Group> groups,
      String groupsMatch,
      int songLimit,
      String sort,
      bool isPublic,
      bool isSynced) {
    existingPlaylist.updateSlylist(name, sources, groups, groupsMatch,
        songLimit, sort, isPublic, isSynced);
    saveAllSlylists();
    notifyListeners();
  }

  saveAllSlylists() async {
    List<String> slylistsAsJsonString = [];

    slylists.forEach(
        (slylist) => slylistsAsJsonString.add(json.encode(slylist.toJson())));

    _dataCache.writeStringList('Slylists', slylistsAsJsonString);
  }

  loadAllSlylists() async {
    List<String> slylistsAsJsonString =
        await _dataCache.readStringList('Slylists');
    if (slylistsAsJsonString != null) {
      slylistsAsJsonString.forEach(
          (slylist) => slylists.add(Slylist.fromJson(json.decode(slylist))));
    }
    notifyListeners();
  }

  removeAllSlylists() async {
    _dataCache.delete('Slylists');
    notifyListeners();
  }

  void removeSlylist(Slylist slylist) {
    slylists.remove(slylist);
    saveAllSlylists();
    notifyListeners();
  }
}
