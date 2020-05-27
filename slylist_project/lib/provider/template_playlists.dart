import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slylist_project/common/templates.dart';
import 'package:slylist_project/models/playlist.dart';

//Playlists that we offer the user to use/customize
class TemplatePlaylistsProvider extends ChangeNotifier {
  final List<Playlist> templatePlaylists = [];

  TemplatePlaylistsProvider() {
    initTemplates();
    notifyListeners();
  }
  
  initTemplates() {
    templatePlaylistsJson.forEach((templatePlaylist) =>
        templatePlaylists.add(Playlist.fromJson(templatePlaylist)));
  }
}
