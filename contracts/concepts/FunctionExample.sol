// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FunctionExample {
    uint public num = 100;

    function viewFunction() public view returns (uint) {
        return num; // Reads blockchain data but doesn’t modify it
    }

    function pureFunction(uint x, uint y) public pure returns (uint) {
        return x + y; // Doesn’t read or modify blockchain data
    }
}
