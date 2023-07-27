// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CampfiresExperiencePoint.sol";
import {CampfiresQuestReward} from "../src/CampfiresQuestReward.sol";

contract CampfiresExperiencePointTest is Test {
    CampfiresExperiencePoint public campfiresExperiencePoint;
    CampfiresQuestReward public campfiresQuestReward;
    address public account = address(55);

    function setUp() public {
        campfiresExperiencePoint = new CampfiresExperiencePoint();
        campfiresQuestReward = new CampfiresQuestReward(
            address(1337),
            address(campfiresExperiencePoint)
        );
        campfiresExperiencePoint.setCampfiresQuestReward(
            address(campfiresQuestReward)
        );
    }

    function testSetCampfiresQuestRewardShouldFailWhenAlreadySet() public {
        vm.expectRevert("campfiresQuestReward already set");

        campfiresExperiencePoint.setCampfiresQuestReward(
            address(campfiresQuestReward)
        );
    }

    function testMintToShouldFailWhenCallerIsUnautohirzed() public {
        vm.prank(account);
        vm.expectRevert();

        campfiresExperiencePoint.mintTo(account, 10_000);
    }

    function testMintToShouldSucceedWhenCallerIsAuthorized() public {
        vm.prank(address(campfiresQuestReward));
        campfiresExperiencePoint.mintTo(account, 10_000);

        assertEq(campfiresExperiencePoint.balanceOf(account), 10_000);
    }

    function testBurnShouldFailWhenCallerIsUnauthorized() public {
        vm.prank(address(campfiresQuestReward));
        campfiresExperiencePoint.mintTo(account, 10_000);

        vm.prank(account);
        vm.expectRevert();

        campfiresExperiencePoint.burn(account, 5_000);
    }

    function testBurnSucceedsWhenCallerIsAuthorized() public {
        vm.prank(address(campfiresQuestReward));
        campfiresExperiencePoint.mintTo(account, 10_000);
        assertEq(campfiresExperiencePoint.balanceOf(account), 10_000);

        vm.prank(address(campfiresQuestReward));
        campfiresExperiencePoint.burn(account, 2_500);
        assertEq(campfiresExperiencePoint.balanceOf(account), 7_500);
    }
}
