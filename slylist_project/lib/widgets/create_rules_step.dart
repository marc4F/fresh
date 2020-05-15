import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';
import 'package:slylist_project/widgets/conditions/compare.dart';
import 'package:slylist_project/widgets/conditions/int_value.dart';
import 'package:slylist_project/common/custom_colors.dart';

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
                            children: buildRule(
                                context,
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

  List<Widget> buildRule(
      BuildContext context, ScreenProvider screenProvider, Rule rule) {
    List<Widget> ruleWidgets = [];
    Widget ruleSelection = FlatButton(
      color: Theme.of(context).colorScheme.ruleButton,
      child: Text('${rule.name}', overflow: TextOverflow.ellipsis),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height / 3,
              child: ListView.separated(
                itemCount: ruleCatalogue.length,
                itemBuilder: (context, index) {
                  String value = ruleCatalogue[index]['name'];
                  return ListTile(
                    onTap: () {
                      screenProvider.changeRule(rule, value);
                      Navigator.pop(context);
                    },
                    selected: value == rule.name,
                    title: Text('$value'),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            );
          },
        );
      },
    );
    ruleWidgets.add(Expanded(
        child: Padding(
      child: ruleSelection,
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
    )));
    List conditions = rule.conditions;
    for (int i = 0; i < conditions.length; i++) {
      EdgeInsets padding;
      if (i == conditions.length - 1) {
        padding = const EdgeInsets.fromLTRB(8, 8, 8, 0);
      } else {
        padding = const EdgeInsets.fromLTRB(8, 8, 0, 0);
      }
      ruleWidgets.add(Expanded(
          child: Padding(
        child: createWidgetforCondition(rule, conditions[i]),
        padding: padding,
      )));
    }
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
    case 'duration':
      {
        return IntValue(rule: rule);
      }
      break;
  }
}
