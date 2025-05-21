// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/**
 * @title SmartWallet
 * @dev A smart wallet that allows secure transactions, signature validation, and optional gas payments in ERC-20 tokens.
 */
contract SmartWallet {
    address public owner; // Stores the owner's address
    uint256 public nonce; // Tracks transactions to prevent replay attacks

    event Executed(address indexed to, uint256 value, bytes data); // Logs executed transactions
    event GasPaid(address indexed token, uint256 amount); // Logs gas payments with ERC-20 tokens

    /**
     * @dev Sets the owner of the wallet when deployed.
     * @param _owner The address of the wallet owner.
     */
    constructor(address _owner) {
        owner = _owner;
    }

    /**
     * @dev Executes a transaction from the wallet.
     * @param to The recipient address.
     * @param value The amount of ETH to send.
     * @param data The calldata for contract interaction.
     */
    function execute(address to, uint256 value, bytes calldata data) external {
        require(msg.sender == owner, "Not authorized"); // Ensures only the owner can execute transactions
        nonce++; // Increments nonce to prevent replay attacks
        (bool success, ) = to.call{value: value}(data); // Calls the recipient contract or sends ETH
        require(success, "Execution failed"); // Ensures transaction success
        emit Executed(to, value, data); // Logs the transaction
    }

   /**
 * @dev Simulates user operation validation.
 * @param signature The user's signature (simulated check).
 * @return Returns true to simulate successful validation.
 */
function validateUserOp(bytes calldata signature) external pure returns (bool) {
    return true; // Simulated validation
}


    /**
     * @dev Allows users to pay gas fees in ERC-20 tokens.
     * @param token The ERC-20 token contract address.
     * @param amount The amount of tokens for payment.
     */
    function payGasWithERC20(address token, uint256 amount) external {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "ERC-20 payment failed");
        emit GasPaid(token, amount); // Logs gas payments
    }

    /**
     * @dev Executes multiple transactions in a single batch.
     * @param to Array of recipient addresses.
     * @param value Array of ETH amounts.
     * @param data Array of calldata.
     */
    function batchExecute(address[] calldata to, uint256[] calldata value, bytes[] calldata data) external {
        require(msg.sender == owner, "Not authorized"); // Only owner can batch execute
        require(to.length == value.length && to.length == data.length, "Array length mismatch");

        for (uint256 i = 0; i < to.length; i++) {
            nonce++; // Prevent replay attacks
            (bool success, ) = to[i].call{value: value[i]}(data[i]);
            require(success, "Batch execution failed");
            emit Executed(to[i], value[i], data[i]);
        }
    }
}
