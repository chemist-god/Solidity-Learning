// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SmartAccount {
    address public owner;
    uint256 public nonce;

    constructor(address _owner) {
        owner = _owner;
    }

    // Only owner can execute
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Simple nonce getter for replay protection
    function getNonce() external view returns (uint256) {
        return nonce;
    }

 // Execute a call on behalf of the smart account
    function execute(address target, bytes calldata data, uint256 gasLimit) external onlyOwner returns (bytes memory) {
        nonce++;
        (bool success, bytes memory result) = target.call{gas: gasLimit}(data);
        require(success, "Call failed");
        return result;
    }
   
}
