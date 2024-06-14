// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.25;

interface IOrderCallbackRecevier {
    function afterOrderExecution() external;
}
