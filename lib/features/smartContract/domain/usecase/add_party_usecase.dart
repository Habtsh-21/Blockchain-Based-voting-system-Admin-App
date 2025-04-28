import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class AddPartyUsecase {
  final ContractRepository contractRepository;

  const AddPartyUsecase({required this.contractRepository});

  ContractData call(PartyEntity partyEntity) {
    return contractRepository.addParty(partyEntity);
  }
}
