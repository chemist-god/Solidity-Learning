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

    // Pick a winner (only owner)
    function pickWinner() public {
        require(msg.sender == owner, "Only owner can pick winner");
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % players.length;
        winner = players[index];
        payable(winner).transfer(address(this).balance);
        players = new address[](0); // Reset lottery
    }
}