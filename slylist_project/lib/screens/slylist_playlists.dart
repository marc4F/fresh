import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/playlist.dart';
import 'package:slylist_project/provider/slylist_playlists.dart';

class ScreenProvider extends ChangeNotifier {}

class SlylistPlaylists extends StatelessWidget {
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
            ),
          ),
          appBar: AppBar(
            title: Text(title),
          ),
          body: Consumer<SlylistPlaylistsProvider>(
            builder: (context, p, child) => (p.slylistPlaylists.length > 0)
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
                Text('Use one of our awesome templates to create a playlist.'),
                Text(
                    'Or be creative, and make a playlist after your own custom rules.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('PLAYLIST FROM TEMPLATE'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/template_playlists');
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

  Future<void> _onPressedOpenDeleteDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Can't delete playlist in slylist"),
          content: Text(
              "Please go to spotify, to delete playlists."),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
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

  ListView buildListView(SlylistPlaylistsProvider p) {
    return ListView.builder(
      itemCount: p.slylistPlaylists.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: PopupMenuButton<int>(
            onSelected: (menuValue) => (menuValue == 1)
                ? Navigator.pushNamed(context, '/playlist_creation',
                    arguments: p.slylistPlaylists[index])
                : _onPressedOpenDeleteDialog(context),
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
          title: Text('${p.slylistPlaylists[index].name}'),
        );
      },
    );
  }
}
