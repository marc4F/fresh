import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/spotify_playlist.dart';
import 'package:slylist_project/services/spotify_client.dart';

// Playlists that were created inside spotify, and not from our app.
class SpotifyPlaylistProvider extends ChangeNotifier {
  List<SpotifyPlaylist> spotifyPlaylists = [];

  Future<dynamic> initSpotifyPlaylists(SpotifyClient spotifyClient) async {
    spotifyPlaylists = [];
    List<dynamic> playlists = await spotifyClient.getSpotifyPlaylists();
    playlists.forEach((element) =>
        spotifyPlaylists.add(SpotifyPlaylist(element["name"], element["id"])));
    return spotifyPlaylists;
    //notifyListeners();
  }
}
