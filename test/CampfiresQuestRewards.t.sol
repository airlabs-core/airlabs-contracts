// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/CampfiresQuestRewards.sol";


contract CampfiresQuestRewardsTest is Test {
    CampfiresQuestRewards public campfiresQuestRewards;
    address public admin = address(5555);
    address public verifier = address(1337);
    address public account1 = address(1);

    function setUp() public {
        campfiresQuestRewards = new CampfiresQuestRewards(verifier);

        // create quest reward
        vm.prank(admin);
        campfiresQuestRewards.createQuestReward(
            "https://assets.campfires.gg/1.json",
            5000
        );
        (
            uint256 tokenId,
            string memory uri,
            ,
            address payable author,
            uint256 price
        ) = campfiresQuestRewards.questRewards(1);

        assertEq(tokenId, 1);
        assertEq(admin, author);
        assertEq(price, 5000);
        assertEq(uri, "https://assets.campfires.gg/1.json");
    }

    function testClaimQuestReward() public {
        vm.prank(account1);

        campfiresQuestRewards.claimQuestReward(
            1,
            1,
            keccak256(abi.encodePacked(account1, 1, 1))
        );
        bool claimed = campfiresQuestRewards.claimedQuestRewards(account1, 1);

        assertEq(claimed, true);
        assertEq(campfiresQuestRewards.balanceOf(account1, 1), 1);
    }
}
