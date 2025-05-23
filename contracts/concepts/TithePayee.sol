// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TithePayment {
    address public church;
    mapping(address => uint256) public tithes;
    
    event TithePaid(address indexed payer, uint256 amount);
    
    constructor(address _church) {
        church = _church;
    }

    modifier onlyFirstSunday() {
        require(
            block.timestamp % 2592000 < 86400, // Approximate check for first Sunday (2592000 seconds in a month)
            "Payments only allowed on the first Sunday"
        );
        _;
    }

    function payTithe() external payable onlyFirstSunday {
        require(msg.value > 0, "Tithe amount must be greater than zero");
        
        tithes[msg.sender] += msg.value;
        payable(church).transfer(msg.value);
        
        emit TithePaid(msg.sender, msg.value);
    }

    function getTitheAmount(address payer) external view returns (uint256) {
        return tithes[payer];
    }
}
