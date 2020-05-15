import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/enums.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class IntValue extends StatelessWidget {
  final Rule rule;

  IntValue({this.rule});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      var condition = rule.conditions
          .firstWhere((condition) => condition['type'] == Conditions.intValue);
      String value;
      if(condition['value'] == null){
        value = '';
      }else{
        value = condition['value'];
      }
      return TextField(
          controller: TextEditingController(text: "$value"),
          onSubmitted: (String value) => screenProvider.changeConditionValue(
              rule, Conditions.intValue, value),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ]);
    });
  }
}
