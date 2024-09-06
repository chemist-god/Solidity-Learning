
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Twitter {

    //add a public constant 
    uint16 public MAX_TWEET_LENGTH = 280;

    //define our twee struct with author, content, timestamp, likes
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    //add our code to add multiple tweets
    //a mapping between user and tweet
    mapping(address => Tweet[ ]) public tweets;
    address public owner;

    //Defining event called TweetCreated
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);

    //definig new event for Tweetlikes, tweetAuthor, tweetId, newLikeCount
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount );

    //defining event for TwweetUnLike
    event TweetUnLiked(address unliker, address tweetAuthor, uint256 tweetId, uint256 unLikedCount);

    //creating a constructor function to set owner of function
    constructor() {
        owner = msg.sender;
    }

    //implementing modifier to allow only Owner
    modifier  onlyOwner() {
        require(msg.sender ==owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    function changeTweet(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    //function to getTotalLikes
    function getTotalLikes(address _author) external view returns  (uint) {
        uint totalLikes;
    //a for loop to get all the total likes from the author
        for( uint i =0; i < tweets[_author].length; i++){
            totalLikes += tweets[_author][i].likes;
        }
        return  totalLikes;
    }

    function createTweet(string memory  _tweet) public  {

        //conditional
        // if twee length <= 280 then we are good, otherwise revert
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long bru!" );

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);

        //emit event in creattweet function
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    //creating a like function
    function likeTweet(address author, uint256 id) external  {
        require(tweets[author][id].id ==id, "TWEET DOES NOT EXIST");
        tweets[author][id].likes++;

        //emit event in likeTweet()
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    //function to unlike tweet
    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        // require(tweets[author][id].id > 0, "TWEET HAS NO LIKES");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");

        tweets[author][id].likes--;

        //emit event to unlikeTwee()
        emit TweetUnLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    //creating a function to get tweet
    function getTweet( uint _i) public view returns (Tweet memory) {

        return tweets[msg.sender][_i];
    }

    // a function to get allTweets
    function getAlltweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}