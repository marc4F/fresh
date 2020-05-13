import 'package:flutter/foundation.dart';
import 'package:slylist_project/models/playlist.dart';

//Playlists that we offer the user to use/customize
class TemplatePlaylistsProvider extends ChangeNotifier {
  final List<Playlist> _playlists = [];

  TemplatePlaylistsProvider() {
    Playlist pl1 = Playlist();
    Playlist pl2 = Playlist();
    pl1.name = "Neue Lieblingstitel";
    pl2.name = "Topaktuell";
    _playlists.add(pl1);
    _playlists.add(pl2);
    notifyListeners();
  }

  List<Playlist> get templatePlaylists => _playlists;
}
