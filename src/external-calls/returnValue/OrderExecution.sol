// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IOrderCallbackRecevier.sol";

contract OrderExecution {
    struct Order {
        uint256 orderId;
        IOrderCallbackRecevier callbackContract;
        uint256 callbackGasLimit;
    }

    event AfterOrderExecution(uint256 orderId, string revertReason);

    function afterOrderExecution(Order memory order) internal {
        try IOrderCallbackRecevier(order.callbackContract).afterOrderExecution{gas: order.callbackGasLimit}() {}
        catch (
            bytes memory revertData
        ) //q: What happens if this revertData is very large?
        {
            emit AfterOrderExecution(order.orderId, string(revertData));
        }
    }
}
