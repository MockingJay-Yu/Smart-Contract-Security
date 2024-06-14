When initiating an external call, we must handle the returnValue with caution as we cannot control the other party's response.

In the `OrderExecution` smart contract, we want to call the `afterOrderExecution` function of the callback contract for the order, and if it revert, we want the other party to return the reason for the failure.

The `OrderExecutionAttack` smart contract extends `IOrderCallbackReceiver` and has implemented the `afterOrderExecution` function.

In this function, it creates a large byte array and reverses it. Imagine what would happen if we caught this large array? In EVM, the cost of copying bytes to memory for gas increases in cubic terms, and this large array will exhaust gas, leading to transaction failure and rollback. So we should not catch any data returned by the other party here, nor should we use the data returned by the other party, because we cannot guarantee what kind of data the other party will return.
