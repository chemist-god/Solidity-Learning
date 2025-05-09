// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract HashContract {
    bytes32 private messageHash;

    //example use of Keccak256

    function hash(string memory _message) public  {
        messageHash = keccak256(bytes(_message));
    }
}