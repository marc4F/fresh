import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slylist_project/common/const.dart';
import 'package:slylist_project/screens/slylists.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nonce/nonce.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SpotifyOAuth {
  final String redirectUri = 'http://localhost:8080/';
  final List<String> _scopes = [
    'playlist-modify-private', // Write access to a user's private playlists
    'playlist-modify-public', // Write access to a user's public playlists
    'playlist-read-private', // Read access to user's private playlists.
    'user-follow-modify', // Write/delete access to the list of artists and other users that the user follows
    'user-follow-read', // Read access to the list of artists and other users that the user follows
    'user-library-modify', // Write/delete access to a user's "Your Music" library
    'user-library-read', // Read access to a user's "Your Music" library
    'playlist-read-collaborative', // Include collaborative playlists when requesting a user's playlists
    'user-read-currently-playing', // Read access to a user’s currently playing content
    'user-read-recently-played', // Read access to a user’s recently played tracks
    'user-top-read', // Read access to a user's top artists and tracks
  ];

  String codeVerifier;
  String codeChallenge;

  SpotifyOAuth() {
    codeVerifier = Nonce.generate(128);
    List<int> codeVerifierAsList = utf8.encode(codeVerifier);
    codeChallenge = base64Url.encode(sha256.convert(codeVerifierAsList).bytes);
    codeChallenge = codeChallenge.replaceAll(RegExp('='), '');
    debugPrint('_codeVerifier = $codeVerifier');
    debugPrint('_codeChallenge = $codeChallenge');
  }

  Uri get authorizeUri => Uri(
          scheme: 'https',
          host: 'accounts.spotify.com',
          path: '/authorize',
          queryParameters: {
            'client_id': SlylistConst.spotifyClientId,
            'redirect_uri': this.redirectUri,
            'scope': this._scopes.join(' '),
            'response_type': 'code',
            'code_challenge_method': 'S256',
            'code_challenge': this.codeChallenge,
            'state': Nonce.generate(),
          });
}

class SpotifyLogin extends StatelessWidget {
  final _spotifyOAuth = SpotifyOAuth();
  final SpotifyClient spotifyClient;

  SpotifyLogin(this.spotifyClient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Grant Flow'),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: _spotifyOAuth.authorizeUri.toString(),
        navigationDelegate: (navReq) async {
          if (navReq.url.startsWith(_spotifyOAuth.redirectUri)) {
            String authCode = _extractAuth(navReq.url);

            if (authCode == "access_denied") {
              // If user presses cancel, the app will be closed.
              // TODO: When release is planned for IOS, this is not allowed.
              // Then we need another way to handle the cancel action.
              exit(0);
            }

            var map = new Map<String, String>();
            map['client_id'] = SlylistConst.spotifyClientId;
            map['grant_type'] = 'authorization_code';
            map['code'] = authCode;
            map['redirect_uri'] = _spotifyOAuth.redirectUri;
            map['code_verifier'] = _spotifyOAuth.codeVerifier;

            http.Response response = await http.post(
              SlylistConst.spotifyTokenApi,
              body: map,
            );

            var body = json.decode(response.body);
            var accessToken = body['access_token'];
            var refreshToken = body['refresh_token'];

            if (accessToken == null || refreshToken == null) {
              exit(0);
            }
            final dataCache = new DataCache();
            dataCache.writeString('accessToken', accessToken);
            dataCache.writeString('refreshToken', refreshToken);

            spotifyClient.setInitialTokens(accessToken, refreshToken);
            String spotifyUserId = await spotifyClient.getSpotifyUserId();
            dataCache.writeString('spotifyUserId', spotifyUserId);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Slylists()),
              (Route<dynamic> route) => false,
            );

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String _extractAuth(String navReqUrl) {
    Uri redirectedUri = Uri.parse(navReqUrl);
    String code = redirectedUri.queryParameters.values.first;
    String state = redirectedUri.queryParameters.values.last;
    debugPrint('code: $code');
    debugPrint('state: $state');
    return code;
  }
}
