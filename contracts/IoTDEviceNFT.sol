// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.3/access/AccessControl.sol";
import "@openzeppelin/contracts@4.9.3/utils/Counters.sol";

contract IoTDeviceNFT is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    struct DeviceData {
        string deviceId;
        string transactionId;
        string ipfsCID;
        bytes32 dataHash;
        uint256 version;
    }

    event DeviceMinted(
        uint256 indexed tokenId,
        string deviceId,
        string transactionId,
        string ipfsCID,
        bytes32 dataHash
    );

    event DeviceDataUpdated(
        uint256 indexed tokenId,
        string oldIpfsCID,
        bytes32 oldDataHash,
        string newIpfsCID,
        bytes32 newDataHash,
        uint256 newVersion
    );

    mapping(uint256 => DeviceData) private _tokenData;
    mapping(string => bool) private _usedTransactionIds;
    string private _baseTokenURI;

    constructor(string memory baseURI) ERC721("IoTDevice", "IOT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _baseTokenURI = baseURI;
    }

    function mintDeviceNFT(
        address to,
        string memory deviceId,
        string memory transactionId,
        string memory ipfsCID,
        bytes32 dataHash
    ) external onlyRole(MINTER_ROLE) returns (uint256) {
        require(!_usedTransactionIds[transactionId], "Transaction ID already used");
        require(bytes(transactionId).length > 0, "Invalid transaction ID");
        require(bytes(deviceId).length > 0, "Invalid device ID");
        require(bytes(ipfsCID).length == 46, "Invalid IPFS CID"); // CIDv0 format check
        require(dataHash != bytes32(0), "Invalid data hash");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, string.concat(_baseTokenURI, ipfsCID));
        
        _tokenData[newTokenId] = DeviceData(deviceId, transactionId, ipfsCID, dataHash, 1);
        _usedTransactionIds[transactionId] = true;

        emit DeviceMinted(newTokenId, deviceId, transactionId, ipfsCID, dataHash);
        return newTokenId;
    }

    function updateDeviceData(
        uint256 tokenId,
        string memory newIpfsCID,
        bytes32 newDataHash
    ) external onlyRole(MINTER_ROLE) {
        require(_exists(tokenId), "Token doesn't exist");
        require(bytes(newIpfsCID).length == 46, "Invalid IPFS CID");
        require(newDataHash != bytes32(0), "Invalid data hash");

        DeviceData storage data = _tokenData[tokenId];
        string memory oldIpfsCID = data.ipfsCID;
        bytes32 oldDataHash = data.dataHash;

        data.ipfsCID = newIpfsCID;
        data.dataHash = newDataHash;
        data.version += 1;
        
        _setTokenURI(tokenId, string.concat(_baseTokenURI, newIpfsCID));
        emit DeviceDataUpdated(
            tokenId,
            oldIpfsCID,
            oldDataHash,
            newIpfsCID,
            newDataHash,
            data.version
        );
    }

    function verifyData(uint256 tokenId, bytes32 proposedHash) external view returns (bool) {
        require(_exists(tokenId), "Token doesn't exist");
        return _tokenData[tokenId].dataHash == proposedHash;
    }

    function getDeviceData(uint256 tokenId) external view returns (
        string memory deviceId,
        string memory transactionId,
        string memory ipfsCID,
        bytes32 dataHash,
        uint256 version
    ) {
        require(_exists(tokenId), "Token doesn't exist");
        DeviceData memory data = _tokenData[tokenId];
        return (data.deviceId, data.transactionId, data.ipfsCID, data.dataHash, data.version);
    }

    function setBaseURI(string memory baseURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _baseTokenURI = baseURI;
    }

    // Add support for both ERC721 and AccessControl interfaces
    function supportsInterface(bytes4 interfaceId) public view override(ERC721URIStorage, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
