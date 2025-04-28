import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class AddStateUsecase {
  final ContractRepository contractRepository;

  const AddStateUsecase({required this.contractRepository});

  ContractData call(StateEntity stateEntity) {
    return contractRepository.addState(stateEntity);
  }
}
