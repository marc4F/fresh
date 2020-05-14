import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class CreateRulesStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlatButton(onPressed: null, child: const Text('Match Any')),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: screenProvider.groups.length,
            itemBuilder: (context, index1) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      trailing: FlatButton(
                          onPressed: null, child: const Text('Match Any')),
                      title: Text('Group 1'),
                    ),
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: screenProvider.groups[index1].rules.length,
                        itemBuilder: (context, index2) {
                          return Row(
                            children: <Widget>[
                              DropdownButton<String>(
                                value: screenProvider
                                    .groups[index1].rules[index2].name,
                                onChanged: (String newValue) {
                                  screenProvider.changeRule(
                                      screenProvider
                                          .groups[index1].rules[index2],
                                      newValue);
                                },
                                items: ruleCatalogue.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value['name'],
                                    child: Text(value['name']),
                                  );
                                }).toList(),
                              )
                            ],
                          );
                        }),
                    Row(
                      children: <Widget>[
                        FlatButton(
                            child: const Text('ADD RULE'),
                            onPressed: () => screenProvider
                                .addRule(screenProvider.groups[index1])),
                        Spacer(),
                        FlatButton(
                          child: const Text('REMOVE'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
