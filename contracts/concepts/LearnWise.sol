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
}
