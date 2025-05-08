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

    // Borrow funds from the pool
    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be greater than zero");
        require(amount <= deposits[msg.sender] / 2, "Cannot borrow more than half of deposited amount");

        loans[msg.sender] += amount;
        payable(msg.sender).transfer(amount);
    }

    // Repay loan with interest
    function repay() external payable {
        require(loans[msg.sender] > 0, "No active loan to repay");
        uint256 interest = (loans[msg.sender] * interestRate) / 100;
        require(msg.value >= loans[msg.sender] + interest, "Insufficient amount to repay loan with interest");

        loans[msg.sender] = 0;
        deposits[msg.sender] += msg.value - (loans[msg.sender] + interest);
    }

    // Check balance
    function getBalance() external view returns (uint256) {
        return deposits[msg.sender];
    }
}
