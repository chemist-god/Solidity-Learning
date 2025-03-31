

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Tutorials {

struct Student {
    string name;
    uint age;
    bool enrolled;
}

Student public student;
function setStudent(string memory _name, uint _age, bool _enrolled) public {
student = Student(_name, _age, _enrolled);
}

//struct inside an array
Student[] public students;
function addStudent(string memory _name, uint _age, bool _enrolled) public {
students.push(Student(_name, _age, _enrolled));
}

//mapping -> is a key value store
    // storing account balance
    mapping(address => uint) public balances;
function deposit(uint _amount) public {
balances[msg.sender] += _amount;
}

//function to check balance
function checkBalance() public view returns (uint) {
return balances[msg.sender];
}

//mappings in mapping -> called  a Nested mapping
mapping(address => mapping(string => uint)) public tokenBalances;

function setTokenBalance(string memory _token, uint _amount) public {
    tokenBalances[msg.sender][_token] = _amount;
}

function getTokenBalance(string memory _token) public view returns (uint) {
    return tokenBalances[msg.sender][_token];
}

}