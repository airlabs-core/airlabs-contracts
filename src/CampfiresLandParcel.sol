// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/ERC721A.sol";
import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IERC6551Account} from "erc6551/interfaces/IERC6551Account.sol";
import {IERC6551Registry} from "erc6551/ERC6551Registry.sol";
import {ICampfiresExperiencePoint} from "./interfaces/ICampfiresExperiencePoint.sol";

/// @title CampfiresLandParcel
/// @author Carlo Miguel Dy
contract CampfiresLandParcel is ERC721A, AccessControl {
    bytes32 public constant CAMPFIRES_EXPERIENCE_POINT_ROLE =
        keccak256("CAMPFIRES_EXPERIENCE_POINT_ROLE");

    IERC6551Account public erc6551Implementation;
    IERC6551Registry public erc6551Registry;
    ICampfiresExperiencePoint public experiencePoint;

    event SetCampfiresExperiencePoint(address indexed campfiresExperiencePoint);
    event Claim(
        address indexed owner,
        address indexed accountAddress,
        uint256 indexed tokenId
    );

    constructor(
        address _experiencePoint,
        address _erc6551Implementation,
        address _erc6551Registry
    ) ERC721A("Campfires Land Parcel", "CLP") {
        require(_experiencePoint != address(0), "_experiencePoint empty addr");

        erc6551Implementation = IERC6551Account(
            payable(_erc6551Implementation)
        );
        erc6551Registry = IERC6551Registry(_erc6551Registry);
        experiencePoint = ICampfiresExperiencePoint(_experiencePoint);

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(CAMPFIRES_EXPERIENCE_POINT_ROLE, _experiencePoint);
    }

    function getAccount(uint256 tokenId) public view returns (address) {
        return
            erc6551Registry.account(
                address(erc6551Implementation),
                block.chainid,
                address(this),
                tokenId,
                0
            );
    }

    function claim()
        external
        returns (uint256 tokenId, address accountAddress)
    {
        require(
            experiencePoint.balanceOf(_msgSender()) >= 20_000,
            "not enough points to claim"
        );

        uint256 tokenId = _nextTokenId();
        _mint(_msgSender(), 1);

        address accountAddress = erc6551Registry.createAccount(
            address(erc6551Implementation),
            block.chainid,
            address(this),
            tokenId,
            0,
            ""
        );

        emit Claim(_msgSender(), accountAddress, tokenId);
        return (tokenId, accountAddress);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(AccessControl, ERC721A) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ERC721A-_startTokenId}.
     */
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }
}
