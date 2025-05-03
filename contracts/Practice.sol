// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyPractice {


    //starting with Array
        //have to declare an array of eg names
    string [] public employees = ["nathan", "mariam", "chris"];

    //add new worker
    function addEmployee(string memory _name) public {
        employees.push(_name);
    }

    //get employee
    function getEmployee(uint _index) public view returns (string memory){
        return employees[_index];
    }
}