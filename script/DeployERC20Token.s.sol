// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { Script } from "forge-std/Script.sol";
import { ERC20Token } from "../src/ERC20Token.sol";

contract DeployERC20Token is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (ERC20Token) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        ERC20Token erc20Token = new ERC20Token(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return erc20Token;
    }
}