import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/provider/template_playlists.dart';

class ScreenProvider extends ChangeNotifier {}

class TemplatePlaylists extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final title = 'Template Playlists';

    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(),
      child: Consumer<ScreenProvider>(
        builder: (context, p, child) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Consumer<TemplatePlaylistsProvider>(
            builder: (context, p, child) => buildListView(p)
          ),
        ),
      ),
    );
  }

  ListView buildListView(TemplatePlaylistsProvider p) {
    return ListView.builder(
      itemCount: p.templatePlaylists.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${p.templatePlaylists[index].name}'),
        );
      },
    );
  }
}
