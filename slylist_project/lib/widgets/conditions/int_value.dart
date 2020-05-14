import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/models/rule.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class IntValueProvider extends ChangeNotifier {
/*   String _dropdownValue = "is";

  get dropdownValue => _dropdownValue;

  set dropdownValue(newValue) {
    _dropdownValue = newValue;
    notifyListeners();
  } */
}

class IntValue extends StatelessWidget {
  final Rule rule;

  IntValue({this.rule});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IntValueProvider(),
      child: Consumer2<ScreenProvider, IntValueProvider>(
          builder: (context, screenProvider, intValueProvider, child) {
        return Container(
            constraints: BoxConstraints(maxWidth: 80),
            child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ]));
      }),
    );
  }
}
