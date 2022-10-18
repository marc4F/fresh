import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:flutter/widgets.dart';
import 'package:slylist_project/common/const.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiver/iterables.dart';

class SpotifyClient {
  SpotifyClient({Dio httpClient})
      : _httpClient = (httpClient ?? Dio())
          ..options.baseUrl = 'https://api.spotify.com/v1'
          ..interceptors.add(_fresh);

  static final _fresh = Fresh<OAuth2Token>(
      tokenStorage: InMemoryTokenStorage<OAuth2Token>(),
      refreshToken: (token, client) async {
        debugPrint('refreshing token...');
        var map = new Map<String, String>();
        map['client_id'] = SlylistConst.spotifyClientId;
        map['grant_type'] = 'refresh_token';
        map['refresh_token'] = token.refreshToken;

        http.Response response = await http.post(
          SlylistConst.spotifyTokenApi,
          body: map,
        );
        var body = json.decode(response.body);
        final dataCache = new DataCache();
        if ((body['error'] == "invalid_grant") &&
            (body['error_description'] == "Refresh token revoked")) {
          debugPrint('token revoked!');
          dataCache.delete("accessToken");
          dataCache.delete("refreshToken");
          // TODO: Decide what to do when refresh token is invalidated
          // --> Exit/Restart app. Or nav to login screen (difficult)
          throw RevokeTokenException();
        }
        debugPrint('token refreshed!');
        String accessToken = body['access_token'];
        String refreshToken = body['refresh_token'];
        dataCache.writeString('accessToken', accessToken);
        dataCache.writeString('refreshToken', refreshToken);
        return OAuth2Token(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      },
      shouldRefresh: (response) {
        var body = json.decode(response.toString());
        if ((body["error"] != null) &&
            (body["error"]["status"] == 401) &&
            (body["error"]["message"] == "The access token expired")) {
          return true;
        } else {
          return false;
        }
      });

  final Dio _httpClient;

  /*  Stream<AuthenticationStatus> get authenticationStatus =>
      _fresh.authenticationStatus; */

  setInitialTokens(String accessToken, String refreshToken) async {
    await _fresh.setToken(
      OAuth2Token(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  Future<void> unauthenticate() async {
    await Future.delayed(const Duration(seconds: 1));
    await _fresh.setToken(null);
  }

  Future<String> getSpotifyUserId() async {
    try {
      final response = await _httpClient.get('/me');
      return response.data["id"];
    } catch (e) {
      debugPrint("failed to get user id");
      return null;
    }
  }

  Future<List<dynamic>> getSpotifyPlaylists() async {
    bool next = true;
    String url = '/me/playlists';
    var items = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        url = response.data["next"];
        items.add(response.data["items"]);
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get spotify playlists");
        return null;
      }
    }
    //Flatten items array which contains n arrays
    return items.expand((i) => i).toList();
  }

  Future<String> createSpotifyPlaylistAndGetId(
      String name, bool isPublic, String spotifyUserId) async {
    try {
      String url = '/users/$spotifyUserId/playlists';
      final response =
          await _httpClient.post(url, data: {'name': name, 'public': isPublic});
      return response.data["id"];
    } catch (e) {
      debugPrint("failed to create spotify playlist");
      return null;
    }
  }

  Future<void> clearSpotifyPlaylist(String spotifyPlaylistId) async {
    try {
      String url = '/playlists/$spotifyPlaylistId/tracks';
      final data = {'uris': []};
      await _httpClient.put(url, data: data);
    } catch (e) {
      debugPrint("failed to clear spotify playlist");
    }
  }

  Future<void> removeSpotifyPlaylist(String spotifyPlaylistId) async {
    try {
      String url = '/playlists/$spotifyPlaylistId/followers';
      await _httpClient.delete(url);
    } catch (e) {
      debugPrint("failed to remove spotify playlist");
    }
  }

  Future<void> addTracksToSpotifyPlaylist(
      String spotifyPlaylistId, List tracks) async {
    try {
      final tracksPartitioned = partition(tracks, 50);
      await Future.forEach(tracksPartitioned, (List tracksPartition) async {
        String url = '/playlists/$spotifyPlaylistId/tracks';
        final data = {'uris': tracksPartition};
        await _httpClient.post(url, data: data);
        await Future.delayed(Duration(milliseconds: 100));
      });
    } catch (e) {
      debugPrint("failed to add tracks to spotify playlist");
    }
  }

  Future<List<dynamic>> getUserSavedTracks() async {
    bool next = true;
    String url = '/me/tracks';
    var items = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        url = response.data["next"];
        items.add(response.data["items"]);
        await Future.delayed(Duration(milliseconds: 50));
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get tracks of user");
        next = false;
      }
    }
    //Flatten items array which contains n arrays
    return items.expand((i) => i).toList();
  }

