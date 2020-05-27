// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) {
  return Template(
    json['name'] as String,
    json['description'] as String,
    (json['sources'] as List)?.map((e) => e as String)?.toList(),
    (json['groups'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['groupsMatch'] as String,
    json['songLimit'] as int,
    json['sort'] as String,
    json['isPublic'] as bool,
    json['isSynced'] as bool,
  );
}

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'name': instance.name,
      'sources': instance.sources,
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
      'groupsMatch': instance.groupsMatch,
      'songLimit': instance.songLimit,
      'sort': instance.sort,
      'isPublic': instance.isPublic,
      'isSynced': instance.isSynced,
      'description': instance.description,
    };
