import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/enums.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/common/custom_colors.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class Compare extends StatelessWidget {
  final Rule rule;

  Compare({this.rule});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(
        builder: (context, screenProvider, child) {
      var condition = rule.conditions.firstWhere(
          (condition) => condition['type'] == Conditions.compare);
      if (condition['value'] == null) condition['value'] = "is";
      return FlatButton(
        color: Theme.of(context).colorScheme.ruleButton,
        child: Text('${condition['value']}',
            overflow: TextOverflow.ellipsis),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 3,
                child: ListView.separated(
                  itemCount: conditionOptions[Conditions.compare]
                          ['options']
                      .length,
                  itemBuilder: (context, index) {
                    String conditionOption = conditionOptions[Conditions.compare]
                        ['options'][index];
                    return ListTile(
                      onTap: () {
                        screenProvider.changeConditionValue(
                            rule,
                            Conditions.compare,
                            conditionOption,
                            true);
                        Navigator.pop(context);
                      },
                      selected: conditionOption == condition['value'],
                      title: Text(
                          '${conditionOptions[Conditions.compare]['options'][index]}'),
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
    });
  }
}
