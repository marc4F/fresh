import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/provider/template_playlists.dart';
import 'package:slylist_project/provider/slylist_playlists.dart';
import 'package:slylist_project/widgets/select_source_step.dart';
import 'package:slylist_project/provider/spotify_created_playlists.dart';

class ScreenProvider extends ChangeNotifier {
  List _combinedLists = [];

  List get combinedLists => _combinedLists;

  combineLists(List spotifyCreatedPlaylists, List slylistPlaylists) {
    _combinedLists = [
      {'name': 'Complete Library', 'isSelected': false},
      {'name': 'Liked Artists', 'isSelected': false},
      {'name': 'Liked Albums', 'isSelected': false},
      {'name': 'Liked Songs', 'isSelected': false},
    ];
    for (int i = 0; i < spotifyCreatedPlaylists.length; i++) {
      _combinedLists
          .add({'name': spotifyCreatedPlaylists[i].name, 'isSelected': false});
    }
    for (int i = 0; i < slylistPlaylists.length; i++) {
      _combinedLists
          .add({'name': slylistPlaylists[i].name, 'isSelected': false});
    }
  }

  void selectAllSources(bool isSelected) {
    for (int i = 0; i < _combinedLists.length; i++) {
      _combinedLists[i]['isSelected'] = isSelected;
    }
  }

  bool hasSelectedSource() {
    for (int i = 0; i < _combinedLists.length; i++) {
      if (_combinedLists[i]['isSelected']) {
        return true;
      }
    }
    return false;
  }
}

class PlaylistCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScreenProvider(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Create Playlist"),
          ),
          body: Consumer3<ScreenProvider, SpotifyCreatedPlaylistsProvider,
              SlylistPlaylistsProvider>(
            builder: (context, screenProvider, spotifyCreatedPlaylistsProvider,
                slylistPlaylistsProvider, child) {
              screenProvider.combineLists(
                  spotifyCreatedPlaylistsProvider.spotifyCreatedPlaylists,
                  slylistPlaylistsProvider.slylistPlaylists);
              return PlaylistStepperState();
            },
          )),
    );
  }
}

class PlaylistStepperProvider extends ChangeNotifier {
  int _validStep;
  int _activeStep = 0;

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
}

class PlaylistStepperState extends StatefulWidget {
  @override
  _PlaylistStepperState createState() => _PlaylistStepperState();
}

class _PlaylistStepperState extends State<PlaylistStepperState> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaylistStepperProvider(),
      child: Consumer<PlaylistStepperProvider>(
          builder: (context, playlistStepperProvider, child) => Stepper(
                  steps: [
                    Step(
                      title: Text("Select Source"),
                      content: SelectSourceStep(),
                      isActive: playlistStepperProvider.activeStep == 0,
                    ),
                    Step(
                      title: Text("Rules"),
                      content: Text("${playlistStepperProvider.validStep}"),
                      isActive: playlistStepperProvider.activeStep == 1,
                    ),
                    Step(
                      title: Text("Details"),
                      content: Text("This is our third example."),
                      isActive: playlistStepperProvider.activeStep == 2,
                    )
                  ],
                  currentStep: playlistStepperProvider.activeStep,
                  onStepTapped: (playlistStepperProvider.validStep != 0)
                      ? null
                      : (index) => setState(() {
                            playlistStepperProvider.activeStep = index;
                          }),
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    var backButton = FlatButton(
                      onPressed: () => playlistStepperProvider.activeStep =
                          playlistStepperProvider.activeStep - 1,
                      child: const Text('BACK'),
                    );
                    var nextButton = FlatButton(
                      onPressed: playlistStepperProvider.validStep != 0
                          ? null
                          : () => playlistStepperProvider.activeStep =
                              playlistStepperProvider.activeStep + 1,
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
                            visible: playlistStepperProvider.activeStep != 0),
                        Visibility(
                            child: nextButton,
                            visible: playlistStepperProvider.activeStep != 2),
                        Spacer(),
                        Visibility(
                            child: previewButton,
                            visible: playlistStepperProvider.activeStep == 2),
                        Visibility(
                            child: saveButton,
                            visible: playlistStepperProvider.activeStep == 2)
                      ],
                    );
                  })),
    );
  }
}
