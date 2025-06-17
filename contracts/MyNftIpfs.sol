pragma solidity ^0.8.0;

contract MyNftIpfs {
    struct NFT {
        address owner;
        string ipfsHash;
    }

    NFT[] private nfts;
    mapping(address => uint256[]) private ownerToNFTs;

    function mint(string memory ipfsHash) public {
        uint256 newId = nfts.length;
        nfts.push(NFT(msg.sender, ipfsHash));
        ownerToNFTs[msg.sender].push(newId);
    }

    function transfer(address to, uint256 nftId) public {
        require(nfts[nftId].owner == msg.sender, "Not your NFT");
        nfts[nftId].owner = to;
    }

    function getNFT(uint256 id) public view returns (address owner, string memory ipfsHash) {
        NFT storage nft = nfts[id];
        return (nft.owner, nft.ipfsHash);
    }

    function getNFTsByOwner(address owner) public view returns (uint256[] memory) {
        return ownerToNFTs[owner];
    }
}