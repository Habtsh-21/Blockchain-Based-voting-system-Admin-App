import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';

class AllDataModel {
  List<PartyModel> parties;
 List<StateModel> states;
  int totalVotes;
  bool votingPaused;
  bool isVotringActive;
  int votingStateTime;
  int votingEndTime;

  AllDataModel(
      {required this.parties,
      required this.states,
      required this.totalVotes,
      required this.votingPaused,
      required this.isVotringActive,
      required this.votingStateTime,
      required this.votingEndTime});
}
