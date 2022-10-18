import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/applist.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/models/slylist.dart';
import 'package:slylist_project/models/source.dart';
import 'package:slylist_project/models/spotify_playlist.dart';
import 'package:slylist_project/models/template.dart';
import 'package:slylist_project/provider/slylist.dart';
import 'package:slylist_project/screens/slylists.dart';
import 'package:slylist_project/services/data-cache.dart';
import 'package:slylist_project/services/playlist_manager.dart';
import 'package:slylist_project/services/spotify_client.dart';
import 'package:slylist_project/widgets/create_groups_rules_step.dart';
import 'package:slylist_project/widgets/details_step.dart';
import 'package:slylist_project/widgets/select_source_step.dart';
import 'package:slylist_project/provider/spotify_playlist.dart';
import 'dart:convert';

import 'package:workmanager/workmanager.dart';

class ScreenProvider extends ChangeNotifier {
  static const List sortings = [
    'Random',
    'Most Popular',
    'Least Popular',
    'Most Played',
    'Least Played',
    'Most Recently Added',
    'Least Recently Added',
    'Most Recently Played',
    'Least Recently Played',
    'Release Date - Ascending',
    'Release Date - Descending'
  ];

  // May be from type "slylist" or "template" or value is null(new playlist).
  // All dependend from which place the user enters this screen.
  Applist playlist;

  SlylistProvider slylistProvider;
  List<Source> sources = [];
  List<Group> groups = [];
  int _activeStep = 0;
  Map _validSteps = {"step_0": false, "step_2": false};
  String _match = "MATCH ANY";
  String _selectedSorting = 'Random';
  bool _isPlaylistPublic = true;
  bool _isPlaylistSynced = true;
  String playlistName = '';
  String songLimit = '';
  SpotifyClient _spotifyClient;

  ScreenProvider(
      SpotifyPlaylistProvider spotifyPlaylistsProvider,
      SlylistProvider slylistProvider,
      Applist playlist,
      SpotifyClient spotifyClient) {
    this._spotifyClient = spotifyClient;
    this.playlist = playlist;
    this.slylistProvider = slylistProvider;
    _combinePlaylistsToSources(spotifyPlaylistsProvider.spotifyPlaylists);
    if (this.playlist == null) {
      // For each NEW playlist, a empty group will be added, to make it easier to start for user
      addGroup();
    } else {
      _initStepsWithExistingPlaylist();
    }
  }

  bool get isPlaylistSynced => _isPlaylistSynced;

  set isPlaylistSynced(bool isPlaylistSynced) {
    _isPlaylistSynced = isPlaylistSynced;
    notifyListeners();
  }

  bool get isPlaylistPublic => _isPlaylistPublic;

  set isPlaylistPublic(bool isPlaylistPublic) {
    _isPlaylistPublic = isPlaylistPublic;
    notifyListeners();
  }

  String get match => _match;

  set match(String match) {
    _match = match;
    notifyListeners();
  }

  Map get validSteps => _validSteps;

  updateValidSteps(String key, bool value) {
    _validSteps[key] = value;
    notifyListeners();
  }

  int get activeStep => _activeStep;

  set activeStep(int activeStep) {
    _activeStep = activeStep;
    notifyListeners();
  }

  String get selectedSorting => _selectedSorting;

  set selectedSorting(String selectedSorting) {
    _selectedSorting = selectedSorting;
    notifyListeners();
  }

  _combinePlaylistsToSources(List<SpotifyPlaylist> spotifyPlaylists) {
    sources = [
      Source('0', 'Songs from complete Library', false, true),
      Source('1', 'Songs from liked Artists', false, true),
      Source('2', 'Songs from liked Albums', false, true),
      Source('3', 'Liked Songs', false, true)
    ];

    spotifyPlaylists.forEach((SpotifyPlaylist spotifyPlaylist) {
      if (playlist != null && playlist is Slylist) {
        Slylist slylist = (playlist as Slylist);
        if (spotifyPlaylist.id != slylist.spotifyId) {
          sources.add(
              Source(spotifyPlaylist.id, spotifyPlaylist.name, false, false));
        }
      } else {
        sources.add(
            Source(spotifyPlaylist.id, spotifyPlaylist.name, false, false));
      }
    });
  }

