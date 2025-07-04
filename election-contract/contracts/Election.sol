// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Election {
    struct StateVote {
        uint256 stateId;
        uint256 votes;
    }

    struct Party {
        string partyName;
        string symbol;
        uint256 partyId;
        mapping(uint256 => uint256) stateVotes; 
    }

    struct PartyView {
        string partyName;
        string symbol;
        uint256 partyId;
        StateVote[] stateVotes;
    }

    struct State {
        string stateName;
        uint256 stateId;
    }

    address public electionAdmin;
    uint256 public votingStartTime;
    uint256 public votingEndTime;
    bool public votingPaused;

    uint256[] public partyIds;
    uint256[] public stateIds;

    mapping(uint256 => Party) private parties;
    mapping(uint256 => State) public states;
    mapping(string => bool) public voters;

    event VotingTimesSet(uint256 startTime, uint256 endTime);
    event VoteCast(string voterId, uint256 stateId, uint256 partyId);
    event PartyAdded(uint256 partyId, string partyName);
    event StateAdded(uint256 stateId, string stateName);

    modifier onlyAdmin() {
        require(msg.sender == electionAdmin, "Not authorized");
        _;
    }

    modifier votingActive() {
        require(!votingPaused, "Voting paused");
        require(isVotingActive(), "Voting not active");
        _;
    }

    constructor() {
        electionAdmin = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyAdmin {
        electionAdmin = newOwner;
    }

    function addParty(string memory _name, string memory _symbol, uint256 _partyId) public onlyAdmin {
        require(bytes(parties[_partyId].partyName).length == 0, "Party ID exists");
        Party storage newParty = parties[_partyId];
        newParty.partyName = _name;
        newParty.symbol = _symbol;
        newParty.partyId = _partyId;
        partyIds.push(_partyId);
        emit PartyAdded(_partyId, _name);
    }

    function addState(string memory _stateName, uint256 _stateId) public onlyAdmin {
        require(bytes(states[_stateId].stateName).length == 0, "State ID exists");
        states[_stateId] = State(_stateName, _stateId);
        stateIds.push(_stateId);
        emit StateAdded(_stateId, _stateName);
    }

    function deleteParty(uint256 _partyId) public onlyAdmin {
        require(bytes(parties[_partyId].partyName).length != 0, "Party does not exist");
        _removeFromArray(partyIds, _partyId);
        delete parties[_partyId];
    }

    function deleteState(uint256 _stateId) public onlyAdmin {
        require(bytes(states[_stateId].stateName).length != 0, "State does not exist");
        _removeFromArray(stateIds, _stateId);
        for (uint256 i = 0; i < partyIds.length; i++) {
            delete parties[partyIds[i]].stateVotes[_stateId];
        }
        delete states[_stateId];
    }

    function _removeFromArray(uint256[] storage array, uint256 value) internal {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                array[i] = array[array.length - 1];
                array.pop();
                break;
            }
        }
    }

    function vote(string memory _hashedFaydaId, uint256 _voterState, uint256 _votedPartyId) public votingActive {
        require(!voters[_hashedFaydaId], "You have already voted");
        require(bytes(parties[_votedPartyId].partyName).length != 0, "Party does not exist");
        require(bytes(states[_voterState].stateName).length != 0, "State does not exist");

        Party storage party = parties[_votedPartyId];
        party.stateVotes[_voterState]++;
        voters[_hashedFaydaId] = true;

        emit VoteCast(_hashedFaydaId, _voterState, _votedPartyId);
    }

    function hasUserVoted(string memory _hashedFaydaId) public view returns (bool) {
        return voters[_hashedFaydaId];
    }

    function isVotingActive() public view returns (bool) {
        return block.timestamp >= votingStartTime && block.timestamp <= votingEndTime;
    }

    function setVotingTimes(uint256 _startTime, uint256 _endTime) public onlyAdmin {
        require(_startTime > block.timestamp, "Start time must be in future");
        require(_endTime > _startTime, "End time must be after start time");

        votingStartTime = _startTime;
        votingEndTime = _endTime;

        emit VotingTimesSet(_startTime, _endTime);
    }

    function pauseVoting() public onlyAdmin {
        require(!votingPaused, "Already paused");
        require(isVotingActive(), "No active voting to pause");
        votingPaused = true;
    }

    function resumeVoting() public onlyAdmin {
        require(votingPaused, "Not paused");
        votingPaused = false;
    }

    function _getAllStates() internal view returns (State[] memory) {
        State[] memory result = new State[](stateIds.length);
        for (uint256 i = 0; i < stateIds.length; i++) {
            result[i] = states[stateIds[i]];
        }
        return result;
    }

    function getAllStates() public view returns (State[] memory) {
        return _getAllStates();
    }

    function _getAllParties() internal view returns (PartyView[] memory) {
        PartyView[] memory result = new PartyView[](partyIds.length);
        for (uint256 i = 0; i < partyIds.length; i++) {
            uint256 partyId = partyIds[i];
            Party storage party = parties[partyId];

            StateVote[] memory stateVotesArray = new StateVote[](stateIds.length);
            for (uint256 j = 0; j < stateIds.length; j++) {
                stateVotesArray[j] = StateVote({
                    stateId: stateIds[j],
                    votes: party.stateVotes[stateIds[j]]
                });
            }

            result[i] = PartyView({
                partyName: party.partyName,
                symbol: party.symbol,
                partyId: party.partyId,
                stateVotes: stateVotesArray
            });
        }
        return result;
    }

    function getAllParties() public view returns (PartyView[] memory) {
        return _getAllParties();
    }

    function timeData() public view returns (bool, uint256, uint256) {
        return (isVotingActive(), votingStartTime, votingEndTime);
    }

    function getAllData(string memory _hashedFaydaId)
        public
        view
        returns (
            State[] memory,
            PartyView[] memory,
            bool,
            bool,
            bool,
            uint256,
            uint256
        )
    {
        return (
            _getAllStates(),
            _getAllParties(),
             votingPaused,
            isVotingActive(),
            hasUserVoted(_hashedFaydaId),
            votingStartTime,
            votingEndTime
        );
    }
}
