import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:slylist_project/common/custom_colors.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class CompareProvider extends ChangeNotifier {
  String _sheetValue = "is";

  get sheetValue => _sheetValue;

  set sheetValue(newValue) {
    _sheetValue = newValue;
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
        return FlatButton(
          color: Theme.of(context).colorScheme.ruleButton,
          child: Text('${compareProvider.sheetValue}',
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
                    itemCount: conditionCatalogue['compare']['options'].length,
                    itemBuilder: (context, index) {
                      String value =
                          conditionCatalogue['compare']['options'][index];
                      return ListTile(
                        onTap: () {
                          compareProvider.sheetValue =
                              conditionCatalogue['compare']['options'][index];
                          Navigator.pop(context);
                        },
                        selected: value == compareProvider.sheetValue,
                        title: Text(
                            '${conditionCatalogue['compare']['options'][index]}'),
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
      }),
    );
  }
}
