import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/models/template.dart';
import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/provider/template.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:slylist_project/services/playlist_manager.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:workmanager/workmanager.dart';

class ScreenProvider extends ChangeNotifier {}

class Templates extends StatelessWidget {
  final SpotifyClient _spotifyClient;

  Templates(this._spotifyClient);

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
          body: Consumer2<TemplateProvider, SlylistProvider>(
              builder: (context, templateProvider, slylistProvider, child) =>
                  buildListView(templateProvider, slylistProvider)),
        ),
      ),
    );
  }

  ListView buildListView(
      TemplateProvider templateProvider, SlylistProvider slylistProvider) {
    return ListView.builder(
      itemCount: templateProvider.templates.length,
      itemBuilder: (context, index) {
        Template templatePlaylist = templateProvider.templates[index];
        // Add 1s to the name, until it is unique

        Future<void> createSlylistAndGoToHomeScreen(context) async {
          String playlistName = templatePlaylist.name;

          void setUniqueSlylistName() {
            List<Slylist> slylists = slylistProvider.slylists;

            slylists.forEach((slylist) {
              if (slylist.name == playlistName) {
                playlistName = playlistName + '1';
                setUniqueSlylistName();
              }
            });
          }

          setUniqueSlylistName();

          final spotifyUserId = await DataCache().readString('spotifyUserId');
          String spotifyId = await _spotifyClient.createSpotifyPlaylistAndGetId(
              playlistName, templatePlaylist.isPublic, spotifyUserId);

          slylistProvider.createSlylist(
              playlistName,
              templatePlaylist.sources,
              templatePlaylist.groups,
              templatePlaylist.groupsMatch,
              templatePlaylist.songLimit,
              templatePlaylist.sort,
              templatePlaylist.isPublic,
              templatePlaylist.isSynced,
              spotifyId);

          Navigator.pop(context);

          await PlaylistManager(_spotifyClient, slylistProvider)
              .updateUsersSpotify();
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
