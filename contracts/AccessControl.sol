pragma solidity ^0.8.0; 

contract vulnContract {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function secretFunction() external pure returns(string memory a) {
        return "Secret Text";
    }
}


contract immuneContract {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function secretFunction() external view onlyOwner returns(string memory a) {
        return "Secret Text";
    }
}

