# Description

In the `IncreasePosition` smart contract, we updated the position information in `increasePosition` by passing `_executePrice` and `_orderSize`. There is a hidden danger in the code of recalculating the average price. Because solidity always rounds and truncates when handling division, That means the attacker can increase position size while keeping the avgPirce unchanged. As the following example:

- size = 1e18
- avgPrice = 100e8
- orderSize = 1e10
- executePrice = 101e8

Therefore, the `updatedAvgPrice = (1e18 * 100e8 + 1e10 * 101e8) / (1e18 + 1e10) = 100e8`.
This rounding truncation may provides attackers with the opportunity to manipulate their average price and make risk free profits.

# Recommendation

In the above case, we should use roundUp division when calculating the `avgPrice` for longs and round down division when calculating the `avgPrice` for shorts.

when encountering `/`, we must consider the negative impact of rounding truncation on the system, then decide whether to round down or up.
