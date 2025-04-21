// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address[] public players;
    address public winner;

    // Enter the lottery by sending ETH
    function enter() public payable {
        require(msg.value == 0.1 ether, "Must send 0.1 ETH");
        players.push(msg.sender);
    }

    
}