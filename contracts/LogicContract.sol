// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract LogicContract {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}

contract ProxyContract {
    address public logicContract;

    constructor(address _logicContract) {
        logicContract = _logicContract;
    }

    function upgrade(address _newLogicContract) public {
        logicContract = _newLogicContract;
    }

    fallback() external payable {
        address _impl = logicContract;
        require(_impl != address(0), "Logic contract not set");
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            returndatacopy(ptr, 0, returndatasize())
            switch result
            case 0 { revert(ptr, returndatasize()) }
            default { return(ptr, returndatasize()) }
        }
    }
}
