// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ExperiencePoint.sol";
import {QuestReward} from "../src/QuestReward.sol";

contract ExperiencePointTest is Test {
    ExperiencePoint public experiencePoint;
    QuestReward public questReward;
    address public account = address(55);

    function setUp() public {
        experiencePoint = new ExperiencePoint();
        questReward = new QuestReward(address(1337), address(experiencePoint));
        experiencePoint.setQuestReward(address(questReward));
    }

    function testSetQuestRewardShouldFailWhenAlreadySet() public {
        vm.expectRevert("questReward already set");

        experiencePoint.setQuestReward(address(questReward));
    }

    function testMintToShouldFailWhenCallerIsUnautohirzed() public {
        vm.prank(account);
        vm.expectRevert();

        experiencePoint.mintTo(account, 10_000);
    }

    function testMintToShouldSucceedWhenCallerIsAuthorized() public {
        vm.prank(address(questReward));
        experiencePoint.mintTo(account, 10_000);

        assertEq(experiencePoint.balanceOf(account), 10_000);
    }

    function testBurnShouldFailWhenCallerIsUnauthorized() public {
        vm.prank(address(questReward));
        experiencePoint.mintTo(account, 10_000);

        vm.prank(account);
        vm.expectRevert();

        experiencePoint.burn(account, 5_000);
    }

    function testBurnSucceedsWhenCallerIsAuthorized() public {
        vm.prank(address(questReward));
        experiencePoint.mintTo(account, 10_000);
        assertEq(experiencePoint.balanceOf(account), 10_000);

        vm.prank(address(questReward));
        experiencePoint.burn(account, 2_500);
        assertEq(experiencePoint.balanceOf(account), 7_500);
    }
}
