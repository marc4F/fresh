import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class SelectSourceStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      bool dividerPlaced = false;
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: screenProvider.sources.length,
        itemBuilder: (context, index) {
          bool isDefault = screenProvider.sources[index].isDefault;
          if (isDefault || dividerPlaced) {
            return buildCheckboxListTile(screenProvider, index);
          } else {
            dividerPlaced = true;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new Container(
                      child: new ListTile(
                          title: new Text(
                        'Your Playlists:',
                        textScaleFactor: 1.2,
                      )),
                      decoration: new BoxDecoration(
                          border: new Border(bottom: new BorderSide()))),
                ),
                buildCheckboxListTile(screenProvider, index)
              ],
            );
          }
        },
      );
    });
  }

  CheckboxListTile buildCheckboxListTile(
      ScreenProvider screenProvider, int index) {
    return CheckboxListTile(
        title: Text('${screenProvider.sources[index].name}'),
        value: screenProvider.sources[index].isSelected,
        onChanged: (bool isSelected) {
          screenProvider.sources[index].isSelected = isSelected;
          if (index == 0) {
            screenProvider.changeSelectAllSources(isSelected);
          } else {
            if (!isSelected) {
              screenProvider.sources[0].isSelected = false;
            } else if (screenProvider.selectMissingOnSelectAllCheckbox()) {
              screenProvider.sources[0].isSelected = true;
            }
          }
          // State gets updated here. So changeSelectAllSources can be called without notifylisteners.
          if (screenProvider.hasSelectedSource()) {
            screenProvider.updateValidSteps('step_0', true);
          } else {
            screenProvider.updateValidSteps('step_0', false);
          }
        });
  }
}
