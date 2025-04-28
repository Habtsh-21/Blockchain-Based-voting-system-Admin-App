import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class DeletePartyUsecase {
  final ContractRepository contractRepository;

  const DeletePartyUsecase({required this.contractRepository});

  ContractData call(int partyId) {
    return contractRepository.deleteParty(partyId);
  }
}
