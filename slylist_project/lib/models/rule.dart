import 'package:slylist_project/common/rule_catalogue.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rule.g.dart';

@JsonSerializable()
class Rule {
  String id;
  String name;
  List conditions = [];

  Rule() {
    //Sets the rule to default first entry of rule catalogue
    name = ruleCatalogue[0]['name'];
    setConditionsToDefault(ruleCatalogue[0]['conditions']);
    // Generate a (time-based) unique id
    id = Uuid().v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
  }

  changeRule(String newRuleName) {
    name = newRuleName;
    ruleCatalogue.forEach((rule) {
      if (rule['name'] == name) {
        conditions = [];
        setConditionsToDefault(rule['conditions']);
      }
    });
  }

  setConditionsToDefault(List<String> catalogueConditions) {
    catalogueConditions
        .forEach((type) => conditions.add({'type': type, 'value': null}));
  }

  changeConditionValue(String type, value) {
    for (var i = 0; i < conditions.length; i++) {
      if (type == conditions[i]['type']) {
        conditions[i]['value'] = value;
      }
    }
  }

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);

  Map<String, dynamic> toJson() => _$RuleToJson(this);
}
