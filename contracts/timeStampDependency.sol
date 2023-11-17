// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public recentWinner;
    uint public lotteryEndTime;
    uint private seed;

    constructor(uint _durationMinutes) {
        lotteryEndTime = block.timestamp + (_durationMinutes * 1 minutes);
    }

    function participate() external payable {
        require(msg.value > 1 ether, "Must send 0.1 ETH to participate");
        require(block.timestamp < lotteryEndTime, "Lottery has ended");

        // Vulnerable: Using block.timestamp as a part of randomness source
        if ((uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % 100) == 0) {
            recentWinner = msg.sender;
            payable(msg.sender).transfer(address(this).balance);
        }

        seed = (seed + block.timestamp + uint256(uint160(address(msg.sender)))) % 1000;

    }
}


//Fix: Use blockhash(block.number) instead of block.timestamp
//Randomness is a very vast topic in blockchain. Its very difficult to achieve complete randomness in blockchain apps. But a general rule of thumb is to avoid usage of block.timestamp to avoide timestamp manipulation attacks. In this case, we can use blockhash(block.number) instead of block.timestamp. This will make the contract more secure.