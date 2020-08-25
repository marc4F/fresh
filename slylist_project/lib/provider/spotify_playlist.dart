import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/spotify_playlist.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:slylist_project/services/spotify_client.dart';

// Playlists that were created inside spotify, and not from our app.
class SpotifyPlaylistProvider extends ChangeNotifier {
  List<SpotifyPlaylist> spotifyPlaylists = [];

  SpotifyPlaylistProvider(SpotifyClient spotifyClient) {
    initSpotifyPlaylists(spotifyClient);
  }

  Future<void> initSpotifyPlaylists(SpotifyClient spotifyClient) async {
    final dataCache = new DataCache();
    final spotifyUserId = await dataCache.readString('spotifyUserId');
    List<dynamic> playlists =
        await spotifyClient.getSpotifyPlaylists(spotifyUserId);
    playlists.forEach((element) =>
        spotifyPlaylists.add(SpotifyPlaylist(element["name"], element["id"])));
    notifyListeners();
  }
}
