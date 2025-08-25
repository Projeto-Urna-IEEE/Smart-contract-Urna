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

}