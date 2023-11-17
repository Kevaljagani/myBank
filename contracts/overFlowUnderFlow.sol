// SPDX-License-Identifier: MIT
//using older version because soilidity >8.0 supports inbuild overflow
pragma solidity ^0.7.0;

contract IntegerOverflowUnderflow {

    // Unsigned integer for demonstration
    uint8 public myUint;

    // Function to demonstrate underflow
    function decrement() public {
        myUint--;  // This will underflow when myUint is 0
    }

    // Function to demonstrate overflow
    function increment() public {
        myUint++;  // This will overflow when myUint is 255
    }

    // Function to set the initial value of myUint
    function setMyUint(uint8 _myUint) public {
        myUint = _myUint;
    }

    // Function to get the current value of myUint
    function getMyUint() public view returns (uint8) {
        return myUint;
    }
}

//Fix: Upgrade to version 0.8.0 or above
pragma solidity ^0.8.0;

contract ImmuneIntegerOverflowUnderflow {

    // Unsigned integer for demonstration
    uint8 public myUint;

    // Function to demonstrate underflow
    function decrement() public {
        myUint--;  // This will underflow when myUint is 0
    }

    // Function to demonstrate overflow
    function increment() public {
        myUint++;  // This will overflow when myUint is 255
    }

    // Function to set the initial value of myUint
    function setMyUint(uint8 _myUint) public {
        myUint = _myUint;
    }

    // Function to get the current value of myUint
    function getMyUint() public view returns (uint8) {
        return myUint;
    }
}
