// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IStakingRewards {
    function balanceOf(address _account) external returns (uint);

    function stake(uint256 _amount) external;

    function withdraw(uint256 _amount) external;
}
