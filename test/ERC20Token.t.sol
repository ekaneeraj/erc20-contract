// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {DeployERC20Token} from "../script/DeployERC20Token.s.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

interface MintableToken {
    function mint(address, uint256) external;
}
contract ERC20TokenTest is Test {
    ERC20Token public erc20Token;
    DeployERC20Token public deployer;

    address public deployerAddress;
    address public bob;
    address public alice;
    
    uint256 public constant STARTING_AMOUNT = 100 ether;

    function setUp() public {
        deployer = new DeployERC20Token();
        erc20Token = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        erc20Token.transfer(bob, STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(erc20Token.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testBobBalance() public {
        assertEq(STARTING_AMOUNT, erc20Token.balanceOf(bob));
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(erc20Token)).mint(address(this), 1);
    }

    function testAllowances()  public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        erc20Token.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        erc20Token.transferFrom(bob, alice, transferAmount);

        assertEq(erc20Token.balanceOf(alice), transferAmount);
        assertEq(erc20Token.balanceOf(bob), STARTING_AMOUNT - transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 1000;
        address receiver = address(0x1)
        ;
        vm.prank(deployerAddress);
        erc20Token.transfer(receiver, transferAmount);
        assertEq(erc20Token.balanceOf(receiver), transferAmount);
    }

    function testBalanceAfterTransfer() public {
        uint256 transferAmount = 1000;
        address receiver = address(0x1);

        uint256 initialBalance = erc20Token.balanceOf(deployerAddress);
        
        vm.prank(deployerAddress);
        erc20Token.transfer(receiver, transferAmount);
        assertEq(
            erc20Token.balanceOf(deployerAddress),
            initialBalance - transferAmount
        );
    }

     function testTransferFrom() public {
        uint256 allowanceAmount = 1000;
        address receiver = address(0x1);

        vm.prank(deployerAddress);
        erc20Token.approve(address(this), allowanceAmount);
        erc20Token.transferFrom(deployerAddress, receiver, allowanceAmount);
        assertEq(erc20Token.balanceOf(receiver), allowanceAmount);
    }

}
