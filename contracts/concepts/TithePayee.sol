// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TithePayment {
    address public church;
    mapping(address => uint256) public tithes;
    
    event TithePaid(address indexed payer, uint256 amount);
    
    constructor(address _church) {
        church = _church;
    }

   
}
