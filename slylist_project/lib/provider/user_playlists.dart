import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/playlist.dart';

class UserPlaylistsProvider extends ChangeNotifier {
  final List<Playlist> _playlists = [];

  void addUserPlaylist() {
    Playlist pl1 = Playlist();
    Playlist pl2 = Playlist();
    pl1.name = "Neue Lieblingstitel2";
    pl2.name = "Topaktuell";
    _playlists.add(pl1);
    _playlists.add(pl2);
    notifyListeners();
  }

  List<Playlist> get userPlaylists => _playlists;
}