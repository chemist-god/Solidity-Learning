// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LearnWise {
    uint public nextCourseId;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

}
