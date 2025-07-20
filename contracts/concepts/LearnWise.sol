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
}
