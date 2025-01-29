const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("IoTDeviceNFT", () => {
  let nft, deployer, minter;

  before(async () => {
    [deployer, minter] = await ethers.getSigners();
    const NFT = await ethers.getContractFactory("IoTDeviceNFT");
    nft = await NFT.deploy("ipfs://");
    await nft.grantRole(await nft.MINTER_ROLE(), minter.address);
  });

  it("Should mint with valid parameters", async () => {
    await nft.connect(minter).mintDeviceNFT(
      deployer.address,
      "device-1",
      "txn-001",
      "QmXYZ1234567890123456789012345678901234567890",
      ethers.utils.formatBytes32String("hash1")
    );
    
    const data = await nft.getDeviceData(1);
    expect(data.version).to.equal(1);
  });
});