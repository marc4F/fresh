import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/playlist.dart';

//Playlists that where created from our app
class SlylistPlaylistsProvider extends ChangeNotifier {
  final List<Playlist> _playlists = [];

  SlylistPlaylistsProvider() {
      //Playlist pl1 = Playlist();
      //pl1.name = "Slylist Playlist 1";
      //_playlists.add(pl1);
      //notifyListeners();
  }

  List<Playlist> get slylistPlaylists => _playlists;
}
