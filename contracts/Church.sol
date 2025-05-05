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

   
}
