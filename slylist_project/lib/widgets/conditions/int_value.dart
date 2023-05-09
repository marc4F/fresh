import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class IntValue extends StatelessWidget {
  final Rule rule;

  IntValue({this.rule});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      var condition = rule.conditions
          .firstWhere((condition) => condition['type'] == 'intValue');
      String value;
      if (condition['value'] == null) {
        value = '';
      } else {
        value = condition['value'];
      }
      return TextFormField(
          onChanged: (String value) =>
              screenProvider.changeConditionValue(rule, 'intValue', value),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Number', isDense: true),
          initialValue: value,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]);
    });
  }
}
