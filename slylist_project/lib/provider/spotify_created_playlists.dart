import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/playlist.dart';

// Playlists that were created inside spotify, and not from our app.
class SpotifyCreatedPlaylistsProvider extends ChangeNotifier {
  final List<Playlist> spotifyCreatedPlaylists = [];

  SpotifyCreatedPlaylistsProvider() {
    //Playlist pl1 = Playlist();
    //pl1.name = "Spotify Playlist 1";
    //spotifyCreatedPlaylists.add(pl1);
    notifyListeners();
  }
}
