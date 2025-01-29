const { ethers } = require("hardhat");

async function main() {
  const baseURI = "ipfs://"; // Customize this
  const [deployer] = await ethers.getSigners();
  
  console.log("Deploying contract with account:", deployer.address);
  
  const NFT = await ethers.getContractFactory("IoTDeviceNFT");
  const nft = await NFT.deploy(baseURI);
  
  await nft.deployed();
  console.log("Contract deployed to:", nft.address);
  
  // Assign roles (optional)
  // await nft.grantRole(await nft.MINTER_ROLE(), minterAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});