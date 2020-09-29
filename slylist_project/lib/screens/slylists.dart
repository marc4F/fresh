import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:slylist_project/services/playlist_manager.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:workmanager/workmanager.dart';

class ScreenProvider extends ChangeNotifier {}

class Slylists extends StatelessWidget {
  final SpotifyClient _spotifyClient;

  Slylists(this._spotifyClient);

  @override
  Widget build(BuildContext context) {
    final title = 'My Playlists';

    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(),
      child: Consumer<ScreenProvider>(
        builder: (context, p, child) => Scaffold(
          floatingActionButton: Container(
            height: 100,
            width: 100,
            child: FittedBox(
              child: FloatingActionButton(
                  tooltip: 'Select Playlist Type',
                  child: Icon(Icons.playlist_add),
                  onPressed: () async => _onPressedOpenPlaylistDialog(context)),
              //onPressed: () async => this.spotifyClient.test()),
            ),
          ),
          appBar: AppBar(
            title: Text(title),
          ),
          body: Consumer<SlylistProvider>(
            builder: (context, p, child) => (p.slylists.length > 0)
                ? buildListView(p)
                : buildPlaceholderText(context),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedOpenPlaylistDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Playlist Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Use one of our awesome templates.'),
                Text('Or be creative, and use custom rules.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('PLAYLIST FROM TEMPLATE'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/templates');
              },
            ),
            FlatButton(
              child: Text('PLAYLIST FROM CUSTOM RULES'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/playlist_creation');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onPressedOpenDeleteDialog(
      context, SlylistProvider slylistProvider, Slylist slylist) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Playlist Deletion"),
          content: Text("Are you sure you want to delete playlist?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                await _spotifyClient.removeSpotifyPlaylist(slylist.spotifyId);
                slylistProvider.removeSlylist(slylist);
                Navigator.of(context).pop();
                await PlaylistManager(_spotifyClient, slylistProvider)
                    .updateUsersSpotify();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Center buildPlaceholderText(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: "Welcome to SlyList!\n\n",
                  style: DefaultTextStyle.of(context).style.apply(
                      fontSizeFactor: 1.5,
                      color: Colors.black.withOpacity(0.5))),
              TextSpan(
                  text: "Spotify playlists after your taste\n\n",
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.5)),
              TextSpan(
                  text: "Lets create your first playlist :)\n\n",
                  style: DefaultTextStyle.of(context).style.apply(
                      fontSizeFactor: 1.5,
                      color: Colors.black.withOpacity(0.5))),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildListView(SlylistProvider slylistProvider) {
    return ListView.builder(
      itemCount: slylistProvider.slylists.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: slylistProvider.isSpotifyUpdating
              ? CircularProgressIndicator()
              : null,
          trailing: PopupMenuButton<int>(
            onSelected: (menuValue) => (menuValue == 1)
                ? Navigator.pushNamed(context, '/playlist_creation',
                    arguments: slylistProvider.slylists[index])
                : _onPressedOpenDeleteDialog(
                    context, slylistProvider, slylistProvider.slylists[index]),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete"),
              )
            ],
          ),
          title: Text('${slylistProvider.slylists[index].name}'),
        );
      },
    );
  }
}
