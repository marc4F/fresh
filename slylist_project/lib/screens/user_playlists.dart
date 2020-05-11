import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/provider/user_playlists.dart';

class ScreenProvider extends ChangeNotifier {}

class UserPlaylists extends StatelessWidget {
  Future<void> _onPressedOpenPlaylistDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Playlist Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Use one of our awesome templates to create a playlist.'),
                Text('Or be creative, and make a playlist after your own custom rules.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('PLAYLIST FROM TEMPLATE'),
              onPressed: () {
                Provider.of<UserPlaylistsProvider>(context, listen: false)
                    .addUserPlaylist();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('PLAYLIST FROM CUSTOM RULES'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'My Playlists';

    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(),
      child: Consumer<ScreenProvider>(
        builder: (context, p, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
              tooltip: 'Select Playlist Type',
              child: Icon(Icons.playlist_add),
              onPressed: () async => _onPressedOpenPlaylistDialog(context)),
          appBar: AppBar(
            title: Text(title),
          ),
          body: Consumer<UserPlaylistsProvider>(
            builder: (context, p, child) => (p.userPlaylists.length > 0)
                ? buildListView(p)
                : buildPlaceholderText(context),
          ),
        ),
      ),
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
                  text: "Welcome to SlyList! \n\n",
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

  ListView buildListView(UserPlaylistsProvider p) {
    return ListView.builder(
      itemCount: p.userPlaylists.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${p.userPlaylists[index].name}'),
        );
      },
    );
  }
}
