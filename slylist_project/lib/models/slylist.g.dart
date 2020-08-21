// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slylist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slylist _$SlylistFromJson(Map<String, dynamic> json) {
  return Slylist(
    json['name'] as String,
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
  )..spotifyId = json['spotifyId'] as String;
}

Map<String, dynamic> _$SlylistToJson(Slylist instance) => <String, dynamic>{
      'name': instance.name,
      'sources': instance.sources,
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
      'groupsMatch': instance.groupsMatch,
      'songLimit': instance.songLimit,
      'sort': instance.sort,
      'isPublic': instance.isPublic,
      'isSynced': instance.isSynced,
      'spotifyId': instance.spotifyId,
    };
