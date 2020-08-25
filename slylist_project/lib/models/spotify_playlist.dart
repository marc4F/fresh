import 'package:slylist_project/models/playlist.dart';

class SpotifyPlaylist extends Playlist {
  String id;

  SpotifyPlaylist(String name, String id) : super(name) {
    this.id = id;
  }
}
