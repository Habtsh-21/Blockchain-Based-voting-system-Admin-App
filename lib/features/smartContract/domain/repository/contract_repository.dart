import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/resource/type.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/party_entity.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/domain/entities/state_entity.dart';

abstract class ContractRepository {
  ContractData addParty(PartyEntity partyEntity);
  ContractData addState(StateEntity stateEntity);
  ContractPartyList getParty();
  ContractStateList getState();
  ContractData deleteParty(int partyId);
  ContractData deleteState(int stateId);
  ContractAllDta getAllData();
  ContractData uploadImage(File pickedFile, String fileName);
  ContractData setTime(int startTime, int endTime);
  ContractData pause(bool pause);
}
