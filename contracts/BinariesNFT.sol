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
/// @notice Mint NFTs from the "BinariesNFT" collection.
/// @dev Uses libraries from OpenZeppelin.
contract BinariesNFT is ERC721, Ownable {
    address payable public s_withdrawalAddress;
    bool public s_isPublicMintEnabled;
    uint256 public s_tokenCounter;

    string public constant TOKEN_URI =
        "ipfs://bafkreidiszt2rp5unghfq3xfdagqcl7b6z2yc4ef6bmkbqbrqrcvoahnby";
    uint256 public constant MAXIMUM_PER_WALLET = 5;
    uint256 public constant MAXIMUM_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.01 ether;

    mapping(address => uint256) public s_tracker;

    constructor() payable ERC721("BinariesNFT", "B01") {
        s_withdrawalAddress = payable(
            0xa7a0275220A00ae3B360F7cB080069063e886271
        );
        s_tokenCounter = 0;
    }

    function mintNFT(uint256 quantity) public payable {
        if (!s_isPublicMintEnabled) revert BinariesNFT__MintingNotEnabled();
        if (msg.value != quantity * MINT_PRICE)
            revert BinariesNFT__WrongValue();
        if (MAXIMUM_SUPPLY <= quantity + s_tokenCounter)
            revert BinariesNFT__SoldOut();
        if (MAXIMUM_PER_WALLET <= quantity + s_tracker[msg.sender])
            revert BinariesNFT__ExceededMaximumPerWallet();
        for (uint256 i = 0; i < quantity; i++) {
            uint256 newTokenId = s_tokenCounter + 1;
            s_tokenCounter++;
            _safeMint(msg.sender, newTokenId);
        }
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled)
        external
        onlyOwner
    {
        s_isPublicMintEnabled = isPublicMintEnabled;
    }

    function setWithdrawalAddress(address payable withdrawalAddress)
        external
        onlyOwner
    {
        s_withdrawalAddress = withdrawalAddress;
    }

    function tokenURI(
        uint256 /* tokenId */
    ) public pure override returns (string memory) {
        return TOKEN_URI;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = s_withdrawalAddress.call{
            value: address(this).balance
        }("");
        if (!success) revert BinariesNFT__WithdrawFailed();
    }
}
