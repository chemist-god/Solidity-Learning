// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// import
// import "filename"
// import * as symolname from "filename2";
// import {symbol as alies, symbol2} from "filename3;

//your first contract 
contract SimpleContract {
    //state variable 
    uint storeData;

    //modifier is a conditional
    modifier onlyData() {
        require(
            storeData >= 0);
            _;
    }

    //function 
    function set(uint x) public  {
        storeData = x; 
    }

    //event 
    event Sent(address from, address to, uint storeData);
}