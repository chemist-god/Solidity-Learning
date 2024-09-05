

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EventExample {

    //adding an event called "NewRegistered" with 2 arguments
    event NewUserRegistered(address indexed user, string username );


struct User {
    string username;
    uint256 age;
}

// a map between user 
mapping (address => User) public users;

//function for register User
function registerUser(string memory _username, uint256 _age) public  {
    User storage newUser = users[msg.sender];
    newUser.username = _username;
    newUser.age = _age;

    //emit the event with msg.sender and username as the inputs
    emit NewUserRegistered(msg.sender, _username);
    }
}