// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Election {
    event PartyAdded(uint indexed partyId, string partyName);
    event StateAdded(uint indexed stateId, string stateName);
    event RepresentativeAssigned(string  state, string  party, string repName);
    event VoteCast(uint indexed voterId, uint indexed stateId, uint indexed partyId);
    event VotingTimesSet(uint startTime, uint endTime);


    struct Party {
        string partyName;
        string symbol;
        uint256 partyId;
        uint256 voteCount;
    }

    struct State {
        string stateName;
        uint256 stateId;
    }
    struct Representative {
        string name;
        string photo;
        Party party;
        State state;
        uint256 votecount;
    }

    address electionAdmin;
    uint256 public votingStartTime;
    uint256 public votingEndTime;
    uint public totalVote;

    constructor() {
        electionAdmin = msg.sender;
    }

    mapping(uint256 => Party) public parties;
    mapping(uint256 => State) public states;
    mapping(uint256 => bool) public voters;
    mapping(uint256 => mapping(uint256 => Representative))
        public statePartyRepresentatives;

    uint256[] public partyIds;
    uint256[] public stateIds;
    uint256[] public repStateIds; // states those have atleast one rep
    mapping(uint256 => uint256[]) public partyIdsInState;

    modifier onlyAdmin() {
        require(msg.sender == electionAdmin, "Not authorized");
        _;
    }

    function transferOwnership(address newOwner) public  onlyAdmin {
      electionAdmin = newOwner;
    }

    function addParty(
        string memory _name,
        string memory _symbol,
        uint256 _partyId
    ) public onlyAdmin {
        require(
            bytes(parties[_partyId].partyName).length == 0,
            "Party ID already exists"
        );

        parties[_partyId] = Party(_name, _symbol, _partyId, 0);
        partyIds.push(_partyId);
        emit PartyAdded(_partyId, _name);
       
        
    }

    function addState(string memory _stateName, uint256 _stateId)
        public
        onlyAdmin
    {
        require(
            bytes(states[_stateId].stateName).length == 0,
            "State ID already exists"
        );
        states[_stateId] = State(_stateName, _stateId);
        stateIds.push(_stateId);
         emit StateAdded(_stateId, _stateName);
    }

    function assignRepresentative(
        string memory _repName,
        string memory _photo,
        uint256 _partyId,
        uint256 _stateId
    ) public onlyAdmin {
        require(
            bytes(states[_stateId].stateName).length != 0,
            "State does not exist"
        );
        require(
            bytes(parties[_partyId].partyName).length != 0,
            "Party does not exist"
        );

        statePartyRepresentatives[_stateId][_partyId] = Representative(
            _repName,
            _photo,
            parties[_partyId],
            states[_stateId],
            0
        );
        if (partyIdsInState[_stateId].length == 0) {
            // if state is new
            repStateIds.push(_stateId);
        }
        partyIdsInState[_stateId].push(_partyId);

        emit RepresentativeAssigned(parties[_partyId].partyName, states[_stateId].stateName, _repName);
    }

     function delateParty(uint partyId)  public onlyAdmin {
        delete parties[partyId];
     }
     function delateState(uint stateId)  public onlyAdmin {
        delete states[stateId];
     }
     function delateRep(uint stateId,uint partyId)  public onlyAdmin {
        delete statePartyRepresentatives[stateId][partyId];
     }

    function setTime(uint256 _startTime, uint256 _endTime) public onlyAdmin {
        require(_startTime > block.timestamp, "Start time must be in future");
        require(_endTime > _startTime, "End time must be after start time");
        votingStartTime = _startTime;
        votingEndTime = _endTime;
        emit VotingTimesSet(_startTime, _endTime);
    }

    function isVotingOpen() public view returns (bool) {
        require(
            votingStartTime != 0 && votingEndTime != 0,
            "Voting times are not set"
        );
        require(block.timestamp >= votingStartTime, "Voting hasn't started");
        require(block.timestamp <= votingEndTime, "Voting is over");
        return true;
    }

    function countdownToStart() public view returns (uint256) {
        require(
            votingStartTime != 0 && votingEndTime != 0,
            "Voting times are not set"
        );
        if (block.timestamp > votingStartTime) {
            return 0;
        } else {
            return votingStartTime - block.timestamp;
        }
    }

    function timeLeftForVoting() public view returns (uint256) {
        require(
            votingStartTime != 0 && votingEndTime != 0,
            "Voting times are not set"
        );
        if (block.timestamp > votingEndTime) {
            return 0;
        } else {
            return votingEndTime - block.timestamp;
        }
    }

    function vote(
        uint256 _voterId,
        uint256 _voterState,
        uint256 _votedPartyId
    ) public {
        require(!voters[_voterId], "You have already voted.");

        require(
            bytes(states[_voterState].stateName).length != 0,
            "State does not exist"
        );

        require(
            bytes(parties[_votedPartyId].partyName).length != 0,
            "Party does not exist"
        );

        require(
            bytes(statePartyRepresentatives[_voterState][_votedPartyId].name)
                .length != 0,
            "No representative for this party in this state"
        );

        statePartyRepresentatives[_voterState][_votedPartyId].votecount++;
        parties[_votedPartyId].voteCount++;
        voters[_voterId] = true;
       emit VoteCast(_voterId, _voterState, _votedPartyId);
       
    }
    
    function partiesList() public view returns (Party[] memory) {
        Party[] memory allParties = new Party[](partyIds.length);
        for (uint256 i = 0; i < partyIds.length; i++) {
            allParties[i] = (parties[partyIds[i]]);
        }
        return allParties;
    }

    function statesList() public view returns (State[] memory) {
        State[] memory allState = new State[](stateIds.length);
        for (uint256 i = 0; i < stateIds.length; i++) {
            allState[i] = (states[stateIds[i]]);
        }
        return allState;
    }

    function repList() public view returns (Representative[] memory) {
        uint256 totalRep = 0;
        for (uint256 i = 0; i < repStateIds.length; i++) {
            uint256 stateId_No = repStateIds[i];
            totalRep += partyIdsInState[stateId_No].length;
        }
        Representative[] memory reps = new Representative[](totalRep);
        uint256 index = 0;

        for (uint256 i = 0; i < repStateIds.length; i++) {
            uint256 stateId = repStateIds[i];
            uint256[] memory partyList = partyIdsInState[stateId];

            for (uint256 j = 0; j < partyList.length; j++) {
                uint256 partyId = partyList[j];
                reps[index] = statePartyRepresentatives[stateId][partyId];
                index++;
            }
        }
        return reps;
    }
}
