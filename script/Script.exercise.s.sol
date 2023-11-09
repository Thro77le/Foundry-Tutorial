// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {StoreV1} from "../src/deployment/StoreV1.sol";
import {StoreV2} from "../src/deployment/StoreV2.sol";

// `forge script script/Script.s.sol:DeploymentScript`
// `forge script script/Script.s.sol:DeploymentScript --fork-url https://eth-sepolia.g.alchemy.com/v2/S00djRx86FNvDonBPp8LjoSJe4t1ZFf1`
// `forge script script/Script.s.sol:DeploymentScript --fork-url https://eth-sepolia.g.alchemy.com/v2/S00djRx86FNvDonBPp8LjoSJe4t1ZFf1 --broadcast --verify`
contract DeploymentScript is Script {
  function run() public returns (bool) {
    console2.log("Starting deployment script...");

    uint256 private_key = vm.envUint("PRIVATE_KEY");
    address deployer = vm.rememberKey(private_key);

    vm.startBroadcast(deployer);

    // TODO: FILL HERE

    vm.stopBroadcast();

    return true;
  }
}

// `forge script script/Script.s.sol:UpgradeScript --fork-url https://eth-sepolia.g.alchemy.com/v2/S00djRx86FNvDonBPp8LjoSJe4t1ZFf1 --broadcast --verify`
contract UpgradeScript is Script {
  function run() public returns (bool) {
    console2.log("Starting upgrade script...");

    // address proxy = address(0); // TODO - fill with proxy address

    uint256 private_key = vm.envUint("PRIVATE_KEY");
    address deployer = vm.rememberKey(private_key);

    vm.startBroadcast(deployer);

    // TODO: FILL HERE

    vm.stopBroadcast();

    return true;
  }
}
