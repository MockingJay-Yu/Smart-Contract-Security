// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Liquidation {
    struct Position {
        uint256 collateral;
        uint256 debt;
        uint256 liquidationPrice;
    }

    mapping(address => Position) public positions;

    event LiquidateFail(address accountToLiquidate, string reason);

    error LiquidateError(address receiver, uint256 amount);

    function setPosition(
        uint256 collateral,
        uint256 debt,
        uint256 liquidationPrice
    ) external {
        //...
        //Various operations for setting positions
        //...
        positions[msg.sender] = Position(collateral, debt, liquidationPrice);
    }

    function liquidate(address accountToLiquidate) internal {
        //...
        //Various operations for liquidation
        //...
        //Here's a simple assumption: liquidation requires a refund of all collateral
        uint256 amount = positions[accountToLiquidate].collateral;

        //q: What happens if the contract of accountToLiquidate cannot receive any
        // ETH(that means the contract doesn't have receive and fallback function)?
        (bool success, bytes memory data) = payable(accountToLiquidate).call{
            value: amount
        }("");

        if (success) return;

        string memory reason = string(abi.encode(data));
        emit LiquidateFail(accountToLiquidate, reason);

        revert LiquidateError(accountToLiquidate, amount);
    }
}