  void _initStepsWithExistingPlaylist() {
    // Deep clone all groups(including rules and conditions)
    // Because user must be able to discard playlist creation.
    // Thats the reason a fresh copy is needed.
    playlist.groups.forEach((originalGroup) => groups
        .add(Group.fromJson(json.decode(json.encode(originalGroup.toJson())))));

    _validSteps = {"step_0": true, "step_2": true};
    _match = playlist.groupsMatch;
    _selectedSorting = playlist.sort;
    _isPlaylistPublic = playlist.isPublic;
    _isPlaylistSynced = playlist.isSynced;
    playlistName = playlist.name;

    if (playlist.sources[0] == "Complete Library") {
      // Select all sources. Even those playlists that where created after this playlist.
      sources = sources.map((source) {
        source.isSelected = true;
        return source;
      }).toList();
    } else {
      // Select all sources that where selected before.
      sources = sources.map((source) {
        playlist.sources.forEach((sourceId) {
          if (source.id == sourceId) {
            source.isSelected = true;
          }
        });
        return source;
      }).toList();
    }
    (playlist.songLimit != null)
        ? songLimit = playlist.songLimit.toString()
        : songLimit = "";
  }

  void changeSelectAllSources(bool isSelected) {
    for (int i = 0; i < sources.length; i++) {
      sources[i].isSelected = isSelected;
    }
  }

  bool hasSelectedSource() {
    for (int i = 0; i < sources.length; i++) {
      if (sources[i].isSelected) {
        return true;
      }
    }
    return false;
  }

  bool selectMissingOnSelectAllCheckbox() {
    for (int i = 1; i < sources.length; i++) {
      if (!sources[i].isSelected) {
        return false;
      }
    }
    return true;
  }

  void addGroup() {
    groups.add(new Group());
    notifyListeners();
  }

  void removeGroup(Group group) {
    groups.remove(group);
    notifyListeners();
  }

  void addRule(Group group) {
    group.addRule();
    notifyListeners();
  }

  void changeMatchForGroup(Group group) {
    group.changeMatch();
    notifyListeners();
  }

  void changeRule(Rule rule, String name) {
    rule.changeRule(name);
    notifyListeners();
  }

  void removeRule(Group group, String ruleId) {
    group.removeRule(ruleId);
    notifyListeners();
  }

  void changeConditionValue(Rule rule, String type, value) {
    rule.changeConditionValue(type, value);
    notifyListeners();
  }

  Future<void> savePlaylist(context) async {
    List<String> selectedSources = sources
        .where((element) => element.isSelected)
        .map<String>((element) => element.id)
        .toList();

    // Add 1s to the name, until it is unique
    void setUniqueSlylistName() {
      slylistProvider.slylists.forEach((slylist) {
        if (slylist.name == playlistName) {
          playlistName = playlistName + '1';
          setUniqueSlylistName();
        }
      });
    }

    // Update a playlist if it already exists and is a slylist.
    // Templates are (of course) not updated, and only used for creation of new playlists.
    if (playlist != null && playlist is Slylist) {
      // Only if user renamed playlist, check for unique name
      // If user renamed playlist, then name must be unique.
      if (playlist.name != playlistName) {
        setUniqueSlylistName();
      }
      if ((playlist.name != playlistName) ||
          (playlist.isPublic != _isPlaylistPublic)) {
        await _spotifyClient.updateSpotifyPlaylist(
            (playlist as Slylist).spotifyId, playlistName, _isPlaylistPublic);
      }
      slylistProvider.updateSlylist(
          playlist,
          playlistName,
          selectedSources,
          groups,
          _match,
          // If user inputs some shit that can't be parsed to integer, then this function will set value to null
          int.tryParse(songLimit),
          _selectedSorting,
          _isPlaylistPublic,
          _isPlaylistSynced);
      // Create a new playlist if it does not already exist, or the used playlist is from type template.
    } else if (playlist == null || playlist is Template) {
      setUniqueSlylistName();
      final spotifyUserId = await DataCache().readString('spotifyUserId');
      String spotifyId = await _spotifyClient.createSpotifyPlaylistAndGetId(
          playlistName, _isPlaylistPublic, spotifyUserId);
      slylistProvider.createSlylist(
          playlistName,
          selectedSources,
          groups,
          _match,
          // If user inputs some shit that can't be parsed to integer, then this function will set value to null
          int.tryParse(songLimit),
          _selectedSorting,
          _isPlaylistPublic,
          _isPlaylistSynced,
          spotifyId);
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Slylists(_spotifyClient)),
      (Route<dynamic> route) => false,
    );
    await PlaylistManager(_spotifyClient, slylistProvider).updateUsersSpotify();
  }
}

