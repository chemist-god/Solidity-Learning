// SPDX-License-Identifier: UNLICENSED
/// Charity
pragma solidity ^0.8.0;

contract Charity {
    struct Donation {
        address donor;
        uint256 amount;
        bool isVerified;
    }

    mapping(address => Donation) public donations;
    address public charity;
    uint256 public totalDonations;

    event DonationMade(address indexed donor, uint256 amount);
    event DonationVerified(address indexed donor);

    constructor() {
        charity = msg.sender;
        totalDonations = 0;
    }

    modifier onlyCharity() {
        require(msg.sender == charity, "Only the charity can call this function.");
        _;
    }

    function makeDonation() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");

        Donation memory donation = Donation(msg.sender, msg.value, false);

        donations[msg.sender] = donation;
        totalDonations += msg.value;

        emit DonationMade(msg.sender, msg.value);
    }

    function verifyDonation(address _donor) public onlyCharity {
        Donation storage donation = donations[_donor];

        require(donation.donor != address(0), "Donation not found.");
        require(!donation.isVerified, "Donation has already been verified.");

        donation.isVerified = true;

        emit DonationVerified(_donor);
    }

    function getDonation(address _donor) public view returns (uint256, bool) {
        Donation memory donation = donations[_donor];
        return (donation.amount, donation.isVerified);
    }
}