import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/enums.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/provider/template_playlists.dart';
import 'package:slylist_project/provider/slylist_playlists.dart';
import 'package:slylist_project/widgets/create_groups_rules_step.dart';
import 'package:slylist_project/widgets/select_source_step.dart';
import 'package:slylist_project/provider/spotify_created_playlists.dart';

class ScreenProvider extends ChangeNotifier {
  List combinedLists = [];
  List<Group> groups = [];
  int _activeStep = 0;
  int _validStep;
  String _match = "MATCH ANY";

  ScreenProvider(
      SpotifyCreatedPlaylistsProvider spotifyCreatedPlaylistsProvider,
      SlylistPlaylistsProvider slylistPlaylistsProvider) {
    _combineLists(spotifyCreatedPlaylistsProvider.spotifyCreatedPlaylists,
        slylistPlaylistsProvider.slylistPlaylists);
    addGroup();
  }

  String get match => _match;

  set match(String match) {
    _match = match;
    notifyListeners();
  }

  int get validStep => _validStep;
  int get activeStep => _activeStep;

  set validStep(int validStep) {
    _validStep = validStep;
    notifyListeners();
  }

  set activeStep(int activeStep) {
    _activeStep = activeStep;
    notifyListeners();
  }

  _combineLists(List spotifyCreatedPlaylists, List slylistPlaylists) {
    combinedLists = [
      {'name': 'Complete Library', 'isSelected': false},
      {'name': 'Liked Artists', 'isSelected': false},
      {'name': 'Liked Albums', 'isSelected': false},
      {'name': 'Liked Songs', 'isSelected': false},
    ];
    for (int i = 0; i < spotifyCreatedPlaylists.length; i++) {
      combinedLists
          .add({'name': spotifyCreatedPlaylists[i].name, 'isSelected': false});
    }
    for (int i = 0; i < slylistPlaylists.length; i++) {
      combinedLists
          .add({'name': slylistPlaylists[i].name, 'isSelected': false});
    }
  }

  void changeSelectAllSources(bool isSelected) {
    for (int i = 0; i < combinedLists.length; i++) {
      combinedLists[i]['isSelected'] = isSelected;
    }
  }

  bool hasSelectedSource() {
    for (int i = 0; i < combinedLists.length; i++) {
      if (combinedLists[i]['isSelected']) {
        return true;
      }
    }
    return false;
  }

  bool selectMissingOnSelectAllCheckbox() {
    for (int i = 1; i < combinedLists.length; i++) {
      if (!combinedLists[i]['isSelected']) {
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
}

class PlaylistCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(
          Provider.of<SpotifyCreatedPlaylistsProvider>(context, listen: false),
          Provider.of<SlylistPlaylistsProvider>(context, listen: false)),
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
                        content: Text("This is our third example."),
                        isActive: screenProvider.activeStep == 2,
                      )
                    ],
                    type: StepperType.horizontal,
                    currentStep: screenProvider.activeStep,
                    onStepTapped: (screenProvider.validStep != 0)
                        ? null
                        : (index) => screenProvider.activeStep = index,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      var backButton = FlatButton(
                        onPressed: () => screenProvider.activeStep =
                            screenProvider.activeStep - 1,
                        child: const Text('BACK'),
                      );
                      var nextButton = FlatButton(
                        onPressed: screenProvider.validStep != 0
                            ? null
                            : () => screenProvider.activeStep =
                                screenProvider.activeStep + 1,
                        child: const Text('NEXT'),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      );
                      var previewButton = FlatButton(
                        onPressed: () => print("preview"),
                        child: const Text('PREVIEW'),
                      );
                      var saveButton = FlatButton(
                        onPressed: () => print("save"),
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
