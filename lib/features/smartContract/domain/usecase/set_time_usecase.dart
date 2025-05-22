import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class SetTimeUsecase {
  ContractRepository contractRepository;

  SetTimeUsecase({required this.contractRepository});

  ContractData call(int startTime, int endTime) {
    return contractRepository.setTime(startTime, endTime);
  }
}
