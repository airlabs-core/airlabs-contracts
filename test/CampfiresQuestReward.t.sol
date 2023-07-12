// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/CampfiresQuestReward.sol";
import "../src/CampfiresExperiencePoint.sol";

contract CampfiresQuestRewardTest is Test {
    CampfiresQuestReward public campfiresQuestReward;
    CampfiresExperiencePoint public campfiresExperiencePoint;
    uint256 public verifierPrivateKey =
        0x1010101010101010101010101010101010101010101010101010101010101010;

    address public admin = address(5555);
    address public verifier;
    address public account = address(1);

    function setUp() public {
        verifier = vm.addr(verifierPrivateKey);

        campfiresExperiencePoint = new CampfiresExperiencePoint();
        campfiresQuestReward = new CampfiresQuestReward(
            verifier,
            address(campfiresExperiencePoint)
        );
        campfiresExperiencePoint.setCampfiresQuestReward(
            address(campfiresQuestReward)
        );

        // create quest reward
        vm.prank(admin);
        campfiresQuestReward.createQuestReward(
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

        ) = campfiresQuestReward.questRewards(1);

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
        console.log("campfiresQuestReward %s", address(campfiresQuestReward));

        campfiresQuestReward.claimQuestReward(tokenId, nonce, signature);
        bool claimed = campfiresQuestReward.claimedQuestRewards(account, 1);

        assertEq(claimed, true);
        assertEq(campfiresQuestReward.balanceOf(account, 1), 1);
        assertEq(campfiresExperiencePoint.balanceOf(account), 9000);
    }
}
