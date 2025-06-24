// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MedicalToolTracker {
    enum ToolStatus { Registered, InUse, Sterilized, Disposed }

    struct Tool {
        string toolType;
        string batchId;
        address hospital;
        uint256 registeredAt;
        ToolStatus status;
        address lastHandledBy;
    }

    address public admin;
    uint256 public toolCount;

    mapping(uint256 => Tool) public tools;
    mapping(address => bool) public approvedPersonnel;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyApproved() {
        require(approvedPersonnel[msg.sender], "Unauthorized access");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function approvePersonnel(address _user) external onlyAdmin {
        approvedPersonnel[_user] = true;
    }

    function registerTool(string memory _toolType, string memory _batchId) external onlyApproved returns (uint256) {
        tools[toolCount] = Tool({
            toolType: _toolType,
            batchId: _batchId,
            hospital: msg.sender,
            registeredAt: block.timestamp,
            status: ToolStatus.Registered,
            lastHandledBy: address(0)
        });
        return toolCount++;
    }

    function markInUse(uint256 _toolId) external onlyApproved {
        Tool storage tool = tools[_toolId];
        require(tool.status == ToolStatus.Registered, "Tool already used");
        tool.status = ToolStatus.InUse;
        tool.lastHandledBy = msg.sender;
    }

    function markSterilized(uint256 _toolId) external onlyApproved {
        Tool storage tool = tools[_toolId];
        require(tool.status == ToolStatus.InUse, "Tool must be in use");
        tool.status = ToolStatus.Sterilized;
        tool.lastHandledBy = msg.sender;
    }

    function markDisposed(uint256 _toolId) external onlyApproved {
        Tool storage tool = tools[_toolId];
        require(
            tool.status == ToolStatus.InUse || tool.status == ToolStatus.Sterilized,
            "Tool must be used or sterilized first"
        );
        tool.status = ToolStatus.Disposed;
        tool.lastHandledBy = msg.sender;
    }

    function getToolDetails(uint256 _toolId) external view returns (Tool memory) {
        return tools[_toolId];
    }
}
