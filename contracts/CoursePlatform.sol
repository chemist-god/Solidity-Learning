// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract CoursePlatform {
    // ========== STRUCTS ==========
    struct Course {
        address tutor;
        string title;
        uint passThreshold;
        uint rewardAmount;
    }

    struct UserProgress {
        bool enrolled;
        uint quizScore;
        bool certified;
    }

    // ========== STATE VARIABLES ==========
    address public admin;
    uint public courseCounter;
    
    mapping(uint => Course) public courses;
    mapping(address => bool) public approvedTutors;
    mapping(uint => mapping(address => UserProgress)) public progress;
    mapping(address => uint) public rewards;

    // ========== EVENTS ==========
    event CourseCreated(uint courseId, address tutor, string title);
    event Enrolled(uint courseId, address learner);
    event QuizSubmitted(uint courseId, address learner, uint score);
    event Certified(uint courseId, address learner);

    // ========== MODIFIERS ==========
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    modifier onlyTutor(uint courseId) {
        require(msg.sender == courses[courseId].tutor, "Only tutor");
        _;
    }

    // ========== CONSTRUCTOR ==========
    constructor() {
        admin = msg.sender;
    }

    
}