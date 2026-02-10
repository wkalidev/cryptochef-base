// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoChefNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    
    struct Recipe {
        string ipfsHash;
        address chef;
        uint256 timestamp;
        uint256 votes;
    }
    
    mapping(uint256 => Recipe) public recipes;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    
    event RecipeMinted(uint256 indexed tokenId, address indexed chef, string ipfsHash);
    event RecipeVoted(uint256 indexed tokenId, address indexed voter);
    
    constructor() ERC721("CryptoChef Recipe", "CHEF") Ownable(msg.sender) {}
    
    function mintRecipe(string memory ipfsHash) public returns (uint256) {
        uint256 tokenId = _tokenIdCounter++;
        _safeMint(msg.sender, tokenId);
        
        recipes[tokenId] = Recipe({
            ipfsHash: ipfsHash,
            chef: msg.sender,
            timestamp: block.timestamp,
            votes: 0
        });
        
        emit RecipeMinted(tokenId, msg.sender, ipfsHash);
        return tokenId;
    }
    
    function voteRecipe(uint256 tokenId) public {
        require(_ownerOf(tokenId) != address(0), "Recipe does not exist");
        require(!hasVoted[msg.sender][tokenId], "Already voted");
        
        recipes[tokenId].votes++;
        hasVoted[msg.sender][tokenId] = true;
        
        emit RecipeVoted(tokenId, msg.sender);
    }
    
    function getRecipe(uint256 tokenId) public view returns (Recipe memory) {
        require(_ownerOf(tokenId) != address(0), "Recipe does not exist");
        return recipes[tokenId];
    }
}
