import "@nomicfoundation/hardhat-toolbox";

// This import is often implicitly available but is good practice for type hinting
// @ts-ignore
// import { HardhatUserConfig } from "hardhat/config"; 

/**
 * @type {import('hardhat/config').HardhatUserConfig}
 */
const config = {
  solidity: {
    // Set to your contract's pragma version
    version: "0.8.26", 
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      // Essential for fixing the 'UnimplementedFeatureError' with struct arrays
      viaIR: true, 
    },
  },
  networks: {
    // You can configure your testnets and mainnets here
    hardhat: {
      // Default local network settings
    },
  },
};

export default config;