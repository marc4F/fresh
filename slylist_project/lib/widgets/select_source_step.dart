import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class SelectSourceStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: screenProvider.combinedLists.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
              title: Text('${screenProvider.combinedLists[index]['name']}'),
              value: screenProvider.combinedLists[index]['isSelected'],
              onChanged: (bool isSelected) {
                screenProvider.combinedLists[index]['isSelected'] = isSelected;
                if (index == 0) {
                  screenProvider.changeSelectAllSources(isSelected);
                } else {
                  if (!isSelected) {
                    screenProvider.combinedLists[0]['isSelected'] = false;
                  } else if (screenProvider
                      .selectMissingOnSelectAllCheckbox()) {
                    screenProvider.combinedLists[0]['isSelected'] = true;
                  }
                }
                if (screenProvider.hasSelectedSource()) {
                  screenProvider.validStep = 0;
                } else {
                  screenProvider.validStep = null;
                }
              });
        },
      );
    });
  }
}
