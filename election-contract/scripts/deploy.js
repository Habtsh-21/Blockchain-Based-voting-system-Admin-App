const hre = require("hardhat");

async function main() {
  const Election = await hre.ethers.getContractFactory("Election");
  console.log("Deploying ElectionContract...");
  const election = await Election.deploy();
  await election.waitForDeployment();
  console.log("ElectionContract deployed to:", election.getAddress());
  console.log("Transaction hash:", election.deploymentTransaction().hash);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
