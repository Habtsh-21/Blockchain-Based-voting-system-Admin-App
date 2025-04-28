

import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class GetRepUsecase {
  final ContractRepository contractRepository;

  const GetRepUsecase({required this.contractRepository});

  ContractRepList call() {
    return contractRepository.getRep();
  }
}
