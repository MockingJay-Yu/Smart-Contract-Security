# Description

In `Vault` contract, users can deposit assets and obtain corresponding shares through the `deposit` function. When the vault is empty, attackers can steal the deposits through frontrunning with a `donation` to the vault that inflates the price of a share. As the following example:

- when the vault is empty, attacker deposits `1 USDC` into the vault and obtains `1` share.
- the attacker abserved through the trading pool that user `A` wanted to deposit `1000 USDC` into the vault.
- the attacker transferred `1000 USDC` to vault before this transaction, without using the `deposit` function and obtaining any shares.
- when `A`'s transaction is executed, the totalShare is `1`, the balance of vault is `1001 USDC`, and the share of `A` is
  `(1000 * 1) / 1001 = 0`. This means that `A` will not receive a share and only the attacker owns the share.
- the attacker possesses all the deposit and can withdraw them for arbitrage.

# Recommendation

Vault deployment personnel can make price of share manipulation unfeasible by storing an initial asset and permanently locking the corresponding share.
