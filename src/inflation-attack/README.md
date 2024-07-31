# Description

In `Vault` contract, users can deposit assets and obtain corresponding shares through the `deposit` function. When the vault is empty, attackers can steal the deposits through frontrunning with a `donation` to the vault that inflates the price of a share. As the following example:

- when the vault is empty, attacker deposits `1 USDC` into the vault and obtains `1` share.
- the attacker abserved through the trading pool that user `A` wanted to deposit `1000 USDC` into the vault.
- the attacker transferred `1000 USDC` to vault before this transaction, without using the `deposit` function and obtaining any shares.
- when `A`'s transaction is executed, the totalShare is `1`, the balance of vault is `1001 USDC`, and the share of `A` is
  `(1000 * 1) / 1001 = 0`. This means that `A` will not receive a share and only the attacker owns the share.
- the attacker possesses all the deposit and can withdraw them for arbitrage.

# Recommendation

- Revert if the amount received is not within a slippage tolerance.
- The deployer should deposit enough assets into the pool such that doing this inflation attack would be too expensive.
- Add "virtual liquidity" to the vault so the pricing behaves as if the pool had been deployed with enough assets.
Here is OpenZeppelin's implementation of virtual liquidity in ERC4626:
```solidity
function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256){
        return shares.mulDiv(totalAssets() + 1, totalSupply() + 10 ** _decimalsOffset(), rounding);
}
```
Effectively, it is making the numberator 1000 times larger when we set `_decimalOffset()` to be 3. This forces the attacker to make a donation 1000 times as large, which disincentivizes them from conducting the attack.