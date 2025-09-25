// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/**
 * @author Gabriel Egguiguren P.
 * @title BasicNft
 * @notice This contract is for creating a basic NFT with a provided URI.
 */
contract BasicNft is ERC721 {
    // State Variables
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    // Events
    event NftMinted(uint256 indexed tokenId);

    /**
     * @notice Initializes the contract, setting the name and symbol of the NFT collection.
     */
    constructor() ERC721("Funny Tigers", "FTIG") {
        s_tokenCounter = 0;
    }

    /**
     * @notice Mints a new NFT and assigns it to the caller.
     * @param tokenUri The URI for the NFT's metadata.
     */
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        emit NftMinted(s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
