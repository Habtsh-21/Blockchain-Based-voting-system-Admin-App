
import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class GetStateUsecase {
  final ContractRepository contractRepository;

  const GetStateUsecase({required this.contractRepository});

  ContractStateList call() {
    return contractRepository.getState();
  }
}
