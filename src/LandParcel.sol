// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "erc721a/ERC721A.sol";
import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IERC6551Account} from "erc6551/interfaces/IERC6551Account.sol";
import {IERC6551Registry} from "erc6551/ERC6551Registry.sol";
import {Account} from "tokenbound/Account.sol";
import {IExperiencePoint} from "./interfaces/IExperiencePoint.sol";
import {IStakingRewards} from "./interfaces/IStakingRewards.sol";

/// @title LandParcel
/// @author Carlo Miguel Dy
contract LandParcel is ERC721A, AccessControl {
    bytes32 public constant EXPERIENCE_POINT_ROLE =
        keccak256("EXPERIENCE_POINT_ROLE");

    IERC6551Account public erc6551Implementation;
    IERC6551Registry public erc6551Registry;
    IExperiencePoint public experiencePoint;
    IStakingRewards public stakingRewards;

    /// @notice The required $EXP tokens to have in balance to claim a land parcel.
    uint256 public constant CLAIM_COST = 20_000;

    event Claim(
        address indexed owner,
        address indexed accountAddress,
        uint256 indexed tokenId
    );
    event StakeExperiencePoints(
        uint256 indexed tokenId,
        uint256 indexed amount,
        address indexed account
    );

    constructor(
        address _experiencePoint,
        address _erc6551Implementation,
        address _erc6551Registry,
        address _stakingRewards
    ) ERC721A("Land Parcel", "LP") {
        require(_experiencePoint != address(0), "_experiencePoint empty addr");
        require(
            _erc6551Implementation != address(0),
            "_erc6551Implementation empty addr"
        );
        require(_erc6551Registry != address(0), "_erc6551Registry empty addr");
        require(_stakingRewards != address(0), "_stakingRewards empty addr");

        erc6551Implementation = IERC6551Account(
            payable(_erc6551Implementation)
        );
        erc6551Registry = IERC6551Registry(_erc6551Registry);
        experiencePoint = IExperiencePoint(_experiencePoint);
        stakingRewards = IStakingRewards(_stakingRewards);

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

    /**
     * @notice Burns the required amount of $EXP tokens to mint a land parcel.
     */
    function claim()
        external
        returns (uint256 tokenId, address accountAddress)
    {
        require(
            experiencePoint.balanceOf(_msgSender()) >= CLAIM_COST,
            "not enough points to claim"
        );

        tokenId = _nextTokenId();
        experiencePoint.burn(_msgSender(), CLAIM_COST);
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

    /**
     * @notice Stake $EXP tokens using token bound account.
     * @param _tokenId uint256 : The tokenId of a token bound account.
     * @param _amount uint256 : The amount of $EXP tokens to be staked.
     */
    function stakeExperiencePoints(uint256 _tokenId, uint256 _amount) external {
        address accountAddress = getAccount(_tokenId);
        Account account = Account(payable(accountAddress));
        require(account.isAuthorized(_msgSender()), "caller not authorized");

        bytes memory stakeCall = abi.encodeWithSignature(
            "stake(uint256)",
            _amount
        );
        account.executeCall(payable(address(stakingRewards)), 0, stakeCall);
        emit StakeExperiencePoints(_tokenId, _amount, accountAddress);
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
