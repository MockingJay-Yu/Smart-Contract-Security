// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOrderCallbackRecevier {
    function afterOrderExecution() external;
}
