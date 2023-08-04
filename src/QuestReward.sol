// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import "./interfaces/IExperiencePoint.sol";

/// @title QuestReward
/// @author Carlo Miguel Dy
contract QuestReward is ERC1155 {
    /* ---------------------------------------- */
    /*                 STRUCTS                  */
    /* ---------------------------------------- */
    struct QuestRewardObject {
        uint256 tokenId;
        string uri;
        uint256 maxClaimed; // TODO: Will probably remove
        address payable author;
        uint256 price; // ? Price is for what?
        uint256 experiencePoints;
    }
    /* -----------------*****------------------ */

    /* ---------------------------------------- */
    /*                  ERRORS                  */
    /* ---------------------------------------- */
    error InvalidTokenID();
    /* -----------------*****------------------ */

    /* ---------------------------------------- */
    /*                PROPERTIES                */
    /* ---------------------------------------- */
    /// @notice Contract address for experience points.
    address public experiencePoint;

    /// @notice Signature verifier.
    address public verifier;

    /// @notice Stores all created quest rewards.
    mapping(uint256 => QuestRewardObject) public questRewards;

    /// @notice Records claimed quest rewards for an account.
    mapping(address => mapping(uint256 => bool)) public claimedQuestRewards;

    /// @notice The next token ID to be minted.
    uint256 private _currentIndex;

    /* -----------------*****------------------ */

    /* ---------------------------------------- */
    /*                  EVENTS                  */
    /* ---------------------------------------- */
    event CreateQuestObject(
        uint256 indexed tokenId,
        string indexed tokenURI,
        address indexed author,
        uint256 price
    );
    event ClaimQuestRewardObject();

    /* -----------------*****------------------ */

    constructor(address _verifier, address _experiencePoint) ERC1155("") {
        require(_verifier != address(0), "_verifier empty addr");
        require(_experiencePoint != address(0), "_experiencePoint empty addr");

        _currentIndex = 1;
        verifier = _verifier;
        experiencePoint = _experiencePoint;
    }

    /* ---------------------------------------- */
    /*             PUBLIC FUNCTIONS             */
    /* ---------------------------------------- */
    function uri(
        uint256 id
    ) public view virtual override returns (string memory) {
        return string(abi.encodePacked(questRewards[id].uri, id));
    }

    // ? Should anyone be allowed to set arbitrary value for experience points of a quest reward?
    function createQuestRewardObject(
        string calldata tokenURI,
        uint256 price,
        uint256 experiencePoints
    ) external {
        questRewards[_currentIndex] = QuestRewardObject(
            _currentIndex,
            tokenURI,
            0,
            payable(_msgSender()),
            price,
            experiencePoints
        );
        emit CreateQuestObject(_currentIndex, tokenURI, _msgSender(), price);
        _currentIndex++;
    }

    function claimQuestRewardObject(
        uint256 id,
        uint256 nonce,
        bytes calldata signature
    ) external {
        if (questRewards[id].tokenId == 0) revert InvalidTokenID();

        address recovered = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(
                keccak256(abi.encode(_msgSender(), id, nonce))
            ),
            signature
        );
        require(
            recovered == verifier,
            "recovered addr does not match verifier"
        );

        _mint(_msgSender(), id, 1, signature);
        IExperiencePoint(experiencePoint).mintTo(
            _msgSender(),
            questRewards[id].experiencePoints
        );
        claimedQuestRewards[_msgSender()][id] = true;

        emit ClaimQuestRewardObject();
    }
    /* -----------------*****------------------ */
}
