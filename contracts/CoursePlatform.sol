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

    // ========== ADMIN FUNCTIONS ==========
    function approveTutor(address tutor) external onlyAdmin {
        approvedTutors[tutor] = true;
    }

    // ========== TUTOR FUNCTIONS ==========
    function createCourse(
        string memory title,
        uint passThreshold,
        uint rewardAmount
    ) external {
        require(approvedTutors[msg.sender], "Not approved tutor");
        
        courseCounter++;
        courses[courseCounter] = Course({
            tutor: msg.sender,
            title: title,
            passThreshold: passThreshold,
            rewardAmount: rewardAmount
        });

        emit CourseCreated(courseCounter, msg.sender, title);
    }

    // ========== LEARNER FUNCTIONS ==========
    function enroll(uint courseId) external {
        require(courses[courseId].tutor != address(0), "Course doesn't exist");
        require(!progress[courseId][msg.sender].enrolled, "Already enrolled");

        progress[courseId][msg.sender].enrolled = true;
        emit Enrolled(courseId, msg.sender);
    }

    function submitQuiz(uint courseId, uint score) external {
        require(progress[courseId][msg.sender].enrolled, "Not enrolled");
        require(!progress[courseId][msg.sender].certified, "Already certified");

        progress[courseId][msg.sender].quizScore = score;
        emit QuizSubmitted(courseId, msg.sender, score);

        if (score >= courses[courseId].passThreshold) {
            progress[courseId][msg.sender].certified = true;
            rewards[courses[courseId].tutor] += courses[courseId].rewardAmount;
            emit Certified(courseId, msg.sender);
        }
    }

    // ========== UTILITY FUNCTIONS ==========
    function getProgress(uint courseId, address user) external view returns (UserProgress memory) {
        return progress[courseId][user];
    }
}