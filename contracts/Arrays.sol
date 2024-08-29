//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;


// contract Array {

//     uint256[] public myArray;

//     function setMyArray(uint256[] calldata newArray) public {
//         myArray = newArray;
//     }

//     function addToArray(uint256 newItem) public {
//         myArray.push(newItem);
//     }

//     function removeFromArray() public {
//         myArray.pop();
//     }

//     function getLength() public view returns (uint256) {
//         return myArray.length;
//     }

//     function getEntireArray() public view returns (uint256[] memory) {
//         return myArray;
//     }
// }

contract Array {
    struct Item {
        string name;
        uint256 id;
        bool verify;
    }

    Item[] public students;
    function add (string memory _name, uint256 _id) public {
        students.push(Item(_name, _id, true));
    }

    function find (uint256 id) internal view returns (uint256) {
        for (uint256 i =0; i < students.length; i++) {
            if (students[i].id ==id) {
                return i;
            }
        }
    revert('does not exist');
    } 

    function update (uint256 id, string memory _name) public {
        uint256 i =find(id);
        students[i].name = _name;
    }

    function remove () public {
        students.pop();
    }
}