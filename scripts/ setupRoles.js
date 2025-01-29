// scripts/setupRoles.js
const { ethers } = require("hardhat");

async function main() {
  // Configure these values
  const CONTRACT_ADDRESS = "0xYourDeployedContractAddress";
  const MINTER_ADDRESS = "0xAddressToGrantMinterRole";
  
  const [admin] = await ethers.getSigners();
  const contract = await ethers.getContractAt("IoTDeviceNFT", CONTRACT_ADDRESS);

  console.log("Current admin:", admin.address);
  
  // Grant MINTER_ROLE
  console.log("Granting MINTER_ROLE to:", MINTER_ADDRESS);
  const tx = await contract.grantRole(
    await contract.MINTER_ROLE(),
    MINTER_ADDRESS
  );
  await tx.wait();
  console.log(`Role granted in tx: ${tx.hash}`);

  // Verify role assignment
  const hasRole = await contract.hasRole(
    await contract.MINTER_ROLE(),
    MINTER_ADDRESS
  );
  console.log("Role assignment successful?", hasRole);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });