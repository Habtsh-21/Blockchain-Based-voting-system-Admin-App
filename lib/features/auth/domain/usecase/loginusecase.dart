import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/entities/admin_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/repository/auth_repo.dart';

class LogInUsecase {
  AuthRepository authRepository;
  LogInUsecase(this.authRepository);

  AdminData call(AdminEntity adminEntity) {
    return authRepository.logIn(adminEntity);
  }
}
