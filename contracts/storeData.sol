
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract simpleDataStore {
    uint storeValue;

// this is a simple storage function 
    function set(uint x) public  {
        storeValue = x;
    }

// this retrieve the storedValue 
    function get() public view returns (uint) {
        return storeValue;
    }
    
}