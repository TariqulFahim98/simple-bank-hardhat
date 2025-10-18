const hre = require("hardhat");
    async function main(){
        console.log("Deploying simple-bank...");
        const Bank = await hre.ethers.getContractFactory("Simple_Bank");
        const bank = await Bank.deploy(5,6);

        await bank.waitForDeployment();
        const contractAddress = await bank.getAddress();
        console.log(`Contract Address : ${contractAddress}`);
    }
    main()
    .then(()=>process.exit(0))
    .catch((error)=>{
        console.error("Error",error);
        process.exit(1);
    })
