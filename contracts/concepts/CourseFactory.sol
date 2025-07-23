// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ==================== Certificate NFT (ERC-721) ====================
contract CertificateNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("CourseCertificate", "CERT") {}

    function mintCertificate(address to, string memory tokenURI) external onlyOwner returns (uint256) {
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;
        _mint(to, newTokenId);
        _tokenURIs[newTokenId] = tokenURI;
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Non-existent token");
        return _tokenURIs[tokenId];
    }
}

// ==================== Reward Token (ERC-20) ====================
contract RewardToken is ERC20, Ownable {
    constructor() ERC20("CourseRewardToken", "CRT") {
        _mint(msg.sender, 1_000_000 * 10**18); // Mint initial supply to deployer
    }

    function rewardUser(address user, uint256 amount) external onlyOwner {
        _transfer(owner(), user, amount);
    }
}

// ==================== Course Contract ====================
contract Course is Ownable {
    address public tutor;
    string public title;
    uint256 public passThreshold;
    CertificateNFT public certificateNFT;
    RewardToken public rewardToken;

    mapping(address => bool) public enrolled;
    mapping(address => uint256) public quizScores;
    mapping(address => bool) public certified;

    event Enrolled(address learner);
    event QuizSubmitted(address learner, uint256 score);
    event Certified(address learner, uint256 tokenId);

    constructor(
        address _tutor,
        string memory _title,
        uint256 _passThreshold,
        address _certificateNFT,
        address _rewardToken
    ) {
        tutor = _tutor;
        title = _title;
        passThreshold = _passThreshold;
        certificateNFT = CertificateNFT(_certificateNFT);
        rewardToken = RewardToken(_rewardToken);
        transferOwnership(_tutor); // Tutor manages this course
    }

    function enroll() external {
        require(!enrolled[msg.sender], "Already enrolled");
        enrolled[msg.sender] = true;
        emit Enrolled(msg.sender);
    }

    function submitQuiz(uint256 score, string memory certificateURI) external {
        require(enrolled[msg.sender], "Not enrolled");
        quizScores[msg.sender] = score;
        emit QuizSubmitted(msg.sender, score);

        if (score >= passThreshold && !certified[msg.sender]) {
            certified[msg.sender] = true;
            uint256 tokenId = certificateNFT.mintCertificate(msg.sender, certificateURI);
            rewardToken.rewardUser(tutor, 100 * 10**18); // Reward tutor (100 tokens)
            emit Certified(msg.sender, tokenId);
        }
    }
}

