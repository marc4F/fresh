import 'package:slylist_project/common/rule_catalogue.dart';

class Rule {
  String name;
  List conditions = [];

  Rule() {
    name = ruleCatalogue[0]['name'];
    setConditionsToDefault(ruleCatalogue[0]['conditions']);
  }

  changeRule(String newRuleName) {
    name = newRuleName;
    ruleCatalogue.forEach((rule) {
      if (rule['name'] == name) {
        setConditionsToDefault(rule['conditions']);
      }
    });
  }

  setConditionsToDefault(List catalogueConditions) {
    catalogueConditions
        .forEach((type) => conditions.add({'type': type, 'value': null}));
  }

  changeConditionValue(type, value) {
    for (var i = 0; i < conditions.length; i++) {
      if (type == conditions[i]['type']) {
        conditions[i]['value'] = value;
      }
    }
  }
}
