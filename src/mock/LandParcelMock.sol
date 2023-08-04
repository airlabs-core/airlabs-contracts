// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../LandParcel.sol";

contract LandParcelMock is LandParcel {
    constructor(
        address _experiencePoint,
        address _erc6551Implementation,
        address _erc6551Registry,
        address _stakingRewards
    )
        LandParcel(
            _experiencePoint,
            _erc6551Implementation,
            _erc6551Registry,
            _stakingRewards
        )
    {}

    function mint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }
}
