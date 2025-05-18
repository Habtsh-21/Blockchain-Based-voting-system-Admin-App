
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/representative_entity.dart';

class RepresentativeModel extends RepresentativeEntity {
  const RepresentativeModel(
      {required super.repName,
      required super.repPhoto,
      required super.partyId,
      required super.stateId,
      super.votes});

  List<dynamic> toList() {
    return [repName, repPhoto, partyId, stateId];
  }

  RepresentativeModel fromList(List<dynamic> list) {
    return RepresentativeModel(
        repName: list[0],
        repPhoto: list[1],
        partyId: list[2],
        stateId: list[4],
        votes: list[4]);
  }
}
