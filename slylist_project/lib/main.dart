// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/background_runner.dart';
import 'package:slylist_project/common/theme.dart';

import 'package:slylist_project/screens/slylists.dart';
import 'package:slylist_project/screens/templates.dart';
import 'package:slylist_project/screens/playlist_creation.dart';
import 'package:slylist_project/screens/spotify_login.dart';

import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/provider/template.dart';
import 'package:slylist_project/provider/spotify_playlist.dart';
import 'package:slylist_project/services/data-cache.dart';

import 'package:slylist_project/services/spotify_client.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String _accessToken, _refreshToken, _spotifyUserId;
final _spotifyClient = SpotifyClient();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _dataCache = new DataCache();
  _accessToken = await _dataCache.readString('accessToken');
  _refreshToken = await _dataCache.readString('refreshToken');
  _spotifyUserId = await _dataCache.readString('spotifyUserId');
  if ((_accessToken != null) && (_refreshToken != null)) {
    _spotifyClient.setInitialTokens(_accessToken, _refreshToken);
  }

  runApp(MyApp());

  if (!kIsWeb) {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );

    // Periodic task registration
    Workmanager().registerPeriodicTask("2", "simplePeriodicTask",
        frequency: Duration(hours: 120),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When clicking outside of keyboard, the keyboard will go away
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      // Using MultiProvider to provide every screen access to all playlist types and access token
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SlylistProvider()),
          ChangeNotifierProvider(create: (context) => TemplateProvider()),
          ChangeNotifierProvider(
              create: (context) => SpotifyPlaylistProvider()),
        ],
        child: MaterialApp(
          title: 'Slylist',
          theme: appTheme,
          initialRoute: (_accessToken == null) || (_spotifyUserId == null)
              ? '/spotify_login'
              : '/slylists',
          routes: {
            '/spotify_login': (context) => SpotifyLogin(_spotifyClient),
            '/slylists': (context) => Slylists(_spotifyClient),
            '/templates': (context) => Templates(_spotifyClient),
            '/playlist_creation': (context) => PlaylistCreation(_spotifyClient)
          },
        ),
      ),
    );
  }
}
