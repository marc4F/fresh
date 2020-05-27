import 'package:flutter/foundation.dart';
import 'package:slylist_project/common/templates.dart';
import 'package:slylist_project/models/template.dart';

//Playlists that we offer the user to use/customize
class TemplatePlaylistsProvider extends ChangeNotifier {
  final List<Template> templatePlaylists = [];

  TemplatePlaylistsProvider() {
    initTemplates();
    notifyListeners();
  }
  
  initTemplates() {
    templatePlaylistsJson.forEach((templatePlaylist) =>
        templatePlaylists.add(Template.fromJson(templatePlaylist)));
  }
}
