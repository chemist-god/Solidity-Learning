
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract coinSender {
    
    address public minter;
    mapping (address => uint) public  balances;

    event Sent(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

// this send an amount of newly created coins to an account
// and can only be called by the contructor creator
    function mint(address reciever, uint amount) public  {
        require(msg.sender == minter);
        balances[reciever] += amount;
    }
    
    
}