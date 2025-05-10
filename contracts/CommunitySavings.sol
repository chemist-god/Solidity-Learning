// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

                            //A COMMUNITY SAVING POOL

contract CommunitySavings {
    mapping(address => uint) public balances;
    address public  owner;

    constructor() {
        owner =msg.sender;
    }
}