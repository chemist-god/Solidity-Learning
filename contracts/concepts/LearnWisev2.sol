// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LearnWiseExtended is ERC721URIStorage, Ownable {
    uint public nextCourseId;
    uint public nextBadgeId;
    address public platformWallet;

    constructor() ERC721("LearnBadge", "LBDG") {
        platformWallet = msg.sender;
    }

    struct User {
        address wallet;
        string name;
        bool isTutor;
        uint[] enrolledCourses;
        uint[] completedCourses;
        uint rewardPoints;
        address inviter;
    }

    struct Course {
        uint id;
        address tutor;
        string title;
        string description;
        uint totalCompletions;
        bool isActive;
        uint stakingAmount;
    }

    struct QuizAttempt {
        uint score;
        bool passed;
        bool retaken;
    }

    mapping(address => User) public users;
    mapping(uint => Course) public courses;
    mapping(address => mapping(uint => bool[])) public lessonProgress;
    mapping(uint => mapping(address => QuizAttempt)) public quizAttempts;

    // Tutor staking
    mapping(address => uint) public tutorStakes;

    // Referral tracking
    mapping(address => uint) public referralRewards;

    // NFT Badge tracking
    mapping(address => uint[]) public badgesMinted;

    // ------------------- User Management -------------------

    function registerUser(string memory _name, bool _isTutor, address _inviter) external {
        require(users[msg.sender].wallet == address(0), "User already exists");
        users[msg.sender] = User(msg.sender, _name, _isTutor, new uint[](0), new uint[](0), 0, _inviter);
        if (_inviter != address(0)) {
            referralRewards[_inviter] += 25; // reward points for referrals
        }
    }

    // ------------------- Tutor Staking & Course Creation -------------------

    function stakeToCreateCourse(uint _amount) external payable {
        require(users[msg.sender].isTutor, "Not a tutor");
        require(msg.value == _amount, "Incorrect stake");
        tutorStakes[msg.sender] += _amount;
    }

    function createCourse(string memory _title, string memory _description) external {
        require(users[msg.sender].isTutor, "Not a tutor");
        require(tutorStakes[msg.sender] >= 0.05 ether, "Minimum stake required");
        courses[nextCourseId] = Course(nextCourseId, msg.sender, _title, _description, 0, true, tutorStakes[msg.sender]);
        nextCourseId++;
    }

    // ------------------- Enrollment & Progress -------------------

    function enrollCourse(uint _courseId) external {
        require(courses[_courseId].isActive, "Inactive");
        users[msg.sender].enrolledCourses.push(_courseId);
    }

    function completeLesson(uint _courseId, uint _lessonIndex) external {
        lessonProgress[msg.sender][_courseId][_lessonIndex] = true;
    }

    function completeCourse(uint _courseId) external {
        users[msg.sender].completedCourses.push(_courseId);
        users[msg.sender].rewardPoints += 100;

        address tutor = courses[_courseId].tutor;
        courses[_courseId].totalCompletions++;
        users[tutor].rewardPoints += 50;

        _mintBadge(msg.sender, _courseId);
    }

    // ------------------- Quiz Logic -------------------

    function submitQuiz(uint _courseId, uint _score, bool _passed) external {
        quizAttempts[_courseId][msg.sender] = QuizAttempt(_score, _passed, !quizAttempts[_courseId][msg.sender].retaken);
        if (_passed) {
            users[msg.sender].rewardPoints += 50;
        }
    }

    // ------------------- NFT Badge Minting -------------------

    function _mintBadge(address _user, uint _courseId) internal {
        uint tokenId = nextBadgeId++;
        string memory metadata = string(abi.encodePacked("Course #", _toString(_courseId), " Badge"));
        _safeMint(_user, tokenId);
        _setTokenURI(tokenId, metadata);
        badgesMinted[_user].push(tokenId);
    }

    function _toString(uint v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint j = v;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (v != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + v % 10));
            v /= 10;
        }
        return string(bstr);
    }

    // ------------------- Getters -------------------

    function getBadges(address _user) external view returns (uint[] memory) {
        return badgesMinted[_user];
    }

    function getReferralReward(address _user) external view returns (uint) {
        return referralRewards[_user];
    }

    function getTutorStake(address _tutor) external view returns (uint) {
        return tutorStakes[_tutor];
    }
}
