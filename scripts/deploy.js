const { ethers } = require("hardhat");

async function main() {
  const CONTRACT_ADDRESS = "0xYourContractAddress";
  const contract = await ethers.getContractAt("IoTDeviceNFT", CONTRACT_ADDRESS);
  
  // Example: Grant MINTER_ROLE to another address
  const [admin] = await ethers.getSigners();
  const newMinter = "0xAddressToGrantRole";
  
  await contract.grantRole(
    await contract.MINTER_ROLE(),
    newMinter
  );
  console.log(`Granted MINTER_ROLE to ${newMinter}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });