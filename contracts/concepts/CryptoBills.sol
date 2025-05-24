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

    function verifyServiceProvider(address provider) public onlyOwner {
        verifiedServiceProviders[provider] = true;
        emit ProviderVerified(provider);
    }

    function depositFunds() public payable {
        require(msg.value > 0, "Must deposit positive amount");
        balances[msg.sender] += msg.value;
    }

    function payBill(address provider, uint256 amount, string memory service) public {
        require(verifiedServiceProviders[provider], "Provider not verified");
        require(balances[msg.sender] >= amount, "Insufficient funds");

        balances[msg.sender] -= amount;
        balances[provider] += amount;

        userBills[msg.sender][service] += amount;
        emit PaymentMade(msg.sender, provider, amount, service);
    }

    
}
