import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/repository/contract_repository.dart';

class GetAllDataUsecase {
  final ContractRepository contractRepository;

  const GetAllDataUsecase({required this.contractRepository});

  ContractAllDta call(int faydaNo) {
    return contractRepository.getAllData(faydaNo);
  }
}
