// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract FootballAge {
    
 
    struct Player {
        string name;
        uint birthYear;
    }

    mapping(address => Player) public players;

    function setPlayer(string memory _name, uint _birthYear) public {
        require(_birthYear > 1900 && _birthYear <= block.timestamp / 1 years, "Invalid birth year");
        players[msg.sender] = Player(_name, _birthYear);
    }

    function getPlayerAge(address _playerAddress) public view returns (uint) {
        require(players[_playerAddress].birthYear != 0, "Player not found");
        return (block.timestamp / 1 years) - players[_playerAddress].birthYear;
    }
}


