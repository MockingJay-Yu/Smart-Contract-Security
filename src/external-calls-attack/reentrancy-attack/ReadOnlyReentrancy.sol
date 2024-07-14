// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BankReadOnly is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external nonReentrant {
        uint256 balance = balances[msg.sender];
        require(balance >= amount, "Insufficient balance");
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
        balances[msg.sender] -= amount;
    }

    //q: Assuming a third-party system calls this function to obtain balance information.
    // Attackers may attempt to call this function after calls the withdraw function within
    // an atomic transaction, is the balance they obtained correct? Will the attackers exploit
    // this for arbitrage?
    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }
}
