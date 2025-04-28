import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/representative_entity.dart';

class RepresentativeModel extends RepresentativeEntity {
  const RepresentativeModel(
      {required super.repName,
      required super.repPhoto,
      required super.party,
      required super.state,
      super.votes});

  List<dynamic> toList() {
    return [repName, repPhoto, party.partyId, state.stateId];
  }

  RepresentativeModel fromList(List<dynamic> list) {
    return RepresentativeModel(
        repName: list[0],
        repPhoto: list[1],
        party: PartyModel(
            partyName: list[2][0],
            partySymbol: list[2][1],
            partyId: list[2][2]),
        state: StateModel(stateName: list[3][0], stateId: list[3][1]),
        votes: list[4]);
  }
}
