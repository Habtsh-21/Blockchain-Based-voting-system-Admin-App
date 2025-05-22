

import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class PauseUsecase {
  ContractRepository contractRepository;

  PauseUsecase({required this.contractRepository});

  ContractData call(bool pause) {
    return contractRepository.pause(pause);
  }
}
