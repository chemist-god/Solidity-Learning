// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Vote {
    struct Nominee {
        uint id;
        string name;
        string group;
        uint256 voteCount;
    }    

    mapping (uint => Nominee) public nominees;
    mapping(address => bool) public voters;
     
   uint public countNominees;
  uint256 public votingClose;
  uint256 public votingBegin;

  event NomineeAdded(uint256 id, string name, string group);

  function addNominee(string memory _name, string memory _group ) 
    public returns(uint) {
        countNominees ++;
        nominees[countNominees] = Nominee({
            id: countNominees,
             name : _name , 
             group :_group,
             voteCount:0 
            });

    emit NomineeAdded(countNominees, _name ,_group);
         return countNominees;
       }
    
  }
      
    
    

