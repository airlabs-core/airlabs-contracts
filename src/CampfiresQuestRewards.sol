// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

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

    /* ---------------------------------------- */
    /*                PROPERTIES                */
    /* ---------------------------------------- */
    mapping(uint256 => QuestReward) public questRewards;

    /// @notice The next token ID to be minted.
    uint256 private _currentIndex;

    string private _baseURI;

    /* ---------------------------------------- */
    /*                  EVENTS                  */
    /* ---------------------------------------- */
    event CreateQuest(
        uint256 indexed tokenId,
        string indexed tokenURI,
        address indexed author,
        uint256 price
    );
    event MintQuest();

    constructor(string memory baseURI) ERC1155("") {
        _currentIndex = 1;
        _baseURI = baseURI;
    }

    /* ---------------------------------------- */
    /*             PUBLIC FUNCTIONS             */
    /* ---------------------------------------- */
    function uri(
        string calldata id
    ) public view virtual returns (string memory) {
        return string(abi.encodePacked(_baseURI, id));
    }

    function createQuest(string calldata tokenURI, uint256 price) external {
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

    function mintQuest(uint256 id) external {
        _mint(_msgSender(), id, 1, "0x00");
        emit MintQuest();
    }
}
