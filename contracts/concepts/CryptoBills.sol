// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract CryptoBillPayments {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public verifiedServiceProviders;
    mapping(address => mapping(string => uint256)) public userBills;

    event PaymentMade(address indexed user, address indexed provider, uint256 amount, string service);
    event ProviderVerified(address indexed provider);
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    
}
