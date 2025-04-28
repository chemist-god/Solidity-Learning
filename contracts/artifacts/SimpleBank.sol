// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;



contract SimpleBank {
    address public owner;
    uint public totalBalance;

    event Deposited(address indexed sender, uint amount);
    event Withdrawn(address indexed receiver, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function deposit() public payable {
        totalBalance += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public onlyOwner {
        require(totalBalance >= _amount, "Insufficient balance");
        totalBalance -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getBalance() public view returns (uint) {
        return totalBalance;
    }

    function calculateBonus(uint amount) public pure returns (uint) {
        return amount * 10 / 100;
    }
}