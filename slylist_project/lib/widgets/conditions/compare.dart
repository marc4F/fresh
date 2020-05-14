import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class CompareProvider extends ChangeNotifier {
  String _dropdownValue = "is";

  get dropdownValue => _dropdownValue;

  set dropdownValue(newValue) {
    _dropdownValue = newValue;
    notifyListeners();
  }
}

class Compare extends StatelessWidget {
  final Rule rule;

  Compare({this.rule});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompareProvider(),
      child: Consumer2<ScreenProvider, CompareProvider>(
          builder: (context, screenProvider, compareProvider, child) {
        return DropdownButton<String>(
            value: compareProvider.dropdownValue,
            onChanged: (String newValue) {
              compareProvider.dropdownValue = newValue;
              rule.changeConditionValue('compare', newValue);
            },
            items: <String>[
              'is',
              'is not',
              'greater than',
              'less than',
              'is at least',
              'is at most'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList());
      }),
    );
  }
}
