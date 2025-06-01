// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract CrossBorderStablecoin {
    string public name = "RemitStable";
    string public symbol = "RST";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    address public owner;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    
}
