// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Urna.sol"; 

contract Eleicao is Urna {

    event Voted(address indexed voter, uint indexed candidateId);

    constructor() {
        currentElectionState = ElectionState.NotStarted;
    }

    function vote(uint _candidateId) public {
        //require(currentElectionState == ElectionState.Voting, "A votacao nao esta ativa");
        require(voters[msg.sender].isRegistered, "Eleitor nao registrado");
        require(!voters[msg.sender].hasVoted, "Eleitor ja votou");
        require(candidates[_candidateId].id != 0, "Candidato invalido");

        voters[msg.sender].hasVoted = true;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    function getTotalCandidates() public view returns (uint) {
        require(currentElectionState==ElectionState.Ended, "Eleicao nao acabou");
        
        return candidateIds.length;
    }
    function getVotesCount(uint _candidateId) public view returns (uint) {
        require(currentElectionState==ElectionState.Ended, "Eleicao nao acabou");
        require(candidates[_candidateId].id != 0, "Candidato invalido");
        
        return candidates[_candidateId].voteCount;
    }

}