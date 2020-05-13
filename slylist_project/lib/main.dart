// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/theme.dart';

import 'package:slylist_project/screens/slylist_playlists.dart';
import 'package:slylist_project/screens/template_playlists.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

import 'package:slylist_project/provider/slylist_playlists.dart';
import 'package:slylist_project/provider/template_playlists.dart';
import 'package:slylist_project/provider/spotify_created_playlists.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to provide every screen access to all playlist types
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SlylistPlaylistsProvider()),
        ChangeNotifierProvider(create: (context) => TemplatePlaylistsProvider()),
        ChangeNotifierProvider(create: (context) => SpotifyCreatedPlaylistsProvider())
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => SlylistPlaylists(),
          '/template_playlists': (context) => TemplatePlaylists(),
          '/playlist_creation': (context) => PlaylistCreation()
        },
      ),
    );
  }
}
