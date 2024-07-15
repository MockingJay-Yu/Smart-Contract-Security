// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Bank is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external nonReentrant {
        uint256 balance = balances[msg.sender];
        require(balance >= amount, "Insufficient balance");

        //q: Although this function has been modified with nonReentrant, what if
        // the other party calls other function of the contract? For example, the
        // transfer function below
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
        balances[msg.sender] = balance - amount;
    }

    function transfer(address to, uint256 amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
