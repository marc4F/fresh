import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/models/template.dart';
import 'package:slylist_project/provider/slylist_playlists.dart';
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
          body: Consumer2<TemplatePlaylistsProvider, SlylistPlaylistsProvider>(
              builder: (context, templatePlaylistsProvider,
                      slylistPlaylistsProvider, child) =>
                  buildListView(
                      templatePlaylistsProvider, slylistPlaylistsProvider)),
        ),
      ),
    );
  }

  ListView buildListView(TemplatePlaylistsProvider templatePlaylistsProvider,
      SlylistPlaylistsProvider slylistPlaylistsProvider) {
    return ListView.builder(
      itemCount: templatePlaylistsProvider.templatePlaylists.length,
      itemBuilder: (context, index) {
        Template templatePlaylist =
            templatePlaylistsProvider.templatePlaylists[index];
        // Add 1s to the name, until it is unique

        void createSlylistAndGoToHomeScreen(context) {
          String playlistName = templatePlaylist.name;

          void setUniquePlaylistName() {
            List<Slylist> slylistPlaylists =
                slylistPlaylistsProvider.slylistPlaylists;

            slylistPlaylists.forEach((slylistPlaylist) {
              if (slylistPlaylist.name == playlistName) {
                playlistName = playlistName + '1';
                setUniquePlaylistName();
              }
            });
          }

          setUniquePlaylistName();

          slylistPlaylistsProvider.createPlaylist(
              playlistName,
              templatePlaylist.sources,
              templatePlaylist.groups,
              templatePlaylist.groupsMatch,
              templatePlaylist.songLimit,
              templatePlaylist.sort,
              templatePlaylist.isPublic,
              templatePlaylist.isSynced);
          Navigator.pop(context);
        }

        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('${templatePlaylist.name}'),
                subtitle: Text('${templatePlaylist.description}'),
                trailing: PopupMenuButton<int>(
                  onSelected: (menuValue) => (menuValue == 1)
                      ? createSlylistAndGoToHomeScreen(context)
                      : Navigator.pushNamed(context, '/playlist_creation',
                          arguments: templatePlaylist),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Use"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Edit"),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
