// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BankReadOnly is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(isAllowWithdraw(amount), "Insufficient balance");
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
        balances[msg.sender] -= amount;
    }

    function isAllowWithdraw(uint256 amount) public view returns (bool) {
        uint256 balance = balances[msg.sender];
        if (balance >= amount) return true;
        return false;
    }

    //If a third-party system calls this function to obtain balance information,
    //attackers may attempt to call the withdraw function within an atomic transaction,
    //exploiting outdated information from the third-party system to arbitrage after gaining transaction execution rights.
    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }
}
