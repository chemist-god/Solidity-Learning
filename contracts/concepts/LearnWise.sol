// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnWise {
    uint public nextCourseId;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct User {
        address wallet;
        string name;
        bool isTutor;
        uint[] enrolledCourses;
        uint[] completedCourses;
        uint rewardPoints;
    }

    struct Course {
        uint id;
        address tutor;
        string title;
        string description;
        uint totalCompletions;
        bool isActive;
    }

    struct QuizAttempt {
        uint score;
        bool passed;
        bool retaken;
    }

    struct Quiz {
        uint courseId;
        string[] questions;
        mapping(uint => string) correctAnswers;
        mapping(address => QuizAttempt) attempts;
    }

    mapping(address => User) public users;
    mapping(uint => Course) public courses;
    mapping(address => mapping(uint => bool[])) public lessonProgress;
    mapping(uint => Quiz) private quizzes;

    // ------------------- User Management -------------------

    function registerUser(string memory _name, bool _isTutor) external {
        require(users[msg.sender].wallet == address(0), "User already registered");
        users[msg.sender] = User(msg.sender, _name, _isTutor, new uint[](0), new uint[](0), 0);
    }

    // ------------------- Course Creation -------------------

    function createCourse(string memory _title, string memory _description) external {
        require(users[msg.sender].isTutor, "Only tutors can create courses");
        courses[nextCourseId] = Course(nextCourseId, msg.sender, _title, _description, 0, true);
        nextCourseId++;
    }

    // ------------------- Enrollment & Progress -------------------

    function enrollInCourse(uint _courseId) external {
        require(courses[_courseId].isActive, "Inactive course");
        users[msg.sender].enrolledCourses.push(_courseId);
    }

    function markLessonComplete(uint _courseId, uint _lessonIndex) external {
        lessonProgress[msg.sender][_courseId][_lessonIndex] = true;
    }

    function completeCourse(uint _courseId) external {
        users[msg.sender].completedCourses.push(_courseId);
        users[msg.sender].rewardPoints += 100;
        courses[_courseId].totalCompletions++;
        users[courses[_courseId].tutor].rewardPoints += 50;
    }

    // ------------------- Quiz Logic -------------------

    function submitQuiz(
        uint _courseId,
        uint _score,
        bool _passed
    ) external {
        QuizAttempt storage attempt = quizzes[_courseId].attempts[msg.sender];
        attempt.score = _score;
        attempt.passed = _passed;
        attempt.retaken = !attempt.retaken;
        
        if (_passed) {
            users[msg.sender].rewardPoints += 50;
        }
    }

    // ------------------- Utility -------------------

    function getUser(address _user) external view returns (User memory) {
        return users[_user];
    }

    function getCourse(uint _id) external view returns (Course memory) {
        return courses[_id];
    }

    function getUserProgress(address _user, uint _courseId) external view returns (bool[] memory) {
        return lessonProgress[_user][_courseId];
    }
}
