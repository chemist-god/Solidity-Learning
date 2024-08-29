//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Map {
    mapping(address => uint256)  public amount;

    function set(uint256 _amount) public {
        amount[msg.sender] = _amount;
    }

    function get() public view returns (uint256) {
        return amount[msg.sender];
    }

    function update(uint256 _amount) public  {
        amount[msg.sender]= _amount;
    }

    function remove () public {
        delete amount[msg.sender];
    }
}