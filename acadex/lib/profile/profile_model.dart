import 'package:hive_ce/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  String name;

  Profile({required this.name});
}
