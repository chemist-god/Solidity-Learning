// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

                            //A COMMUNITY SAVING POOL

contract CommunitySavings {
    mapping(address => uint) public balances;
    address public  owner;

    constructor() {
        owner =msg.sender;
    }

    //function to deposit
    function deposit() public payable  {
        require(msg.value > 0, "Deposit must be greater than Zero");
        balances[msg.sender] += msg.value;
    }

    //function to withdraw
    function withdraw(uint amount) public  {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    //function to check balance
    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }
}