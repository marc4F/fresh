import 'package:slylist_project/models/rule.dart';

enum GroupStatus { matchAny, matchAll }

class Group {
  String name = "Group";
  GroupStatus groupStatus = GroupStatus.matchAny;
  List<Rule> rules = [];

  Group(int index) {
    name = name + " " + index.toString();
  }

  void addRule(){
    rules.add(new Rule());
  }
}
