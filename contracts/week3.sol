

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

}