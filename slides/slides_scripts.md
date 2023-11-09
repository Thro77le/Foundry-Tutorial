---
# theme: ./path/to/theme.json
author: Throttle (@Throt7le)
date: dd MMMM YYYY
paging: Slide %d / %d
---

# Overview
- ### Foundry Scripts
- ### Practice: Foundry Scripts

## Ask questions anytime

<br>

# Sources:
1. book.getfoundry.sh
2. https://www.youtube.com/@smartcontractprogrammer

---

# Foundry Scripts

## 1. Scripts are written in Solidity instead of JavaScript/Python.
## 2. 
## 3.
## <br> <br> <br>
## 4.

```solidity

pragma solidity 0.8.20;



contract MyScript {

    ...

}
```

---

# Foundry Scripts

## 1. Scripts are written in Solidity instead of JavaScript/Python.
## 2. By convention scripts are located in `script` folder and all files have `*.s.sol` file extension.
## 3.
## <br> <br> <br>
## 4.

```solidity
// project/script/Script.s.sol
pragma solidity 0.8.20;



contract MyScript {

    ...
    
}
```

---

# Foundry Scripts

## 1. Scripts are written in Solidity instead of JavaScript/Python.
## 2. By convention scripts are located in `script` folder and all files have `*.s.sol` file extension.
## 3. Every foundry script should import `Script` that comes with scripting utilities 
## <br> <br> <br> and should implement `run()` function - it's an entrypoint for script engine
## 4.

```solidity
// project/script/Script.s.sol
pragma solidity 0.8.20;

import { Script } from "forge-std/Script.sol";

contract MyScript is Script {
    function run() public returns (bool) {
        ...
    }
}
```

---

# Foundry Scripts - basics

## 1. Scripts are written in Solidity instead of JavaScript/Python.
## 2. By convention scripts are located in `script` folder and all files have `*.s.sol` file extension.
## 3. Every foundry script should import `Script` that comes with scripting utilities
## <br> <br> <br> and should implement `run()` function - it's an entrypoint for script engine
## 4. To run them type `$ forge script script/MyScript.s.sol:MyScript`

```solidity
// project/script/Script.s.sol
pragma solidity 0.8.20;

import { Script } from "forge-std/Script.sol";

contract MyScript is Script {
    function run() public returns (bool) {
        ...
    }
}
```
-> `forge script script/MyScript.s.sol:MyScript`

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. 
## -----> 1.  
## -----> 2.
## -----> 3.
## -----> 4.

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer);

        
        Config config = new Config();

        
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast();
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin);

        
        config.setDevFee(25 * BASE_FEE);      // 25%

        
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast();
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. The script workflow consists of 4 steps:
## -----> Step 1.  
## -----> Step 2.
## -----> Step 3.
## -----> Step 4.

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer);

        
        Config config = new Config();

        
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast();
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin);

        
        config.setDevFee(25 * BASE_FEE);      // 25%

        
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast();
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. The script workflow consists of 4 steps:
## -----> Step 1. Calls Generation: Local simulation -> list of calls. (Obligatory. Context depends on `--fork-url` argument. Script != Contract)
## -----> Step 2.
## -----> Step 3.
## -----> Step 4.

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer); // Start collecting external calls here

        // Call 1
        Config config = new Config();

        // Call 2
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast(); // Stop collecting external calls here
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin); // Start collecting external calls here

        // Call 1
        config.setDevFee(25 * BASE_FEE);      // 25%

        // Call 2
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        // Call 3
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast(); // Stop collecting external calls here
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```
## `$ forge script script/Script.s.sol:DeploymentScript` // Empty local context
## `$ forge script script/Script.s.sol:DeploymentScript --fork-url <MAINNET_RPC_URL>` // Forked local context

## `$ forge script script/Script.s.sol:UpdateScript` // ????
## `$ forge script script/Script.s.sol:UpdateScript --fork-url <MAINNET_RPC_URL>` // Forked local context

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. The script workflow consists of 4 steps:
## -----> Step 1. Calls Generation: Local simulation -> list of calls. (Obligatory. Context depends on `--fork-url` argument. Script != Contract)
## -----> Step 2. Simulation: Sequentially simulate on-chain transactions. (Optional - needs `--fork-url` argument)
## -----> Step 3.
## -----> Step 4.

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer);

        // Call 1
        Config config = new Config();

        // Call 2
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast();
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin);

        // Call 1
        config.setDevFee(25 * BASE_FEE);      // 25%

        // Call 2
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        // Call 3
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast();
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```
## `$ forge script script/Script.s.sol:DeploymentScript --fork-url <MAINNET_RPC_URL>`

