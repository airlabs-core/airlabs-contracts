// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// erc6551
import "account-abstraction/core/EntryPoint.sol";
import "erc6551/ERC6551Registry.sol";
import "erc6551/interfaces/IERC6551Account.sol";
import {Account as TokenboundAccount} from "tokenbound/Account.sol";
import {AccountGuardian} from "tokenbound/AccountGuardian.sol";

import "forge-std/Test.sol";
import "../src/StakingRewards.sol";
import "../src/mock/LandParcelMock.sol";
import "../src/mock/ExperiencePointMock.sol";

contract StakingRewardsTest is Test {
    address public user;

    LandParcelMock public landParcel;
    ExperiencePointMock public stakingToken;
    ExperiencePointMock public rewardsToken;
    StakingRewards public stakingRewards;

    // eip6551
    TokenboundAccount public implementation;
    AccountGuardian public guardian;
    ERC6551Registry public registry;
    IEntryPoint public entryPoint;

    function setUp() public {
        user = vm.addr(0x0069);

        stakingToken = new ExperiencePointMock();
        rewardsToken = new ExperiencePointMock();

        // eip6551
        entryPoint = new EntryPoint();
        guardian = new AccountGuardian();
        implementation = new TokenboundAccount(
            address(guardian),
            address(entryPoint)
        );
        registry = new ERC6551Registry();

        stakingRewards = new StakingRewards(
            address(stakingToken),
            address(rewardsToken)
        );
        landParcel = new LandParcelMock(
            address(stakingToken),
            address(implementation),
            address(registry),
            address(stakingRewards)
        );
        stakingToken.setLandParcel(address(landParcel));
    }

    function testStake() public {
        stakingToken.mint(user, 1000);

        vm.prank(user);
        stakingToken.approve(address(stakingRewards), 1000);

        vm.prank(user);
        stakingRewards.stake(1000);

        assertEq(stakingToken.balanceOf(user), 0);
        assertEq(stakingRewards.balanceOf(user), 1000);
    }

    function testStakeUsingLandParcel() public {
        uint256 stakeAmount = 2500;
        stakingToken.mint(user, landParcel.CLAIM_COST());

        vm.prank(user);
        (uint256 tokenId, address accountAddress) = landParcel.claim();

        assertEq(landParcel.balanceOf(user), 1);
        assertEq(landParcel.getAccount(tokenId), accountAddress);


        TokenboundAccount account = TokenboundAccount(payable(accountAddress));
        assertEq(account.isAuthorized(user), true);

        stakingToken.mint(accountAddress, stakeAmount);
        vm.prank(user);
        // ! fails
        landParcel.stakeExperiencePoints(tokenId, stakeAmount);
    }
}
