// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) {
  return Rule()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..conditions = json['conditions'] as List;
}

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'conditions': instance.conditions,
    };
