// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/**
 * @author Gabriel Egguiguren P.
 */
contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) s_tokenIdToUri;

    // creates the collection
    constructor() ERC721("Funny Tigers", "FTIG") {
        s_tokenCounter = 0;
    }

    // Creates a NFT with any provided URI
    function mintNft(string memory tokenUri) public {
        //asign the token URI to the list of tokens
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
