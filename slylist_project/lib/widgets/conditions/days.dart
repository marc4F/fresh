import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class Days extends StatelessWidget {
  final Rule rule;
  final id = "days";

  Days({this.rule});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      var condition =
          rule.conditions.firstWhere((condition) => condition['type'] == id);
      String value;
      if (condition['value'] == null) {
        value = '';
      } else {
        value = condition['value'];
      }
      return TextFormField(
          onChanged: (String value) =>
              screenProvider.changeConditionValue(rule, id, value),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Days', isDense: true),
          initialValue: value,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ]);
    });
  }
}
