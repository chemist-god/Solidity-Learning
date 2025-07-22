// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LearnWiseBasic
 * @dev A simple decentralized learning platform with NFT course completion badges.
 */
contract LearnWiseBasic is ERC721URIStorage, Ownable {
    uint256 public nextCourseId;
    uint256 public nextBadgeId;

    struct User {
        string name;
        bool isTutor;
        uint256[] enrolledCourses;
        uint256[] completedCourses;
    }

    struct Course {
        string title;
        string description;
        address tutor;
        bool isActive;
    }

    struct QuizAttempt {
        uint256 score;
        bool passed;
    }

    // Mappings
    mapping(address => User) public users;
    mapping(uint256 => Course) public courses;
    mapping(address => mapping(uint256 => bool[])) public lessonProgress; // user -> course -> lesson[]
    mapping(uint256 => mapping(address => QuizAttempt)) public quizAttempts;
    mapping(address => uint256[]) public badgesMinted;

    // Events
    event UserRegistered(address indexed user, string name, bool isTutor);
    event CourseCreated(uint256 indexed courseId, string title, address indexed tutor);
    event CourseEnrolled(address indexed user, uint256 indexed courseId);
    event CourseCompleted(address indexed user, uint256 indexed courseId);
    event QuizSubmitted(address indexed user, uint256 indexed courseId, uint256 score, bool passed);
    event BadgeMinted(address indexed user, uint256 indexed tokenId, uint256 indexed courseId);

    constructor() ERC721("LearnBadge", "LBDG") {}

    // --- User Registration ---
    function registerUser(string memory _name, bool _isTutor) external {
        require(bytes(users[msg.sender].name).length == 0, "User already registered");
        users[msg.sender] = User({
            name: _name,
            isTutor: _isTutor,
            enrolledCourses: new uint256[](0),
            completedCourses: new uint256[](0)
        });
        emit UserRegistered(msg.sender, _name, _isTutor);
    }

    // --- Course Creation (Only Tutors) ---
    function createCourse(string memory _title, string memory _description) external {
        require(users[msg.sender].isTutor, "Only tutors can create courses");
        courses[nextCourseId] = Course({
            title: _title,
            description: _description,
            tutor: msg.sender,
            isActive: true
        });
        emit CourseCreated(nextCourseId, _title, msg.sender);
        nextCourseId++;
    }

    // --- Enroll in Course ---
    function enrollCourse(uint256 _courseId) external {
        require(_courseId < nextCourseId, "Course does not exist");
        require(courses[_courseId].isActive, "Course is inactive");
        require(!isEnrolled(msg.sender, _courseId), "Already enrolled");

        users[msg.sender].enrolledCourses.push(_courseId);
        emit CourseEnrolled(msg.sender, _courseId);
    }

    // --- Mark Lesson as Complete ---
    function completeLesson(uint256 _courseId, uint256 _lessonIndex) external {
        require(isEnrolled(msg.sender, _courseId), "Not enrolled in course");
        // Dynamically expand lesson progress array
        if (_lessonIndex >= lessonProgress[msg.sender][_courseId].length) {
            uint256 newLen = _lessonIndex + 1;
            bool[] storage progress = lessonProgress[msg.sender][_courseId];
            /* solhint-disable-next-line no-inline-assembly */
            assembly {
                mstore(progress, newLen)
            }
            // Initialize new lessons to false
            for (uint256 i = 0; i < newLen; ) {
                if (i >= progress.length) {
                    progress.push(false);
                }
                unchecked { i++; }
            }
        }
        lessonProgress[msg.sender][_courseId][_lessonIndex] = true;
    }

    // --- Submit Quiz ---
    function submitQuiz(uint256 _courseId, uint256 _score, bool _passed) external {
        require(isEnrolled(msg.sender, _courseId), "Not enrolled");
        // Prevent retakes for now
        require(quizAttempts[_courseId][msg.sender].passed == false && 
                quizAttempts[_courseId][msg.sender].score == 0, "Quiz already taken");

        quizAttempts[_courseId][msg.sender] = QuizAttempt(_score, _passed);

        if (_passed) {
            emit QuizSubmitted(msg.sender, _courseId, _score, _passed);
        }
    }

    // --- Complete Course & Mint Badge ---
    function completeCourse(uint256 _courseId) external {
        require(isEnrolled(msg.sender, _courseId), "Not enrolled");
        require(!isCompleted(msg.sender, _courseId), "Course already completed");
        require(quizAttempts[_courseId][msg.sender].passed, "Quiz not passed");

        users[msg.sender].completedCourses.push(_courseId);

        _mintBadge(msg.sender, _courseId);

        emit CourseCompleted(msg.sender, _courseId);
    }

    // --- Internal: Mint NFT Badge ---
    function _mintBadge(address _to, uint256 _courseId) internal {
        uint256 tokenId = nextBadgeId++;
        string memory tokenURI = string(
            abi.encodePacked("ipfs://example/course-", _uintToString(_courseId), "-badge.json")
        );
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        badgesMinted[_to].push(tokenId);
        emit BadgeMinted(_to, tokenId, _courseId);
    }

    // --- View Functions ---
    function isEnrolled(address _user, uint256 _courseId) public view returns (bool) {
        uint256[] memory list = users[_user].enrolledCourses;
        for (uint256 i = 0; i < list.length; ) {
            if (list[i] == _courseId) return true;
            unchecked { i++; }
        }
        return false;
    }

    function isCompleted(address _user, uint256 _courseId) public view returns (bool) {
        uint256[] memory list = users[_user].completedCourses;
        for (uint256 i = 0; i < list.length; ) {
            if (list[i] == _courseId) return true;
            unchecked { i++; }
        }
        return false;
    }

    function getEnrolledCourses(address _user) external view returns (uint256[] memory) {
        return users[_user].enrolledCourses;
    }

    function getCompletedCourses(address _user) external view returns (uint256[] memory) {
        return users[_user].completedCourses;
    }

    function getBadges(address _user) external view returns (uint256[] memory) {
        return badgesMinted[_user];
    }

    // --- Utilities ---
    function _uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }
}