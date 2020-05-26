import 'package:json_annotation/json_annotation.dart';
import 'package:slylist_project/models/rule.dart';

part 'group.g.dart';

@JsonSerializable(explicitToJson: true)
class Group {
  List<Rule> rules = [];
  String match = 'MATCH ANY';

  Group();

  void addRule() {
    rules.add(new Rule());
  }

  void removeRule(String id) {
    rules.removeWhere((rule) => rule.id == id);
  }

  void changeMatch() {
    (match == 'MATCH ANY') ? match = 'MATCH ALL' : match = 'MATCH ANY';
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
