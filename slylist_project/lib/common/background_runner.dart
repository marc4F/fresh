import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:workmanager/workmanager.dart';
import 'package:slylist_project/services/data-cache.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    final List<Slylist> slylists = [];
    final spotifyClient = SpotifyClient();
    final dataCache = DataCache();
    final accessToken = await dataCache.readString('accessToken');
    final refreshToken = await dataCache.readString('refreshToken');
    final spotifyUserId = await dataCache.readString('spotifyUserId');
    List<String> slylistsAsJsonString =
        await dataCache.readStringList('Slylists');
    if ((accessToken == null) ||
        (refreshToken == null) ||
        (spotifyUserId == null) ||
        (slylistsAsJsonString == null)) {
      // Cancel the background task, if tokens are null, or no slylist
      return true;
    }
    await spotifyClient.setInitialTokens(accessToken, refreshToken);

    slylistsAsJsonString.forEach(
        (slylist) => slylists.add(Slylist.fromJson(json.decode(slylist))));

    await Future.forEach(slylists, (Slylist slylist) async {
      // If no spotify playlist is linked to slylist, create a new spotify playlist.
      if (slylist.spotifyId == null) {
        slylist.spotifyId = await spotifyClient.createSpotifyPlaylistAndGetId(
            slylist, spotifyUserId);
      }
      // Only add tracks to spotify playlist, if it was succesfully created.
      if (slylist.spotifyId != null) {
        final items = await spotifyClient.getUserSavedTracks();
        List<String> tracksToAddToPlaylist = [];
        final now = DateTime.now();
        items.forEach((item) {
          final dateAdded = DateTime.parse(item["added_at"]);
          final daysDifference = now.difference(dateAdded).inDays;
          if (daysDifference < 90) {
            tracksToAddToPlaylist.add(item["track"]["uri"]);
          }
        });
        await spotifyClient.clearSpotifyPlaylist(slylist.spotifyId);
        await spotifyClient.addTracksToSpotifyPlaylist(
            slylist.spotifyId, tracksToAddToPlaylist);
      }
    });

    await saveAllSlylists(slylists, dataCache);

    return true;
  });
}

saveAllSlylists(List<Slylist> slylists, dataCache) async {
  List<String> slylistsAsJsonString = [];

  slylists.forEach(
      (slylist) => slylistsAsJsonString.add(json.encode(slylist.toJson())));

  await dataCache.writeStringList('Slylists', slylistsAsJsonString);
}
