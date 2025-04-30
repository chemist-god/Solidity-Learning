// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Parent {
    function sayHello() public  pure returns (string memory) {
        return "Hello from Parent";
    }

    contract Child is Parent {
    function sayHelloFromChild() public pure returns (string memory) {
        return "Hello from Child";
    }
}

contract Parent_f {
    function externalFunction() public pure returns (string memory) {
        return "Hello from Parent";
    }
}
 contract Child_f {
    Parent_f externalContract;

    function setContract (address _newExternalContractAddress) public {
        externalContract = Parent_f(_newExternalContractAddress);    
    }

    function callExternalFunction() public view returns (string memory) {
        return externalContract.externalFunction();
    }
}
}