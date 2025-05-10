// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SignatureVerifier { 
   
   //fucntion
   function verifySignature(string memory _message , bytes32 expectedHash) public pure returns (bool) {
    return keccak256(bytes(_message)) == expectedHash;
   }
}
