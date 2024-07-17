// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault {
    using SafeERC20 for IERC20;

    IERC20 public immutable asset;

    mapping(address => uint256) private shares;

    uint256 private totalShare;

    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    function sharesOf(address _ower) public view returns (uint256) {
        return shares[_ower];
    }

    function totalSupply() public view returns (uint256) {
        return totalShare;
    }

    function deposite(uint256 _amount) external {
        uint256 tokenBefore = asset.balanceOf(address(this));
        asset.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 tokenAfter = asset.balanceOf(address(this));
        uint256 amount = tokenAfter - tokenBefore;
        uint256 share = 0;
        if (totalShare == 0) {
            share = amount;
        } else {
            share = (amount * totalShare) / tokenBefore;
        }
        //_mint(msg.sender, share);
    }
}
