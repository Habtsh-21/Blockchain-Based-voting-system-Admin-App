

const hre = require("hardhat");

async function main() {

  const election = await hre.ethers.getContractFactory("Election");
  
  console.log("Deploying Voting contract...");
  const voting = await election.deploy();
  
  await voting.waitForDeployment();
  
  const contractAddress = await voting.getAddress();
  console.log("Voting contract deployed to:", contractAddress);
  console.log("Transaction hash:", voting.deploymentTransaction().hash);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });