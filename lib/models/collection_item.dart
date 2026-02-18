import 'basic_info.dart';

class CollectionItem {
  final int id;
  final int instanceId;
  final BasicInfo basicInfo;

  CollectionItem({
    required this.id,
    required this.instanceId,
    required this.basicInfo,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      id: json['id'],
      instanceId: json['instance_id'],
      basicInfo: BasicInfo.fromJson(json['basic_information']),
    );
  }
}
