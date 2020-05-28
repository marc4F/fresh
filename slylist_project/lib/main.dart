// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/theme.dart';

import 'package:slylist_project/screens/slylists.dart';
import 'package:slylist_project/screens/templates.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/provider/template.dart';
import 'package:slylist_project/provider/spotify_playlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to provide every screen access to all playlist types
    return GestureDetector(
      onTap: () {
        // When clicking outside of keyboard, the keyboard will go away
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => SlylistProvider()),
          ChangeNotifierProvider(
              create: (context) => TemplateProvider()),
          ChangeNotifierProvider(
              create: (context) => SpotifyPlaylistProvider())
        ],
        child: MaterialApp(
          title: 'Slylist',
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => Slylists(),
            '/templates': (context) => Templates(),
            '/playlist_creation': (context) => PlaylistCreation()
          },
        ),
      ),
    );
  }
}
