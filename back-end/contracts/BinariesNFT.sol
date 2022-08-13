// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error BinariesNFT__ExceededMaximumPerWallet();
error BinariesNFT__MintingNotEnabled();
error BinariesNFT__SoldOut();
error BinariesNFT__TokenDoesNotExists();
error BinariesNFT__WithdrawFailed();
error BinariesNFT__WrongValue();

/// @title Binaries NFT
/// @author mektigboy
/// @notice The purpose of this contract is to mint NFTs from the "BinariesNFT" collection.
/// @dev This contracts uses libraries from OpenZeppelin.
contract BinariesNFT is ERC721, Ownable {
    address payable public withdrawAddress;
    bool public isPublicMintEnabled;
    string internal baseTokenURI;
    uint256 public totalSupply;
    uint256 public maximumPerWallet;
    uint256 public maximumSupply;
    uint256 public mintPrice;

    mapping(address => uint256) public tracker;

    constructor() payable ERC721("BinariesNFT", "B01") {
        withdrawAddress = payable(0xa7a0275220A00ae3B360F7cB080069063e886271);
        totalSupply = 0;
        maximumPerWallet = 5;
        maximumSupply = 1000;
        mintPrice = 0.01 ether;
    }

    function setBaseTokenURI(string calldata baseTokenURI_) external onlyOwner {
        baseTokenURI = baseTokenURI_;
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_)
        external
        onlyOwner
    {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function mint(uint256 quantity_) public payable {
        if (!isPublicMintEnabled) revert BinariesNFT__MintingNotEnabled();
        if (msg.value != quantity_ * mintPrice)
            revert BinariesNFT__WrongValue();
        if (maximumSupply <= quantity_ + totalSupply)
            revert BinariesNFT__SoldOut();
        if (maximumPerWallet <= quantity_ + tracker[msg.sender])
            revert BinariesNFT__ExceededMaximumPerWallet();
        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }

    function tokenURI(uint256 tokenId_)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId_)) revert BinariesNFT__TokenDoesNotExists();
        return
            string(
                abi.encodePacked(
                    baseTokenURI,
                    Strings.toString(tokenId_),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawAddress.call{value: address(this).balance}(
            ""
        );
        if (!success) revert BinariesNFT__WithdrawFailed();
    }
}
