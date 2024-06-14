// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

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
        //This external call can trigger a reciprocal withdraw function call from the counterparty,
        //constituting a reentrancy attack.
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
        balances[msg.sender] = balance - amount;
    }
}
