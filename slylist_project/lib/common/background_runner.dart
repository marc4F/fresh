import 'dart:convert';

import 'package:slylist_project/services/playlist_manager.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:workmanager/workmanager.dart';
import 'package:slylist_project/services/data-cache.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
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

    await PlaylistManager(spotifyClient, null).updateUsersSpotify();

    return true;
  });
}
