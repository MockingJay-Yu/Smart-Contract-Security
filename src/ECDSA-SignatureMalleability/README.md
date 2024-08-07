# Description

### ECDSA签名算法

1. **初始化**
   
    `secp256k1`椭圆曲线（$y^{2} = x^{3} + 7$）的基点为 $G$，阶为 $n$，有限域为 $\mathbb{F}_p$。

2. **密钥生成**
    
- 生成256位随机数私钥 $p \in[1,n-1]$
- 通过椭圆曲线乘法，将私钥 $p$ 与基点 $G$ 相乘，得到一个点 $Q = p \cdot G$，这个点 $Q$ 就是公钥，横纵坐标分别占有32字节
- 通过对公钥进行`Keccak-256`哈希计算后，取最后20个字节作为地址

3. **签名**
- 对交易消息 $M$ 计算 $m = hash(M)$
- 生成一个随机数 $k \in[1,n-1]$，计算 $R = k \cdot G$
- 取R横坐标 $x$ 计算 $r = x \mod n$，如果 $r=0$，则返回上一步重新生成随机数$k$
- 计算 $s = k^{-1} (m + r \cdot p) \mod n$，如果 $r=0$，则返回重新生成随机数$k$
- 签名结果是$(r,s)$

4. **验签**
- 接收者接收到交易消息 $M$ 和签名 $(r, s)$
- 对交易消息 $M$ 计算 $m = hash(M)$
- 校验 $r,s \in[1,n-1]$，如果不在，签名无效
- 计算 $w = s^{-1} \mod n$
- 计算 $u1 = m \cdot w \mod n$
- 计算 $u2 = r \cdot w \mod n$
- 计算 $R' = u1 \cdot G + u2 \cdot Q$,
- 取 $R'$的横坐标 $x'$ 计算 $r' = x' \mod n$
- 当且仅当 $r = r'$，签名有效，以下是证明过程：
$$
R' = (s^{-1}m) \cdot G + (s^{-1}r) \cdot Q \\
= (s^{-1}m) \cdot G + (s^{-1}r \cdot p) \cdot G \\
= (s^{-1}(m+r \cdot p)) \cdot G \\
= k \cdot G \\
= R
$$
### ECDSA签名可塑性

ECDSA签名可塑性指的是对于一个给定的消息和签名，存在两个可以验证通过的签名。换句话说，签名不是唯一的。用上面的例子，$(r, n-s)$也是有效的签名。以下是证明过程：
$$
n - s \mod n = k^{-1}(m + r \cdot p) \mod n \\
k(-s) \mod n = (m + r \cdot p) \mod n \\
-s \cdot k \cdot G = m \cdot G + r \cdot p \cdot G \\
-s \cdot k \cdot G = m \cdot G + r \cdot Q \\
-R = s^{-1}m \cdot G + (s^{-1}r) \cdot Q
$$
- 从上面证明推导出来发现 $-R$ 的公式和上面 $R'$ 是一样的，$-R$ 的横坐标和 $R'$ 是一样的，纵坐标是一个负数
- 验证签名时，只需要用横坐标计算 $r' = x' \mod n$，只要 $r = r'$，签名就是有效的，所以同时存在两个有效签名 $(r, s)$ 和 $(r, n-s)$
- 这可能会被攻击者利用，绕过一些基于签名的安全检查，或伪造一笔有效交易。

# Recommendation

1. 在验证签名时，限制 $(s, n-s)$ 中小的那个是有效签名。具体来说，可以验证当 $s <= 2/n$ 时,签名有效。
2. `OpenZeppelin`中的安全库已经实现：
```solidity
if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS, s);
}
```
`0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0`是`secp256k1`椭圆曲线阶 $n$ 的一半减1。 
