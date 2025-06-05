// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HealthInsuranceDAO is ERC20, Ownable {
    using Counters for Counters.Counter;

    // Struct to define claims
    struct Claim {
        address beneficiary;
        uint256 amount;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 createdAt;
        uint256 endAt;
        bool executed;
        bool approved;
    }

    // Constants
    uint256 public constant MIN_PROPOSAL_DURATION = 3 days;
    uint256 public constant MEMBERSHIP_FEE = 0.1 ether;
    uint256 public constant VOTING_POWER_PER_TOKEN = 1;

    // State variables
    Counters.Counter private _claimIds;
    mapping(uint256 => Claim) public claims;
    mapping(address => bool) public members;
    mapping(uint256 => mapping(address => bool)) public votes;
    uint256 public poolBalance;
    uint256 public totalMembers;

    // Events
    event MemberJoined(address indexed member);
    event ClaimCreated(uint256 indexed claimId, address indexed beneficiary, uint256 amount, string description);
    event Voted(uint256 indexed claimId, address indexed voter, bool support);
    event ClaimExecuted(uint256 indexed claimId, bool approved);
    event FundsDeposited(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed beneficiary, uint256 amount);

    constructor() ERC20("HealthDAO Token", "HDAO") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Modifier to ensure only members can interact with certain functions
    modifier onlyMember() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    // Function for users to join and pay membership fee
    function join() external payable {
        require(!members[msg.sender], "Already a member");
        require(msg.value >= MEMBERSHIP_FEE, "Insufficient membership fee");
        
        members[msg.sender] = true;
        totalMembers++;
        poolBalance += msg.value;
        
        emit MemberJoined(msg.sender);
    }

    // Function to submit claims for medical expenses
    function submitClaim(uint256 amount, string memory description) external onlyMember {
        require(amount > 0, "Claim amount must be greater than zero");

        uint256 claimId = _claimIds.current();
        _claimIds.increment();

        claims[claimId] = Claim({
            beneficiary: msg.sender,
            amount: amount,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            createdAt: block.timestamp,
            endAt: block.timestamp + MIN_PROPOSAL_DURATION,
            executed: false,
            approved: false
        });

        emit ClaimCreated(claimId, msg.sender, amount, description);
    }

    // Function for members to vote on claims
    function vote(uint256 claimId, bool support) external onlyMember {
        require(block.timestamp < claims[claimId].endAt, "Voting period has ended");
        require(!votes[claimId][msg.sender], "Already voted");

        votes[claimId][msg.sender] = true;

        if (support) {
            claims[claimId].votesFor += balanceOf(msg.sender) * VOTING_POWER_PER_TOKEN;
        } else {
            claims[claimId].votesAgainst += balanceOf(msg.sender) * VOTING_POWER_PER_TOKEN;
        }

        emit Voted(claimId, msg.sender, support);
    }

    // Function to execute claims after the voting period
    function executeClaim(uint256 claimId) external onlyOwner {
        Claim storage claim = claims[claimId];

        require(block.timestamp >= claim.endAt, "Voting period is still ongoing");
        require(!claim.executed, "Claim already executed");

        if (claim.votesFor > claim.votesAgainst && poolBalance >= claim.amount) {
            claim.approved = true;
            poolBalance -= claim.amount;
            payable(claim.beneficiary).transfer(claim.amount);
            emit FundsWithdrawn(claim.beneficiary, claim.amount);
        }

        claim.executed = true;
        emit ClaimExecuted(claimId, claim.approved);
    }

    // Function to deposit additional funds into the insurance pool
    function depositFunds() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        poolBalance += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }
}
