import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/services/spotify_client.dart';

import 'data-cache.dart';

class PlaylistManager {
  final SpotifyClient _spotifyClient;
  final SlylistProvider _slylistProvider;
  List<Slylist> _slylists = [];

  PlaylistManager(this._spotifyClient, this._slylistProvider);

  updateUsersSpotify() async {
    final dataCache = DataCache();
    final spotifyUserId = await dataCache.readString('spotifyUserId');

    // slylists is null if called from background runner --> Use the stored slylists
    if (_slylistProvider == null) {
      List<String> slylistsAsJsonString =
          await dataCache.readStringList('Slylists');

      slylistsAsJsonString.forEach(
          (slylist) => _slylists.add(Slylist.fromJson(json.decode(slylist))));
    } else {
      _slylistProvider.isSpotifyUpdating = true;
      _slylists = _slylistProvider.slylists;
    }
    try {
      await Future.forEach(_slylists, (Slylist slylist) async {
        bool isSpotifyPlaylistAvailable =
            await _spotifyClient.isPlaylistAvailable(slylist.spotifyId);
        if (!isSpotifyPlaylistAvailable) {
          slylist.spotifyId =
              await _spotifyClient.createSpotifyPlaylistAndGetId(
                  slylist.name, slylist.isPublic, spotifyUserId);
        }
        // Only add tracks to spotify playlist, if it was succesfully created.
        if (slylist.spotifyId != null) {
          final items = await _spotifyClient.getUserSavedTracks();
          List<String> tracksToAddToPlaylist = [];
          final now = DateTime.now();
          items.forEach((item) {
            final dateAdded = DateTime.parse(item["added_at"]);
            final daysDifference = now.difference(dateAdded).inDays;
            if (daysDifference < 90) {
              tracksToAddToPlaylist.add(item["track"]["uri"]);
            }
          });
          await _spotifyClient.clearSpotifyPlaylist(slylist.spotifyId);
          await _spotifyClient.addTracksToSpotifyPlaylist(
              slylist.spotifyId, tracksToAddToPlaylist);
        }
      });
    } catch (e) {
      debugPrint(e);
    }
    await saveAllSlylists(_slylists, dataCache);
    _slylistProvider.isSpotifyUpdating = false;
  }

  saveAllSlylists(List<Slylist> slylists, dataCache) async {
    List<String> slylistsAsJsonString = [];

    slylists.forEach(
        (slylist) => slylistsAsJsonString.add(json.encode(slylist.toJson())));

    await dataCache.writeStringList('Slylists', slylistsAsJsonString);
  }
}
