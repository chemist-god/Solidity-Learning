// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Choice { None, Rock, Paper, Scissors }
    // enum GameStatus { Waiting, Committed, Revealed, Completed }
    
    // struct Game {
    //     address player1;
    //     address player2;
    //     bytes32 player1Commit;
    //     Choice player1Choice;
    //     Choice player2Choice;
    //     uint256 betAmount;
    //     GameStatus status;
    //     address winner;
    // }
    
     struct Player {
        address playerAddress;
        Choice choice;
        bool hasPlayed;
    }
    Player public player1;
    Player public player2;

    address public owner;
    bool public gameEnded;
    address public winner;
    
}