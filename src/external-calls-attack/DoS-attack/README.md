# Description

**DoS attack(Denial of Service)** is a malicious behavior. Its purpose is to deplete resources or render the target system service unresponsive, thereby preventing or reducing the ability of the smart contract to provide normal services. Especially on blockchain platforms like Ethereum, once gas is depleted, the transaction will be rolled back.

### Unbounded for loop

In the `SwapPair` smart contract, it simulated a simple dividend distribution contract. Noticed the `users`
array, we can push an addresses into this array in `mint` function, provided that the balance of this address in the contract is zero. An address meets this condition is easy to design. It means that attackers can keep generating new address and push them into this array. When this array becomes very large, the traverse of `users` in `distrbuteDividends` function becomes an unbounded for loop, the for loop will expand enough gas, that you will not be able to execute this function.

### An failed external call prevents the transaction

In the `Liquidation` smart contract, it simulated a contract where users can build a postion and liquidation. Assuming that the user's collateral is no longer sufficient to support the position triggering liquidation, in the `liquidate` funciton, it calculate that after deduting a part of the collateral value, the remaining ETH needs to be returned to the user. If the external call here is a contract address without receive and fallback funcitons, so in fact, attackers created a position that will never be liquidated, because the `liquidate` function always roll back due to this failed external call.

# Recommendation

**DoS attack** actually has many attack methods. In the development of smart contracts, we can follow the following frameworks:

1. Everytime you see a for loop, you should ask yourself the following question:
   - Is this iterative things is that bound to a certain size?
   - Can users add as many items as they want to?
   - How much does it cost for users to do that?
     if users can do it and it's very cheap, so there may be a potential DoS attack here.
2. Look out for any external calls, you should ask yourself the following question:

   - Is there a way for these calls to fail?
   - If they do fail, will it cause the transaction to roll back?
   - How can that actually affect the system?
   - Will it has a negative impact on the system?

   There are several different ways to force external calls to fail:

   - **Sending ether to a contract that does not accept it**
   - **Calling a function that does not exist**
   - **The external call execution runs out of gas**
   - **Third-party contract is simply malicious**
