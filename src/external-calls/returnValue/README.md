# Description

In the `OrderExecution` smart contract, we want to call the `afterOrderExecution` function of the callback contract for the order, and if it revert, we want the other party to return the reason for the failure.

The `OrderExecutionAttack` smart contract extends `IOrderCallbackReceiver` and has implemented the `afterOrderExecution` function.

In this function, it creates a large byte array and reverses it. Imagine what would happen if we caught this large array? In EVM, the cost of copying bytes to memory for gas increases in cubic terms, and this large array will exhaust gas, leading to transaction failure and rollback. Attackers are likely to exploit this for profit.

# Recommendation

We must be careful when dealing with the return value of external calls. Especially those contracts that we
cannot fully trust and those return value that we cannot control in size and type.
