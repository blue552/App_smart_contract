// SPDX-License-Identifier: UMIT
pragma solidity ^0.8.15;

contract Migrations {
    address public owner;
    uint public lastCompletedMigration;

    constructor() {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public {
        require(msg.sender == owner, "Only owner can call this");
        lastCompletedMigration = completed;
    }
}
