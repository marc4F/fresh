import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class DetailsStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                // We need to wrap the input in a statefulwidget. Else the cursor will fuck up on repaint.
                child: TextFormField(
                  onChanged: (String playlistName) {
                    screenProvider.playlistName = playlistName;
                    if (playlistName != '') {
                      screenProvider.updateValidSteps('step_2', true);
                    }else{
                      screenProvider.updateValidSteps('step_2', false);
                    }
                  },
                  initialValue: screenProvider.playlistName,
                  decoration: InputDecoration(labelText: 'Playlist Name *'),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sort'),
                isExpanded: true,
                value: screenProvider.selectedSorting,
                onChanged: (String selectedSorting) {
                  screenProvider.selectedSorting = selectedSorting;
                },
                items: ScreenProvider.sortings.map((sorting) {
                  return DropdownMenuItem<String>(
                    value: sorting,
                    child: Text(sorting),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                  decoration: InputDecoration(labelText: 'Song Limit'),
                  onChanged: (String songLimit) =>
                      screenProvider.songLimit = songLimit,
                  initialValue: screenProvider.songLimit,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ]),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SwitchListTile(
                  title: const Text('Playlist is public'),
                  value: screenProvider.isPlaylistPublic,
                  onChanged: (bool isPlaylistPublic) {
                    screenProvider.isPlaylistPublic = isPlaylistPublic;
                  },
                  secondary: const Icon(Icons.visibility),
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SwitchListTile(
                  title: const Text('Keep playlist updated after creation'),
                  value: screenProvider.isPlaylistSynced,
                  onChanged: (bool isPlaylistSynced) {
                    screenProvider.isPlaylistSynced = isPlaylistSynced;
                  },
                  secondary: const Icon(Icons.sync),
                ))
          ]);
    });
  }
}
