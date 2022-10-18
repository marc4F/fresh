import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/services/spotify_client.dart';

import 'data-cache.dart';

class PlaylistManager {
  final SpotifyClient _spotifyClient;
  final SlylistProvider _slylistProvider;
  List<Slylist> _slylists = [];

  PlaylistManager(this._spotifyClient, this._slylistProvider);

  updateUsersSpotify() async {
    final dataCache = DataCache();
    final spotifyUserId = await dataCache.readString('spotifyUserId');

    // slylists is null if called from background runner --> Use the stored slylists
    if (_slylistProvider == null) {
      List<String> slylistsAsJsonString =
          await dataCache.readStringList('Slylists');

      slylistsAsJsonString.forEach(
          (slylist) => _slylists.add(Slylist.fromJson(json.decode(slylist))));
    } else {
      _slylistProvider.isSpotifyUpdating = true;
      _slylists = _slylistProvider.slylists;
    }
    try {
      await Future.forEach(_slylists, (Slylist slylist) async {
        bool isSpotifyPlaylistAvailable =
            await _spotifyClient.isPlaylistAvailable(slylist.spotifyId);
        if (!isSpotifyPlaylistAvailable) {
          slylist.spotifyId =
              await _spotifyClient.createSpotifyPlaylistAndGetId(
                  slylist.name, slylist.isPublic, spotifyUserId);
        }
        // Only add tracks to spotify playlist, if it was succesfully created.
        if (slylist.spotifyId != null) {
          await getTracksFromSelectedSources(slylist);
        }
      });
    } catch (e) {
      debugPrint(e);
    }
    await saveAllSlylists(_slylists, dataCache);
    if (_slylistProvider != null) {
      _slylistProvider.isSpotifyUpdating = false;
    }
  }

  getTracksFromSelectedSources(Slylist slylist) async {
    List tracks = [];
    await Future.forEach(slylist.sources, (String source) async {
      switch (source) {
        //Songs from liked Artists
        case "1":
          {
            List followedArtistsIds =
                await _spotifyClient.getUsersFollowedArtists();
            List albums = [];
            await Future.forEach(followedArtistsIds, (followedArtistsId) async {
              albums.addAll(
                  await _spotifyClient.getArtistsAlbums(followedArtistsId));
            });
            debugPrint("Albums: ${albums.length}");
            final now = DateTime.now();
            List newAlbums = [];
            albums.forEach((album) {
              DateTime dateAdded;
              String releaseDate = album["release_date"];
              if (album["release_date_precision"] != "year") {
                dateAdded = DateTime.parse(releaseDate);
              } else {
                dateAdded = DateTime.parse("$releaseDate-01-01");
              }
              album["release_date"] = dateAdded;
              final daysDifference = now.difference(dateAdded).inDays;
              if (daysDifference < 365) {
                newAlbums.add(album);
              }
            });

            newAlbums.sort((a, b) {
              var adate = a["release_date"];
              var bdate = b["release_date"];
              return bdate.compareTo(adate);
            });

            debugPrint("New Albums: ${newAlbums.length}");

            await Future.forEach(newAlbums, (newAlbum) async {
              tracks
                  .addAll(await _spotifyClient.getAlbumTracks(newAlbum["id"]));
            });

            debugPrint("Tracks: ${tracks.length}");

            var distinctTracks = tracks.toSet().toList();

            debugPrint("Distinct Tracks: ${distinctTracks.length}");

            await _spotifyClient.clearSpotifyPlaylist(slylist.spotifyId);
            await _spotifyClient.addTracksToSpotifyPlaylist(
                slylist.spotifyId, distinctTracks);
          }
          break;
        //Songs from liked Albums
        case "2":
          {}
          break;
        //Liked Songs
        case "3":
          {
            List userSavedTracks = await _spotifyClient.getUserSavedTracks();
            tracks.addAll(userSavedTracks);

            List<String> tracksToAddToPlaylist = [];
            final now = DateTime.now();
            tracks.forEach((item) {
              final dateAdded = DateTime.parse(item["added_at"]);
              final daysDifference = now.difference(dateAdded).inDays;
              if (daysDifference < 90) {
                tracksToAddToPlaylist.add(item["track"]["uri"]);
              }
            });
            await _spotifyClient.clearSpotifyPlaylist(slylist.spotifyId);
            await _spotifyClient.addTracksToSpotifyPlaylist(
                slylist.spotifyId, tracksToAddToPlaylist);
          }
          break;
        default:
          //Songs from complete Library
          {}
          break;
      }
    });
  }

  saveAllSlylists(List<Slylist> slylists, dataCache) async {
    List<String> slylistsAsJsonString = [];

    slylists.forEach(
        (slylist) => slylistsAsJsonString.add(json.encode(slylist.toJson())));

    await dataCache.writeStringList('Slylists', slylistsAsJsonString);
  }
}
