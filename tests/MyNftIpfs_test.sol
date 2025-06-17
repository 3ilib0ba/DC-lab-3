// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/MyNftIpfs.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    MyNftIpfs nftContract;
    address user1 = address(0x123);
    address user2 = address(0x456);
    string constant testHash1 = "TEST HASH 1";
    string constant testHash2 = "TEST HASH 1";

    function beforeAll() public {
        nftContract = new MyNftIpfs();
    }

    function testMint() public {
        nftContract.mint(testHash1);
        (address owner, string memory ipfsHash) = nftContract.getNFT(0);
        Assert.equal(owner, address(this), "Owner should be set correct after mint");
        Assert.equal(ipfsHash, testHash1, "IPFS hash should match after mint");
    }

    function testTransfer() public {
        nftContract.mint(testHash2);

        nftContract.transfer(user1, 0);
        (address owner, string memory ipfsHash) = nftContract.getNFT(0);

        Assert.equal(owner, user1, "NFT should be transferred to user1");
        Assert.equal(ipfsHash, testHash2, "IPFS hash should match after mint");
        
        try nftContract.transfer(user2, 0) {
            Assert.ok(false, "Should be error of owner permission");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Not your NFT", "Should fail with 'Not your NFT'");
        }
    }
}
    