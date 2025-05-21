// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract VariableExample {
    uint public stateVar = 10; // Stored permanently on blockchain

    function localExample() public pure returns (uint) {
        uint localVar = 5; // Temporary variable
        return localVar + 10;
    }

    function globalExample() public view returns (address) {
        return msg.sender; // Returns sender's address (global variable)
    }
}
