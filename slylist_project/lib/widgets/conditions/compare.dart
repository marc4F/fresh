import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          (condition) => condition['type'] == 'compare');
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
                  itemCount: conditionOptions['compare']
                          ['options']
                      .length,
                  itemBuilder: (context, index) {
                    String conditionOption = conditionOptions['compare']
                        ['options'][index];
                    return ListTile(
                      onTap: () {
                        screenProvider.changeConditionValue(
                            rule,
                            'compare',
                            conditionOption);
                        Navigator.pop(context);
                      },
                      selected: conditionOption == condition['value'],
                      title: Text(
                          '${conditionOptions['compare']['options'][index]}'),
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
