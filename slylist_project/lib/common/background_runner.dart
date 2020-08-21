import 'dart:convert';

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
    if ((accessToken == null) || (refreshToken == null)) {
      // Cancel the background task, if tokens are null
      return true;
    }
    await spotifyClient.setInitialTokens(accessToken, refreshToken);

    List<String> slylistsAsJsonString =
        await dataCache.readStringList('Slylists');
    if (slylistsAsJsonString != null) {
      slylistsAsJsonString.forEach(
          (slylist) => slylists.add(Slylist.fromJson(json.decode(slylist))));
    }

    print(slylists);

    return true;
  });
}
