// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Urna.sol"; 

contract Eleicao is Urna {

    constructor() {
        currentElectionState = ElectionState.NotStarted;
    }
}