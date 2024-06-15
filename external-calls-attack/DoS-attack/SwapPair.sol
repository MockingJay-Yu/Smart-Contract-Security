// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SwapPair {
    struct UserInfo {
        uint256 rewards;
        uint256 rewardDedt;
    }

    mapping(address => UserInfo) public userInfo;

    address[] public users;

    function mint(address to) external {
        //...
        //Calculate liquidity
        //...
        if (IERC20(address(this)).balanceOf(to) == 0) {
            users.push(to);
        }
        //...
    }

    function distrbuteDividends(uint256 amount) public payable {
        require(amount == msg.value, "don't cheat");
        //q: Can we control the size of this array?
        //q: What happens if this users is very large?
        uint256 length = users.length;
        for (uint i; i < length - 1; i++) {
            if (users[i] != address(0)) {
                UserInfo storage user = userInfo[users[i]];
                //Calculate user rewards
                //...
            }
        }
    }
}
