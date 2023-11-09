pragma solidity ^0.8.20;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myBank is Ownable {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastInterestCalculation;
    mapping(address => bool) public isBlacklisted; // Mapping to keep track of blacklisted addresses

    uint256 public interestRate ; // 10% interest rate
    uint256 public secondsInYear = 31536000; // Assuming non-leap year
    bool public paused;
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    constructor() Ownable(msg.sender) {
        interestRate = 10;
        paused = false;
    }

    modifier notBlacklisted() {
        require(!isBlacklisted[msg.sender], "Address is blacklisted");
        _;
    }

    modifier notPaused() {
        require (!paused);
        _;
    }

    function deposit() public notBlacklisted notPaused payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        // Calculate and add interest before deposit
        calculateAndAddInterest(msg.sender);

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) notBlacklisted notPaused public {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Calculate and add interest before withdrawal
        calculateAndAddInterest(msg.sender);

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() public notPaused returns (uint256) {
        calculateAndAddInterest(msg.sender);

        return balances[msg.sender];
    }

    function getContractBalance() notPaused public view returns (uint256) {
        return address(this).balance;
    }

    function calculateAndAddInterest(address account) internal {
        uint256 timeSinceLastCalculation = block.timestamp - lastInterestCalculation[account];
        uint256 interest = (balances[account] * interestRate * timeSinceLastCalculation) / secondsInYear;

        balances[account] += interest;
        lastInterestCalculation[account] = block.timestamp;
    }

    function getAccumulatedInterest(address account) public notPaused view returns (uint256) {
        uint256 timeSinceLastCalculation = block.timestamp - lastInterestCalculation[account];
        return (balances[account] * interestRate * timeSinceLastCalculation) / secondsInYear;
    }

    function getCurrentInterestRate() public notPaused view returns(uint) { 
        return interestRate;
    }

    function changeInterestRate(uint256 interest) onlyOwner public returns(uint256) { 
        interestRate = interest;
    }

    function blacklistAddress(address account) public onlyOwner {
        isBlacklisted[account] = true;
    }

    function removeFromBlacklist(address account) public onlyOwner {
        isBlacklisted[account] = false;
    }

    function togglePause() public onlyOwner {
        paused = !paused;
    }
}