class PlaylistCreation extends StatelessWidget {
  final SpotifyClient _spotifyClient;

  PlaylistCreation(this._spotifyClient);

  setStepIfAllowed(int index, ScreenProvider screenProvider) {
    if (screenProvider.activeStep == 0 && screenProvider.validSteps['step_0']) {
      screenProvider.activeStep = index;
    } else {
      if (screenProvider.activeStep != 0) {
        screenProvider.activeStep = index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Applist playlist = ModalRoute.of(context).settings.arguments;

    return FutureBuilder<dynamic>(
      future: Provider.of<SpotifyPlaylistProvider>(context, listen: false)
          .initSpotifyPlaylists(
              _spotifyClient), // function where you call your api
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ChangeNotifierProvider(
            create: (context) => ScreenProvider(
                Provider.of<SpotifyPlaylistProvider>(context, listen: false),
                Provider.of<SlylistProvider>(context, listen: false),
                playlist,
                _spotifyClient),
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Create Playlist"),
                ),
                body: Consumer<ScreenProvider>(
                  builder: (context, screenProvider, child) {
                    return SizedBox.expand(
                      child: Stepper(
                          steps: [
                            Step(
                              title: Text("Select Source"),
                              content: SelectSourceStep(),
                              isActive: screenProvider.activeStep == 0,
                            ),
                            Step(
                              title: Text("Rules"),
                              content: CreateGroupsRulesStep(),
                              isActive: screenProvider.activeStep == 1,
                            ),
                            Step(
                              title: Text("Details"),
                              content: DetailsStep(),
                              isActive: screenProvider.activeStep == 2,
                            )
                          ],
                          type: StepperType.horizontal,
                          currentStep: screenProvider.activeStep,
                          onStepTapped: (index) =>
                              setStepIfAllowed(index, screenProvider),
                          controlsBuilder: (BuildContext context,
                              {VoidCallback onStepContinue,
                              VoidCallback onStepCancel}) {
                            var backButton = FlatButton(
                              onPressed: () => screenProvider.activeStep =
                                  screenProvider.activeStep - 1,
                              child: const Text('BACK'),
                            );
                            var nextButton = FlatButton(
                              onPressed: !screenProvider.validSteps['step_0']
                                  ? null
                                  : () => setStepIfAllowed(
                                      screenProvider.activeStep + 1,
                                      screenProvider),
                              child: const Text('NEXT'),
                              color: Theme.of(context).accentColor,
                              textColor: Colors.white,
                            );
                            var previewButton = FlatButton(
                              onPressed: () => print("preview"),
                              child: const Text('PREVIEW'),
                            );
                            var saveButton = FlatButton(
                              onPressed: !screenProvider.validSteps['step_2']
                                  ? null
                                  : () => screenProvider.savePlaylist(context),
                              child: const Text('SAVE'),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                            );
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Visibility(
                                    child: backButton,
                                    visible: screenProvider.activeStep != 0),
                                Visibility(
                                    child: nextButton,
                                    visible: screenProvider.activeStep != 2),
                                Spacer(),
                                Visibility(
                                    child: previewButton,
                                    visible: screenProvider.activeStep == 2),
                                Visibility(
                                    child: saveButton,
                                    visible: screenProvider.activeStep == 2)
                              ],
                            );
                          }),
                    );
                  },
                )),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
