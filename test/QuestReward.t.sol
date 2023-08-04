// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {ECDSA} from "openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {QuestReward} from "../src/QuestReward.sol";
import {ExperiencePoint} from "../src/ExperiencePoint.sol";

contract QuestRewardTest is Test {
    QuestReward public questReward;
    ExperiencePoint public experiencePoint;
    uint256 public verifierPrivateKey =
        0x1010101010101010101010101010101010101010101010101010101010101010;

    address public admin = address(5555);
    address public verifier;
    address public account = address(1);

    function setUp() public {
        verifier = vm.addr(verifierPrivateKey);

        experiencePoint = new ExperiencePoint();
        questReward = new QuestReward(verifier, address(experiencePoint));
        experiencePoint.setQuestReward(address(questReward));

        // create quest reward
        vm.prank(admin);
        questReward.createQuestRewardObject(
            "https://assets.campfires.gg/1.json", // uri
            5000, // price
            9000 // experiencePoints
        );
        (
            uint256 tokenId,
            string memory uri,
            ,
            address payable author,
            uint256 price,

        ) = questReward.questRewards(1);

        assertEq(tokenId, 1);
        assertEq(admin, author);
        assertEq(price, 5000);
        assertEq(uri, "https://assets.campfires.gg/1.json");
    }

    function testClaimQuestRewardShouldSucceedWhenCallerIsEligible() public {
        uint256 tokenId = 1;
        uint256 nonce = 599;

        // verifier signs when account requests in backend to claim reward
        bytes32 digest = ECDSA.toEthSignedMessageHash(
            keccak256(abi.encode(account, tokenId, nonce))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(verifierPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);

        vm.prank(account);
        console.log("account %s", account);
        console.log("questReward %s", address(questReward));

        questReward.claimQuestRewardObject(tokenId, nonce, signature);
        bool claimed = questReward.claimedQuestRewards(account, 1);

        assertEq(claimed, true);
        assertEq(questReward.balanceOf(account, 1), 1);
        assertEq(experiencePoint.balanceOf(account), 9000);
    }
}
