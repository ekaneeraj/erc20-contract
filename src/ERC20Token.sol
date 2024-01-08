// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor(uint256 _initialSupply) ERC20("ERC20Token", "ETK") {
        _mint(msg.sender, _initialSupply);
    }
}