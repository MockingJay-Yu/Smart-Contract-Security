// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint256) public balances;

    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        uint256 balance = balances[msg.sender];
        require(balance >= amount, "Insufficient balance");
        //q: This external call means we hand over the execution rights of the transaction to
        // the msg.sender, so what happens if the other party calls this function again?
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
        balances[msg.sender] = balance - amount;
    }
}
