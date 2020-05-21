import 'package:slylist_project/models/rule.dart';

class Group {
  List<Rule> rules = [];
  String match = 'MATCH ANY';

  Group();

  Group.clone(Group originalGroup) {
    List<Rule> rules = [];
    originalGroup.rules
        .forEach((originalRule) => rules.add(Rule.clone(originalRule)));
    this.rules = rules;
    match = originalGroup.match;
  }

  void addRule() {
    rules.add(new Rule());
  }

  void removeRule(String id) {
    rules.removeWhere((rule) => rule.id == id);
  }

  void changeMatch() {
    (match == 'MATCH ANY') ? match = 'MATCH ALL' : match = 'MATCH ANY';
  }
}
