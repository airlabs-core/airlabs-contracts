// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract CampfiresQuestRewards is ERC1155 {
    /* ---------------------------------------- */
    /*                 STRUCTS                  */
    /* ---------------------------------------- */
    struct QuestReward {
        uint256 tokenId;
        string uri;
        uint256 maxClaimed;
        address payable author;
        uint256 price;
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
    /// @notice Signature verifier.
    address public verifier;

    /// @notice Stores all created quest rewards.
    mapping(uint256 => QuestReward) public questRewards;

    /// @notice Records claimed quest rewards for an account.
    mapping(address => mapping(uint256 => bool)) public claimedQuestRewards;

    /// @notice The next token ID to be minted.
    uint256 private _currentIndex;

    /* -----------------*****------------------ */

    /* ---------------------------------------- */
    /*                  EVENTS                  */
    /* ---------------------------------------- */
    event CreateQuest(
        uint256 indexed tokenId,
        string indexed tokenURI,
        address indexed author,
        uint256 price
    );
    event ClaimQuestReward();

    /* -----------------*****------------------ */

    constructor(address _verifier) ERC1155("") {
        require(_verifier != address(0), "empty verifier address");
        _currentIndex = 1;
        verifier = _verifier;
    }

    /* ---------------------------------------- */
    /*             PUBLIC FUNCTIONS             */
    /* ---------------------------------------- */
    function uri(
        uint256 id
    ) public view virtual override returns (string memory) {
        return string(abi.encodePacked(questRewards[id].uri, id));
    }

    function createQuestReward(
        string calldata tokenURI,
        uint256 price
    ) external {
        questRewards[_currentIndex] = QuestReward(
            _currentIndex,
            tokenURI,
            0,
            payable(_msgSender()),
            price
        );
        emit CreateQuest(_currentIndex, tokenURI, _msgSender(), price);
        _currentIndex++;
    }

    function claimQuestReward(
        uint256 id,
        uint256 nonce,
        bytes calldata signature
    ) external {
        address recovered = ECDSA.recover(
            keccak256(abi.encodePacked(_msgSender(), id, nonce)),
            signature
        );
        require(recovered == verifier);

        if (questRewards[id].tokenId == 0) revert InvalidTokenID();

        _mint(_msgSender(), id, 1, "0x00");
        claimedQuestRewards[_msgSender()][id] = true;

        emit ClaimQuestReward();
    }
    /* -----------------*****------------------ */
}
