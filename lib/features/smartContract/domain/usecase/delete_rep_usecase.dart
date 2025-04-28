import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class DeleteRepUsecase {
  final ContractRepository contractRepository;

  const DeleteRepUsecase({required this.contractRepository});

  ContractData call(int partyId,int stateId) {
    return contractRepository.deleteRep(partyId,stateId);
  }
}
