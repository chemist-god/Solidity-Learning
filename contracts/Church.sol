// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Church {
    address public admin;

    struct Member {
        bool isRegistered;
        uint256 totalDonations;
    }

    mapping(address => Member) public members;
    uint256 public totalDonations;

    event MemberRegistered(address indexed member);
    event DonationReceived(address indexed member, uint256 amount);
    event Withdrawn(address indexed admin, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender].isRegistered, "Only registered members can call this function");
        _;
    }
 constructor() {
        admin = msg.sender;
    }

    // Register a new member
    function registerMember(address _member) external onlyAdmin {
        require(!members[_member].isRegistered, "Member already registered");
        members[_member].isRegistered = true;
        members[_member].totalDonations = 0;

        emit MemberRegistered(_member);
    }

    // Members can donate ether
    function donate() external payable onlyMember {
        require(msg.value > 0, "Donation must be greater than zero");

        members[msg.sender].totalDonations += msg.value;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }
   
   

    // Admin can withdraw collected funds
    function withdraw(uint256 _amount) external onlyAdmin {
        require(_amount <= address(this).balance, "Insufficient funds in contract");

        payable(admin).transfer(_amount);

        emit Withdrawn(admin, _amount);
    }

    // Get donation amount of a member
    function getMemberDonations(address _member) external view returns (uint256) {
        return members[_member].totalDonations;
    }

    // Contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
