# Description

**Reentrancy Attack** is a common attack method in smart contracts. When we make an external call, essentially we hand over the execution rights of the transaction to the called target address. If we do not update the storage variables before initiating this external call, malicious addresses can exploit out-of-date storage variables in the contract to attack.

### Classic Reentrancy Attack

Classic Reentrancy Attack is a simple form of reentrancy attack.

In the `Vault` smart contract, the `withdraw` function accepts a `uint256` parameter representing the amount to be withdrawn. After initiating an external call, it essentially hands over the transaction execution rights to the other party, allowing them to execute arbitrary code. For example, they could call the `withdraw` function again. At this point, if the `balance` variable is out-of-date, the attacker can exploit this vulnerability to steal all the ETH from the contract.

### Cross-Function Reentrancy Attack

Cross-Function Reentrancy Attack is an attack method that involves reentrant to different functions.

In the `Bank` smart contract, you may find that the `withdraw` function is modified with a `nonReentrant` modifier, which means that during the execution of the withdraw code, the same address can only enter the `withdraw` function once. This seems to prevent the reentrancy attack. But is it safe? You may notice the `transfer` function in the contract. What happens if an attacker calls this transfer function after gaining transaction execution rights? Since the balance is still an outdated variable, the attacker can transfer the tokens that should have been deducted to another address before the `balance` is updated, thereby profiting from it.

Obviously, when considering reentrancy attack, we need to consider not only the individual functions, but also every function in this contract.

### Cross-Contract Attack

I did not provide a code example for Cross-Contract Attack here, but we can consider it in conjunction with the Cross Function Attack mentioned above. What happens when the system starts to cross multiple contracts and there are multiple entry points in the system? This means there will be exponentially more attack areas.

### Read-Only Reentrancy Attack

Read-Only Reentrancy Attack is essentially not updating storage variables before external calls, which can cause some third-party systems to read these expired information and be exploited by attackers

In the `BankReadOnly` smart contract, I provided a simple code example. You may have noticed this harmless `balanceOf` read-only function. If a third-party system obtains `balance` by calling this function, attackers can profit from out-of-date read by the third-party system in an atomic transaction.

# Recommendation

### CEI

The **CEI** pattern is a defensive programming technique in smart contract development to prevent reentrancy attacks. It separates checks, effects, and interactions into distinct phases:

1. **Checks**: Perform all necessary checks before external function calls, such as verifying sufficient funds or valid states.
2. **Effects**: If checks pass, proceed with state changes like updating balances or modifying variables.
3. **Interactions**: Only after state changes are complete, interact with external contracts or functions.

This pattern ensures that all state changes are finalized before any external interactions, preventing attackers from disrupting the execution flow by repeatedly calling external functions.
