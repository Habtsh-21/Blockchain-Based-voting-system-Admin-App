import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class TransferOwnershipUsecase {
  final ContractRepository contractRepository;

  const TransferOwnershipUsecase({required this.contractRepository});

  ContractData call(String newAddress) {
    return contractRepository.transferOwnership(newAddress);
  }
}