## `$ forge script script/Script.s.sol:UpdateScript --fork-url <MAINNET_RPC_URL>`

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. The script workflow consists of 4 steps:
## -----> Step 1. Calls Generation: Local simulation -> list of calls. (Obligatory. Context depends on `--fork-url` argument. Script != Contract)
## -----> Step 2. Simulation: Sequentially simulate on-chain transactions. (Optional - needs `--fork-url` argument)
## -----> Step 3. Broadcast: Sequentially execute on-chain calls from the list. (Optional - needs `--broadcast` flag)
## -----> Step 4.

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer);

        // Call 1
        Config config = new Config();

        // Call 2
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast();
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin);

        // Call 1
        config.setDevFee(25 * BASE_FEE);      // 25%

        // Call 2
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        // Call 3
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast();
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```
## `$ forge script script/Script.s.sol:DeploymentScript --fork-url <MAINNET_RPC_URL> --broadcast`

## `$ forge script script/Script.s.sol:UpdateScript --fork-url <MAINNET_RPC_URL> --broadcast`

---

# Foundry Scripts - the workflow

## 1. With scripts you can send transactions and deploy smart contracts
## 2. The script workflow consists of 4 steps:
## -----> Step 1. Calls Generation: Local simulation -> list of calls. (Obligatory. Context depends on `--fork-url` argument. Script != Contract)
## -----> Step 2. Simulation: Sequentially simulate on-chain transactions. (Optional - needs `--fork-url` argument)
## -----> Step 3. Broadcast: Sequentially execute on-chain calls from the list. (Optional - needs `--broadcast` flag)
## -----> Step 4. Verification: Send verification request to etherscan. (Optional - needs `--verify` flag and API KEY)

```solidity
contract DeploymentScript is Script {
    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(private_key);

        vm.startBroadcast(deployer);

        // Call 1
        Config config = new Config();

        // Call 2
        Exchange exchange = new Exchange(config);

        vm.stopBroadcast();
        return exchange.isInitialized();
    }
}

contract UpdateScript is Script {
    Config config = Config(0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0);

    function run() public returns (bool) {
        uint256 private_key = vm.envUint("PRIVATE_KEY");
        address admin = vm.rememberKey(private_key);

        uint256 BASE_FEE = vm.envUint("BASE_FEE");

        vm.startBroadcast(admin);

        // Call 1
        config.setDevFee(25 * BASE_FEE);      // 25%

        // Call 2
        config.setAdminFee(25 * BASE_FEE);    // 25%    

        // Call 3
        config.setProtocolFee(50 * BASE_FEE); // 50%   
 
        vm.stopBroadcast();
        return (config.getDevFee() + config.setAdminFee() + config.setProtocolFee()) == 100 * BASE_FEE;
    }
}
```
## `$ forge script script/Script.s.sol:DeploymentScript --fork-url <MAINNET_RPC_URL> --broadcast --verify`

## `$ forge script script/Script.s.sol:UpdateScript --fork-url <MAINNET_RPC_URL> --broadcast`

---

# Practice: Scripts + Deployment

Let's deploy some tokens to public test blckchain

You should have:
1. Private Key - generate random 256-bit number
2. Some gas token - get your Seploia ETH here https://sepolia-faucet.pk910.de/#/
2. Node RPC URL - get it here https://www.alchemy.com/
3. Etherscan APIKEY - get it here https://etherscan.io/

