import 'dart:convert';

import 'package:blockchain_based_national_election_admin_app/core/exception/exception.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/rep_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

const String _rpcUrl =
    'https://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String _wsUrl =
    'ws://eth-sepolia.g.alchemy.com/v2/-ojPUotrULaRUfZmH3MRZTFQ7OH1wB22';
const String contractAddress = "0xEF504cE4D8c5f16Cc9552B77b435B75cb517ccf8";
const String PRIVATE_KEY =
    "9d9a132e6a883f1effe0520f10ccf060c6829c2d9df2f30c7261dd704466fab4";

abstract class RemoteContractDataSource {
  Future<String> addParty(PartyModel partyModel);
  Future<String> addState(StateModel stateModel);
  Future<String> addRep(RepresentativeModel repModel);
  Future<String> deleteParty(int partyId);
  Future<String> deleteState(int stateId);
  Future<String> deleteRep(int partyId, int stateId);
  Future<List<PartyModel>> getParties();
  Future<List<StateModel>> getState();
  Future<List<RepresentativeModel>> getRep();
}

class RemoteContractDataSourceImpl extends RemoteContractDataSource {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _addParty;
  late ContractFunction _addState;
  late ContractFunction _addRep;
  late ContractFunction _deleteParty;
  late ContractFunction _deleteState;
  late ContractFunction _deleteRep;
  late ContractFunction _getParties;
  late ContractFunction _getStates;
  late ContractFunction _getReps;
  late EthereumAddress _contractAddress;
  late ContractAbi _contractAbi;
  late Credentials _credentials;

  void init() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    _credentials = EthPrivateKey.fromHex(PRIVATE_KEY);
    String abiString =
        await rootBundle.loadString('assets/file/json/abi.json');
    Map<String, dynamic> jsondecoded = jsonDecode(abiString);

    final abiJson = jsondecoded['abi'] as List<dynamic>;

    _contractAbi = ContractAbi.fromJson(jsonEncode(abiJson), 'Voting');

    _contractAddress = EthereumAddress.fromHex(contractAddress);

    _contract = DeployedContract(
      _contractAbi,
      _contractAddress,
    );
  }

  @override
  Future<String> addParty(PartyModel partyModel) async {
    try {
      init();
      _addParty = _contract.function('addParty');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _addParty,
              parameters: partyModel.toList()),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      if (e.toString().contains("Party ID already exists")) {
        throw PartyAlreadyExistException();
      } else if (e.toString().contains('reverted')) {
        throw TransactionFailedException();
      } else {
        throw TransactionFailedException();
      }
    }
  }

  @override
  Future<String> addState(StateModel stateModel) async {
    try {
      init();
      _addState = _contract.function('addState');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _addState,
              parameters: stateModel.toList()),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      if (e.toString().contains("State ID already exists")) {
        throw StateAlreadyExistException();
      } else if (e.toString().contains('reverted')) {
        throw TransactionFailedException();
      } else {
        throw TransactionFailedException();
      }
    }
  }

  @override
  Future<String> addRep(RepresentativeModel repModel) async {
    try {
      init();
      _addRep = _contract.function('assignRepresentative');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _addRep,
              parameters: repModel.toList()),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      if (e.toString().contains("State ID already exists")) {
        throw RepAlreadyExistException();
      } else if (e.toString().contains('reverted')) {
        throw TransactionFailedException();
      } else {
        throw TransactionFailedException();
      }
    }
  }

  @override
  Future<String> deleteParty(int partyId) async {
    try {
      init();
      _deleteParty = _contract.function('delateParty');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteParty,
              parameters: [partyId]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException();
    }
  }

  @override
  Future<String> deleteRep(int partyId, int stateId) async {
    try {
      init();
      _deleteRep = _contract.function('delateRep');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteRep,
              parameters: [stateId, partyId]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException();
    }
  }

  @override
  Future<String> deleteState(int stateId) async {
    try {
      init();
      _deleteState = _contract.function('delateState');
      final transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _deleteState,
              parameters: [stateId]),
          chainId: 11155111);
      return transactionHash;
    } catch (e) {
      throw TransactionFailedException();
    }
  }

  @override
  Future<List<PartyModel>> getParties() async {
    try {
      init();
      _getParties = _contract.function('partiesList');

      final result = await _client.call(
        contract: _contract,
        function: _getParties,
        params: [],
      );

      final partyList = (result[0] as List)
          .map((party) => PartyModel(
              partyName: party[0],
              partySymbol: party[1],
              partyId: party[3],
              votes: party[3]))
          .toList();
      return partyList;
    } catch (e) {
      throw TransactionFailedException();
    }
  }

  @override
  Future<List<RepresentativeModel>> getRep() async {
    try {
      init();
      _getReps = _contract.function('repList');
      final result = await _client.call(
        contract: _contract,
        function: _getReps,
        params: [],
      );
      final repList = (result[0] as List)
          .map((rep) => RepresentativeModel(
              repName: rep[0],
              repPhoto: rep[1],
              party: PartyModel(
                  partyName: rep[2][0],
                  partySymbol: rep[2][1],
                  partyId: rep[2][2]),
              state: StateModel(stateName: rep[3][0], stateId: rep[3][1]),
              votes: rep[4]))
          .toList();
      return repList;
    } catch (e) {
      throw TransactionFailedException();
    }
  }

  @override
  Future<List<StateModel>> getState() async {
    try {
      init();
      _getStates = _contract.function('statesList');
      final result = await _client.call(
        contract: _contract,
        function: _getStates,
        params: [],
      );
      final stateList = (result[0] as List)
          .map((state) => StateModel(
                stateName: state[0],
                stateId: state[1],
              ))
          .toList();
      return stateList;
    } catch (e) {
      throw TransactionFailedException();
    }
  }
}
