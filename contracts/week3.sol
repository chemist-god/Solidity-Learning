

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

}