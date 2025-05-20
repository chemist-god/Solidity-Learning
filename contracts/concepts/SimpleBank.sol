// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleBank {
    //state variable
    mapping(address => uint) public balances; // State variable to store user balances

    function deposit() public payable {
        balances[msg.sender] += msg.value; // Adds deposited amount to sender's balance
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds"); // Condition check
        balances[msg.sender] -= amount; // Deducts amount
        payable(msg.sender).transfer(amount); // Sends Ether to user
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender]; // View function to check balance
    }
}
