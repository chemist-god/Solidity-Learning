// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract StudentRecord {
    struct Student {
        string name;
        uint age;
    }

    mapping(uint => Student) public students;

    function addStudent(uint _id, string memory _name, uint _age) public {
    students[_id] = Student(_name, _age);
}

    function getStudent(uint _id ) public view returns (string memory name, uint age) {
        return students[_id].name;
        
}

}