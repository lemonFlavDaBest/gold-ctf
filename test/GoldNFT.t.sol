// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/GoldNFT.sol";
import "../src/HackGoldNft.sol";

contract Hack is Test {
    GoldNFT nft;
    HackGoldNft nftHack;
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() external {
        vm.createSelectFork("goerli", 8591866); 
        nft = new GoldNFT();
    }

    function test_Attack() public {
        vm.startPrank(hacker);
        bytes memory codeG = vm.getDeployedCode("GoldNFT.sol:GoldNFT.0.8.7");
        //bytes memory codeP = vm.getDeployedCode("GoldNFT.sol:IPassManager.0.8.7");
        console.logBytes(codeG);
        //console.logBytes(codeP);
        // solution
        assertEq(nft.balanceOf(hacker), 10);
    }
}