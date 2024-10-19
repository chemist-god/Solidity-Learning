// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SubscriptionManager {
    address public owner;
    mapping(address => bool) public isSubscribed;
    mapping(address => address) public walletAddresses;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function subscribe() public {
        isSubscribed[msg.sender] = true;
    }

    function unsubscribe() public {
        isSubscribed[msg.sender] = false;
    }

    function isUserSubscribed(address user) public view returns (bool) {
        return isSubscribed[user];
    }

    function connectWallet(address wallet) public {
        walletAddresses[msg.sender] = wallet;
    }

    function getWalletAddress(address user) public view returns (address) {
        return walletAddresses[user];
    }
}