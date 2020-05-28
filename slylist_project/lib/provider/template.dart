import 'package:flutter/foundation.dart';
import 'package:slylist_project/common/templates.dart';
import 'package:slylist_project/models/template.dart';

//Playlists that we offer the user to use/customize
class TemplateProvider extends ChangeNotifier {
  final List<Template> templates = [];

  TemplateProvider() {
    initTemplates();
    notifyListeners();
  }
  
  initTemplates() {
    templatesJson.forEach((templatePlaylist) =>
        templates.add(Template.fromJson(templatePlaylist)));
  }
}
