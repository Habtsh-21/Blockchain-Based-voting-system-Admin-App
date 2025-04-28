import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/representative_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class AddRepUsecase {
  final ContractRepository contractRepository;

  const AddRepUsecase({required this.contractRepository});

  ContractData call(RepresentativeEntity repEntity) {
    return contractRepository.addRep(repEntity);
  }
}
