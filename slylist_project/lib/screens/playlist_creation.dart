import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/const.dart';
import 'package:slylist_project/common/enums.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/playlist.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/provider/template_playlists.dart';
import 'package:slylist_project/provider/slylist_playlists.dart';
import 'package:slylist_project/widgets/create_groups_rules_step.dart';
import 'package:slylist_project/widgets/details_step.dart';
import 'package:slylist_project/widgets/select_source_step.dart';
import 'package:slylist_project/provider/spotify_created_playlists.dart';

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
  Playlist _existingPlaylist;
  SlylistPlaylistsProvider _slylistPlaylistsProvider;
  List sources = [];
  List<Group> groups = [];
  int _activeStep = 0;
  Map _validSteps = {"step_0": false, "step_2": false};
  String _match = "MATCH ANY";
  String _selectedSorting = 'Random';
  bool _isPlaylistPublic = true;
  bool _isPlaylistSynced = true;
  String playlistName = '';
  String songLimit = '';

  ScreenProvider(
      SpotifyCreatedPlaylistsProvider spotifyCreatedPlaylistsProvider,
      SlylistPlaylistsProvider slylistPlaylistsProvider,
      Playlist playlist) {
    _existingPlaylist = playlist;
    _slylistPlaylistsProvider = slylistPlaylistsProvider;
    _combinePlaylistsToSources(
        spotifyCreatedPlaylistsProvider.spotifyCreatedPlaylists,
        slylistPlaylistsProvider.slylistPlaylists);
    if (playlist == null) {
      // For each NEW playlist, a empty group will be added, to make it easier for user
      addGroup();
    } else {
      _initStepsWithExistingPlaylist(playlist);
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

  _combinePlaylistsToSources(
      List spotifyCreatedPlaylists, List slylistPlaylists) {
    sources = [
      {'name': 'Complete Library', 'isSelected': false},
      {'name': 'Liked Artists', 'isSelected': false},
      {'name': 'Liked Albums', 'isSelected': false},
      {'name': 'Liked Songs', 'isSelected': false},
    ];
    for (int i = 0; i < spotifyCreatedPlaylists.length; i++) {
      sources
          .add({'name': spotifyCreatedPlaylists[i].name, 'isSelected': false});
    }
    for (int i = 0; i < slylistPlaylists.length; i++) {
      // Prevent that the slylist playlist becomes a source itself
      if (_existingPlaylist?.name != slylistPlaylists[i].name) {
        sources.add({'name': slylistPlaylists[i].name, 'isSelected': false});
      }
    }
  }

  void _initStepsWithExistingPlaylist(Playlist playlist) {
    
    for(var i = 0; i < playlist.groups.length; i++){
      List<Rule> rules = [];
      for(var k = 0; k < playlist.groups[i].rules.length; k++){
        rules.add(Rule.clone(playlist.groups[i].rules[k]));
      }
      groups.add(Group.clone(playlist.groups[i], rules));
    }

    _validSteps = {"step_0": true, "step_2": true};
    _match = playlist.groupsMatch;
    _selectedSorting = playlist.sort;
    _isPlaylistPublic = playlist.isPublic;
    _isPlaylistSynced = playlist.isSynced;
    playlistName = playlist.name;

    if (playlist.sources[0] == "Complete Library") {
      // Select all sources. Even those playlists that where created after this playlist.
      sources = sources.map((list) {
        list['isSelected'] = true;
        return list;
      }).toList();
    } else {
      // Select all sources that where selected before.
      sources = sources.map((list) {
        playlist.sources.forEach((source) {
          if (source == list['name']) {
            list['isSelected'] = true;
          }
        });
        return list;
      }).toList();
    }
    (playlist.songLimit != null)
        ? songLimit = playlist.songLimit.toString()
        : songLimit = "";
  }

  void changeSelectAllSources(bool isSelected) {
    for (int i = 0; i < sources.length; i++) {
      sources[i]['isSelected'] = isSelected;
    }
  }

  bool hasSelectedSource() {
    for (int i = 0; i < sources.length; i++) {
      if (sources[i]['isSelected']) {
        return true;
      }
    }
    return false;
  }

  bool selectMissingOnSelectAllCheckbox() {
    for (int i = 1; i < sources.length; i++) {
      if (!sources[i]['isSelected']) {
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

  void changeConditionValue(Rule rule, Conditions type, value) {
    rule.changeConditionValue(type, value);
    notifyListeners();
  }

  void savePlaylist(context) {
    List<String> selectedSources = sources
        .where((element) => element['isSelected'])
        .map<String>((element) => element['name'])
        .toList();

    // Add 1s to the name, until it is unique
    void setUniquePlaylistName() {
      for (var i = 0; i < sources.length; i++) {
        if (sources[i]['name'] == playlistName) {
          playlistName = playlistName + '1';
          setUniquePlaylistName();
        }
      }
    }

    setUniquePlaylistName();

    if (_existingPlaylist != null) {
      _slylistPlaylistsProvider.updatePlaylist(
          _existingPlaylist,
          playlistName,
          selectedSources,
          groups,
          _match,
          int.tryParse(songLimit),
          _selectedSorting,
          _isPlaylistPublic,
          _isPlaylistSynced);
    } else {
      _slylistPlaylistsProvider.createPlaylist(
          playlistName,
          selectedSources,
          groups,
          _match,
          int.tryParse(songLimit),
          _selectedSorting,
          _isPlaylistPublic,
          _isPlaylistSynced);
    }
    Navigator.pushNamed(context, '/');
  }
}

class PlaylistCreation extends StatelessWidget {
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
    final Playlist playlist = ModalRoute.of(context).settings.arguments;
    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(
          Provider.of<SpotifyCreatedPlaylistsProvider>(context, listen: false),
          Provider.of<SlylistPlaylistsProvider>(context, listen: false),
          playlist),
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
                                screenProvider.activeStep + 1, screenProvider),
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
  }
}
