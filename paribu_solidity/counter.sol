//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.7;


// counter contract
contract Counter {
    uint public count;  // variable to store the count

    function inc() external {   // function to increment the count
        count += 1;
    }

    function dec() external { // function to decrement the count
        count -= 1;
    }
}