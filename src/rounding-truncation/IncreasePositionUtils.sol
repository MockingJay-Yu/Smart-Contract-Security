// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract IncreasePositionUtils {
    struct Position {
        uint256 size;
        uint256 avgPrice;
        bool isLong;
        uint256 lastTimetamp;
    }

    mapping(uint256 => Position) openPositions;

    function increasePosition(uint256 _positionId, uint256 _executePrice, uint256 _orderSize) external {
        //...
        Position storage userPosition = openPositions[_positionId];
        //q: Can we pass specific values to _executePrice and _orderSize to increase the position size while keeping the position average price unchanged?
        uint256 avgPrice =
            (userPosition.avgPrice * userPosition.size + _orderSize * _executePrice) / (userPosition.size + _orderSize);
        userPosition.size += _orderSize;
        userPosition.lastTimetamp = block.timestamp;
        userPosition.avgPrice = avgPrice;
        //...
    }
}
