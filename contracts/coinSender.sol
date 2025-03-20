// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract CoinSender {
    
    address public minter;
    mapping (address => uint) public balances;

    event Sent(address indexed from, address indexed to, uint amount);
    event Minted(address indexed receiver, uint amount);

    constructor() {
        minter = msg.sender; // The address that deploys the contract is the minter
    }

    // This function mints an amount of newly created coins to an account
    // and can only be called by the contract creator
    function mint(address receiver, uint amount) external {
        require(msg.sender == minter, "Only the minter can mint coins");
        balances[receiver] += amount;
        emit Minted(receiver, amount); // Emit an event for minting
    }

    error InsufficientBalance(uint requested, uint available);
    
    // This allows anyone to send coins to an account
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}