// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleLendingPool {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;
    uint256 public interestRate = 5; // 5% interest rate

    // Deposit funds into the pool
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        deposits[msg.sender] += msg.value;
    }

    
}
