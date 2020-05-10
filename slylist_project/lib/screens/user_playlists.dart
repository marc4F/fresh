import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/provider/user_playlists.dart';

class UserPlaylists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'My Playlists';

    // This call would be executed, if new user playlist was created.
    Provider.of<UserPlaylistsProvider>(context, listen: false).addUserPlaylist();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer<UserPlaylistsProvider>(
        builder: (context, p, child) =>
        ListView.builder(
          itemCount: p.userPlaylists.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${p.userPlaylists[index].name}'),
            );
          },
        ),
      ),
    );
  }
}
