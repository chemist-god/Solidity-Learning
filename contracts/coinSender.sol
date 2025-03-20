
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

    error InsufficientBalance(uint requested,uint available);
    // this error will help get the details of why an operation failed 
    // it is returned to the caller function

    
  // this allows anyone to send a coin to an account
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], InsufficientBalance(amount, balances[msg.sender]));
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
    
}