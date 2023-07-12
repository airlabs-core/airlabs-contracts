// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICampfiresExperiencePoints is IERC20 {
    function mintTo(address _to, uint256 _amount) external;

    function burn(address account, uint256 amount) external;
}
