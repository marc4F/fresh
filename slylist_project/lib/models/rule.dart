import 'package:slylist_project/common/rule_catalogue.dart';

class Rule {
  String _name;
  List<String> _conditions;

  get name => _name;
  get conditions => _conditions;

  Rule() {
    _name = ruleCatalogue[0]['name'];
    _conditions = ruleCatalogue[0]['conditions'];
  }

  changeRule(String name) {
    _name = name;
    ruleCatalogue.map((rule) =>
        (rule['name'] == name) ? _conditions = rule['conditions'] : null);
  }
}
