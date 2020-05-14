import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';
import 'package:slylist_project/widgets/conditions/compare.dart';
import 'package:slylist_project/widgets/conditions/int_value.dart';

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
            itemBuilder: (context, groupIndex) {
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
                        itemCount:
                            screenProvider.groups[groupIndex].rules.length,
                        itemBuilder: (context, ruleIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: buildRule(
                                screenProvider,
                                screenProvider
                                    .groups[groupIndex].rules[ruleIndex]),
                          );
                        }),
                    Row(
                      children: <Widget>[
                        FlatButton(
                            child: const Text('ADD RULE'),
                            onPressed: () => screenProvider
                                .addRule(screenProvider.groups[groupIndex])),
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

  List<Widget> buildRule(ScreenProvider screenProvider, Rule rule) {
    List<Widget> ruleWidgets = [];
    var ruleSelection = DropdownButton<String>(
      value: rule.name,
      onChanged: (String newValue) {
        screenProvider.changeRule(rule, newValue);
      },
      items: ruleCatalogue.map((value) {
        return DropdownMenuItem<String>(
          value: value['name'],
          child: Text(value['name']),
        );
      }).toList(),
    );
    ruleWidgets.add(ruleSelection);
    rule.conditions.forEach((condition) =>
        ruleWidgets.add(createWidgetforCondition(rule, condition)));
    return ruleWidgets;
  }
}

Widget createWidgetforCondition(rule, condition) {
  switch (condition['type']) {
    case 'compare':
      {
        return Compare(rule: rule);
      }
    case 'intValue':
      {
        return IntValue(rule: rule);
      }
      break;
  }
}
