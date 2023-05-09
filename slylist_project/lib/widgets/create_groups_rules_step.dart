import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/models/group.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';
import 'package:slylist_project/widgets/conditions/compare.dart';
import 'package:slylist_project/widgets/conditions/days.dart';
import 'package:slylist_project/widgets/conditions/int_value.dart';
import 'package:slylist_project/common/custom_colors.dart';

class CreateGroupsRulesStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => {
                    (screenProvider.match == 'MATCH ANY')
                        ? screenProvider.match = 'MATCH ALL'
                        : screenProvider.match = 'MATCH ANY'
                  },
              child: Text('${screenProvider.match}')),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: screenProvider.groups.length,
            itemBuilder: (context, groupIndex) {
              Group group = screenProvider.groups[groupIndex];
              return Card(
                elevation: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      trailing: TextButton(
                          onPressed: () =>
                              screenProvider.changeMatchForGroup(group),
                          child: Text('${group.match}')),
                      title: Text('Group'),
                    ),
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: group.rules.length,
                        itemBuilder: (context, ruleIndex) {
                          final Rule rule = group.rules[ruleIndex];
                          final String ruleInfo = ruleCatalogue.firstWhere(
                              (catRule) =>
                                  catRule['name'] == rule.name)['info'];
                          return Dismissible(
                            key: Key(rule.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              screenProvider.removeRule(group, rule.id);
                              // Then show a snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('"${rule.name}" removed')));
                            },
                            background: Container(
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children:
                                      buildRule(context, screenProvider, rule),
                                ),
                                Visibility(
                                  visible: ruleInfo != '',
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Info: $ruleInfo",
                                        textScaleFactor: 0.7),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          TextButton.icon(
                              label: const Text('RULE'),
                              icon: Icon(Icons.add),
                              onPressed: () => screenProvider.addRule(group)),
                          Spacer(),
                          Visibility(
                            visible: (groupIndex != 0) ? true : false,
                            child: TextButton.icon(
                              label: const Text('GROUP'),
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  screenProvider.removeGroup(group),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: OutlinedButton.icon(
                  onPressed: () => screenProvider.addGroup(),
                  icon: Icon(Icons.add),
                  label: Text('GROUP')),
            ),
          )
        ],
      );
    });
  }

  List<Widget> buildRule(
      BuildContext context, ScreenProvider screenProvider, Rule rule) {
    List<Widget> ruleWidgets = [];
    Widget ruleSelection = TextButton(
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
      padding: const EdgeInsets.only(left: 10),
    )));
    List conditions = rule.conditions;
    for (int i = 0; i < conditions.length; i++) {
      EdgeInsets padding;
      if (i == conditions.length - 1) {
        padding = const EdgeInsets.fromLTRB(10, 0, 10, 0);
      } else {
        padding = const EdgeInsets.only(left: 10);
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
    case 'days':
      {
        return Days(rule: rule);
      }
      break;
  }
}
