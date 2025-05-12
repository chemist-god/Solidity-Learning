// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract HashTester {
    function getHash(string memory _word) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_word));
    }
}