  Future<List<dynamic>> getAlbumTracks(String albumId) async {
    bool next = true;
    String url = '/albums/$albumId/tracks';
    List tracks = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        url = response.data["next"];
        List items = response.data["items"].toList();
        items = items.map((i) {
          return i["uri"];
        }).toList();
        tracks.add(items);
        await Future.delayed(Duration(milliseconds: 50));
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get artists tracks");
        next = false;
      }
    }
    //Flatten items array which contains n arrays
    return tracks.expand((i) => i).toList();
  }

  Future<List<dynamic>> getUsersFollowedArtists() async {
    bool next = true;
    String url = '/me/following?type=artist';
    List artists = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        var result = response.data["artists"];
        url = result["next"];
        List items = result["items"].toList();
        items = items.map((i) {
          return i["id"];
        }).toList();
        artists.add(items);
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get users followed artists");
        next = false;
      }
    }
    //Flatten artists array which contains n arrays
    return artists.expand((i) => i).toList();
  }

  Future<List<dynamic>> getArtistsAlbums(String artistId) async {
    bool next = true;
    String url = '/artists/$artistId/albums?include_groups=album,single';
    List albums = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        url = response.data["next"];
        albums.add(response.data["items"]);
        await Future.delayed(Duration(milliseconds: 50));
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get artists albums");
        debugPrint(e.error);
        next = false;
      }
    }
    //Flatten artists array which contains n arrays
    return albums.expand((i) => i).toList();
  }

  Future<List<dynamic>> getArtistsTracks(String artistName) async {
    bool next = true;
    String encodedArtistName = Uri.encodeComponent(artistName);
    String url = '/search?q=$encodedArtistName&type=track';
    List tracks = [];
    while (next) {
      try {
        final response = await _httpClient.get(url);
        var result = response.data["tracks"];
        url = result["next"];
        List items = result["items"].toList();
        items = items.map((i) {
          return i["id"];
        }).toList();
        tracks.add(items);
        if (url == null || url == "") {
          next = false;
        }
      } catch (e) {
        debugPrint("failed to get artists tracks");
        next = false;
      }
    }
    //Flatten tracks array which contains n arrays
    return tracks.expand((i) => i).toList();
  }

  Future<bool> isPlaylistAvailable(String spotifyPlaylistId) async {
    if (spotifyPlaylistId == null) {
      return false;
    }
    List spotifyPlaylists = await this.getSpotifyPlaylists();
    for (var spotifyPlaylist in spotifyPlaylists) {
      if (spotifyPlaylist["id"] == spotifyPlaylistId) {
        return true;
      }
    }
    return false;
  }

  updateSpotifyPlaylist(String spotifyPlaylistId, String playlistName,
      bool isPlaylistPublic) async {
    try {
      String url = '/playlists/$spotifyPlaylistId';
      final data = {'name': playlistName, 'public': isPlaylistPublic};
      await _httpClient.put(url, data: data);
    } catch (e) {
      debugPrint("failed to update spotify playlist");
    }
  }
}
