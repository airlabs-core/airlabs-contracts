// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CampfiresExperiencePoints.sol";
import "../src/CampfiresQuestRewards.sol";

contract CampfiresExperiencePointsTest is Test {
    CampfiresExperiencePoints public campfiresExperiencePoints;
    CampfiresQuestRewards public campfiresQuestRewards;
    address public account = address(55);

    function setUp() public {
        campfiresExperiencePoints = new CampfiresExperiencePoints();
        campfiresQuestRewards = new CampfiresQuestRewards(
            address(1337),
            address(campfiresExperiencePoints)
        );
        campfiresExperiencePoints.setCampfiresQuestRewards(
            address(campfiresQuestRewards)
        );
    }

    function testSetCampfiresQuestRewardsShouldFailWhenAlreadySet() public {
        vm.expectRevert("campfiresQuestRewards already set");

        campfiresExperiencePoints.setCampfiresQuestRewards(
            address(campfiresQuestRewards)
        );
    }

    function testMintToShouldFailWhenCallerIsUnautohirzed() public {
        vm.prank(account);
        vm.expectRevert();

        campfiresExperiencePoints.mintTo(account, 10_000);
    }

    function testMintToShouldSucceedWhenCallerIsAuthorized() public {
        vm.prank(address(campfiresQuestRewards));
        campfiresExperiencePoints.mintTo(account, 10_000);

        assertEq(campfiresExperiencePoints.balanceOf(account), 10_000);
    }

    function testBurnShouldFailWhenCallerIsUnauthorized() public {
        vm.prank(address(campfiresQuestRewards));
        campfiresExperiencePoints.mintTo(account, 10_000);

        vm.prank(account);
        vm.expectRevert();

        campfiresExperiencePoints.burn(account, 5_000);
    }

    function testBurnSucceedsWhenCallerIsAuthorized() public {
        vm.prank(address(campfiresQuestRewards));
        campfiresExperiencePoints.mintTo(account, 10_000);
        assertEq(campfiresExperiencePoints.balanceOf(account), 10_000);

        vm.prank(address(campfiresQuestRewards));
        campfiresExperiencePoints.burn(account, 2_500);
        assertEq(campfiresExperiencePoints.balanceOf(account), 7_500);
    }
}
