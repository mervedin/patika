//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FeeCollector {
    address public owner;
    uint public balance;

    constructor(){
        owner = msg.sender;
    }

    // when the contract receives eth, add that amount to the balance
    receive() payable external{
        balance += msg.value;
    }

    // withdraw eth from the contract, only the contract owner can withdraw
    function withdraw(address payable destAddr, uint amount) public {
        require(owner == msg.sender, "Only owner can withdraw");
        require(amount <= balance, "Insufficient funds");
        
        destAddr.transfer(amount);
        balance -= amount;
    }

}