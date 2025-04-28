import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class DeleteStateUsecase {
  final ContractRepository contractRepository;

  const DeleteStateUsecase({required this.contractRepository});

  ContractData call(int stateId) {
    return contractRepository.deleteState(stateId);
  }
}
