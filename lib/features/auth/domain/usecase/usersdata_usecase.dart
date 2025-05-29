import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/domain/repository/auth_repo.dart';

class UsersdataUsecase {
  AuthRepository authRepository;
  UsersdataUsecase({required this.authRepository});

  AdminData call() {
    return authRepository.usersData();
  }
}
