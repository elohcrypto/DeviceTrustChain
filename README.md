# DeviceTrustChain  
**Secure IoT Data Trust Framework**  
*Linking IoT Device Data to Versioned NFTs with Private IPFS Storage and On-Chain Integrity Verification*  

---

## 📜 Overview  
This project establishes a trustless framework where IoT device data is:  
1. Stored off-chain on a **self-hosted private IPFS** network.  
2. Linked to versioned ERC721 NFTs (one per transaction) with on-chain integrity proofs.  
3. Verifiable by third parties via cryptographic hashes.  

**Key Innovation**: Allows multiple entries (NFTs) per `deviceId` while enforcing uniqueness via `transactionId`.  

---

## 🚀 Core Features  

### **1. NFT Management**  
- **ERC721 NFTs**: Each represents a unique IoT data transaction.  
- **Versioned Metadata**:  
  - `deviceId`: IoT device identifier (non-unique).  
  - `transactionId`: Unique identifier for the data transaction.  
  - `ipfsCID`: Private IPFS Content Identifier for JSON data.  
  - `dataHash`: SHA-256 hash of the JSON data.  
  - `version`: Tracks updates to the same token.  

### **2. Security & Access**  
- **Role-Based Access Control**: Restrict minting/updates to authorized roles.  
- **Private IPFS**: Self-hosted cluster with swarm keys and access controls.  
- **Tamper-Proof Verification**: On-chain hash comparison for data integrity.  

### **3. Workflow Automation**  
- **Minting & Updates**: Scripts for NFT creation and metadata versioning.  
- **Event Logging**: `DeviceMinted` and `DeviceDataUpdated` for off-chain tracking.  

---

## 📦 Smart Contract  

### **Contract**: [`IoTDeviceNFT.sol`](./contracts/IoTDeviceNFT.sol)  
**Tech Stack**:  
- Solidity `^0.8.19`  
- OpenZeppelin (`ERC721URIStorage`, `AccessControl`, `Counters`)  

#### **Key Functions**:  
| Function                | Description                                  | Access Control       |  
|-------------------------|----------------------------------------------|----------------------|  
| `mintDeviceNFT()`       | Mints NFT with `deviceId`, `transactionId`, and hashes. | `MINTER_ROLE` |  
| `updateDeviceData()`    | Updates IPFS CID and hash for a token.       | `MINTER_ROLE` |  
| `verifyData()`          | Returns `true` if proposed hash matches stored hash. | Public |  

#### **Snippet**:  
```solidity
function mintDeviceNFT(
    address to,
    string memory deviceId,
    string memory transactionId,
    string memory ipfsCID,
    bytes32 dataHash
) external onlyRole(MINTER_ROLE) {
    require(!_usedTransactionIds[transactionId], "Duplicate transactionId");
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    _tokenData[newTokenId] = DeviceData(deviceId, transactionId, ipfsCID, dataHash, 1);
    _usedTransactionIds[transactionId] = true;
    emit DeviceMinted(newTokenId, deviceId, transactionId, ipfsCID, dataHash);
}
