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


    //moving on with enum
       // using traffic light as ec=xample 
    enum TrafficLight {Red, Yello, Green}

    //define current state of light
        TrafficLight public currentLight = TrafficLight.Red;

    //change the light
    function changeLight() public {
        if (currentLight == TrafficLight.Red) {
            currentLight = TrafficLight.Green;
        } else if (currentLight == TrafficLight.Green){
            currentLight = TrafficLight.Yello;
        }else{
            currentLight = TrafficLight.Red;
        }
    }


    //moving on with mapping
     //using phonebook as example

     //mapping of name to phone book
     mapping(string => string) public phoneBook;

     //add a new entry
     function addNumber(string memory _name, string memory _number) public {
        phoneBook[_name] = _number;
     }

     //get a friends niumber
     function getNumber(string memory _name) public view returns (string memory) {
        return phoneBook[_name];
     }


    //moving on with structs


//         //loops
//         function airdropTokens(address[] memory recipients, uint amount) public {
//     for(uint i = 0; i < recipients.length; i++) {
//         balances[recipients[i]] += amount;
//     }
// }
}