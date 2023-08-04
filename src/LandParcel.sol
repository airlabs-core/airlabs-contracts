// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/ERC721A.sol";
import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IERC6551Account} from "erc6551/interfaces/IERC6551Account.sol";
import {IERC6551Registry} from "erc6551/ERC6551Registry.sol";
import {IExperiencePoint} from "./interfaces/IExperiencePoint.sol";

/// @title LandParcel
/// @author Carlo Miguel Dy
contract LandParcel is ERC721A, AccessControl {
    bytes32 public constant EXPERIENCE_POINT_ROLE =
        keccak256("EXPERIENCE_POINT_ROLE");

    IERC6551Account public erc6551Implementation;
    IERC6551Registry public erc6551Registry;
    IExperiencePoint public experiencePoint;

    event Claim(
        address indexed owner,
        address indexed accountAddress,
        uint256 indexed tokenId
    );

    constructor(
        address _experiencePoint,
        address _erc6551Implementation,
        address _erc6551Registry
    ) ERC721A("Land Parcel", "LP") {
        require(_experiencePoint != address(0), "_experiencePoint empty addr");

        erc6551Implementation = IERC6551Account(
            payable(_erc6551Implementation)
        );
        erc6551Registry = IERC6551Registry(_erc6551Registry);
        experiencePoint = IExperiencePoint(_experiencePoint);

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(EXPERIENCE_POINT_ROLE, _experiencePoint);
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

        tokenId = _nextTokenId();
        _mint(_msgSender(), 1);

        accountAddress = erc6551Registry.createAccount(
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
