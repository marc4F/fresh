import 'package:slylist_project/models/rule.dart';

enum GroupStatus { matchAny, matchAll }

class Group {
  String _name = "Group";
  GroupStatus _groupStatus = GroupStatus.matchAny;
  List<Rule> _rules = [];

  Group(int index) {
    _name = _name + " " + index.toString();
  }

  void addRule(){
    _rules.add(new Rule());
  }

  get groupStatus => _groupStatus;
  get rules => _rules;
}
