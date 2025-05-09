// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract RandomNumber {
    
    function getRandomNumber(uint seed) public view  returns (uint) {
        return uint(keccak256(abi.encodePacked(seed, block.timestamp, blockhash(block.number - 1))) );
    }
}