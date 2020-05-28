import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/playlist.dart';

// Playlists that were created inside spotify, and not from our app.
class SpotifyPlaylistProvider extends ChangeNotifier {
  final List<Playlist> spotifyPlaylists = [];

  SpotifyPlaylistProvider() {
    //Playlist pl1 = Playlist();
    //pl1.name = "Spotify Playlist 1";
    //spotifyPlaylists.add(pl1);
    notifyListeners();
  }
}
