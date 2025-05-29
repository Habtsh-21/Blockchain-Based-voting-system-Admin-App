import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/entities/admin_entity.dart';

abstract class AuthRepository {
  AdminUnit logIn(AdminEntity adminEntity);
  AdminUnit logOut();
  AdminData usersData();
}
