// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

abstract contract Urna is Ownable {
    
    enum ElectionState { NotStarted, Registering, Voting, Ended }
    ElectionState public currentElectionState;

    struct Candidate {
        uint id;
	    string name;
	    uint voteCount;
    }

    struct Voter {
        address walletAddress;
	    bool isRegistered;
	    bool hasVoted;  
    }

    Counters.Counter private _nextCandidateId;
    mapping(uint => Candidate) public candidates;
    uint[] public candidateIds;

    mapping(address => Voter) public voters;

    uint public votingStartTime;
    uint public votingEndTime;

    event VoterRegistered(address indexed _voterAddress);
    event CandidateAdded(uint indexed _candidateId, string _name);
    event VotingPeriodSet(uint _startTime, uint _endTime);

    // colocar parte do admin para ser o controlador da eleição

    function registerVoter(address _voterAddress) public {
        require(_voterAddress != address(0), "Invalid voter address");
	require(!voters[_voterAddress].isRegistered, "Voter already registered");

	voters[_voterAddress].walletAddress = _voterAddress;
	voters[_voterAddress].isRegistered = true;
	voters[_voterAddress].hasVoted = false;

	emit VoterRegistered(_voterAddress);
    }

    function addCandidate(string memory _name) public {
        require(bytes(_name).length > 0, "Candidate's name cannot be empty");

        _nextCandidateId.increment();
	    uint newId = _nextCandidateId.current();
	    candidates[newId] = Candidate(newId, _name, 0);
	    candidateIds.push(newId);

	    emit CandidateAdded(newId, _name);
    }

    function setVotingPeriod(uint _startTime, uint _endTime) public {
        require(_startTime > block.timestamp, "Initial time must not be a future date");
	    require(_endTime > _startTime, "End time must not be less than the initial time");

	    votingStartTime = _startTime;
	    votingEndTime = _endTime;

	    emit VotingPeriodSet(_startTime, _endTime);
    }
}
