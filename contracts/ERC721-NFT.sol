// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol";


contract VirtualRealityBoyNFTs is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, ERC2981 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public MAX_SUPPLY = 10;
    uint256 public MINT_PRICE = 0.025 ether;
    uint256 public MAX_MINT_AMOUNT = 1;
    string baseURI;
    //baseURI = "ipfs://QmXvtwWe6yZPmH4sBaYv2rVC3voWMy2PfsbqeD9ytMmYzz/";
    //mint price = "25000000000000000" wei

     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    constructor() ERC721("Testing VR NFT", "TVRNFT") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //set new baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

 

    function safeMint(address to) public payable{
        require(totalSupply() < MAX_SUPPLY, "Can't mint this NFT anymore");
        require(msg.value >= MINT_PRICE, "Ether is not enough to send");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
    }

    function mintWithRoyalty(address receiver, address royaltyFeeReceiver, uint96 royaltyFee) public payable{
        require(totalSupply() < MAX_SUPPLY, "Can't mint this NFT anymore");
        require(msg.value >= MINT_PRICE, "Ether is not enough to send");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(receiver, tokenId);
        _setTokenRoyalty(tokenId, royaltyFeeReceiver, royaltyFee);
    }

    //function withdraw
    function withdraw() public onlyOwner{
        require(address(this).balance > 0, "Your balance is zero");
        payable(owner()).transfer(address(this).balance);
    }

    //wallet
    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
        tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
    
    //set the mint price of an NFT
    function setPrice(uint256 _newPrice) public onlyOwner {
        MINT_PRICE = _newPrice;
    }

    //set the max total supply
    function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
        MAX_SUPPLY = _newMaxSupply;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }


    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    


    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    
}
