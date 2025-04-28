import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';
import 'package:equatable/equatable.dart';

class RepresentativeEntity extends Equatable {
  final String repName;
  final String repPhoto;
  final PartyEntity party;
  final StateEntity state;
  final int votes;

  const RepresentativeEntity(
      {required this.repName,
      required this.repPhoto,
      required this.party,
      required this.state,
      this.votes = 0,
      });

  @override
  List<Object?> get props => [party, state];
}
