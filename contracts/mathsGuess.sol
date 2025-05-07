// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleGuessingGame {
    uint256 private secretNumber;

    constructor(uint256 _secretNumber) {
        secretNumber = _secretNumber;
    }

    function guess(uint256 _guess) public view returns (bool) {
        return _guess == secretNumber;
    }
}
