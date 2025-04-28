import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/repository/auth_repo.dart';

class LogOutUsecase {
  AuthRepository authRepository;

  LogOutUsecase(this.authRepository);

  AdminUnit call() {
    return authRepository.logOut();
  }
}
