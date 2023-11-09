// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

import {StoreV1} from "../src/deployment/StoreV1.sol";
import {StoreV2} from "../src/deployment/StoreV2.sol";

contract DeploymentScript is Script {
  function run() public returns (bool) {
    console2.log("Starting deployment script...");

    uint256 private_key = vm.envUint("PRIVATE_KEY");
    address deployer = vm.rememberKey(private_key);

    vm.startBroadcast(deployer);

    // CODE GOES HERE ...

    vm.stopBroadcast();

    return true;
  }
}

contract UpgradeScript is Script {
  function run() public returns (bool) {
    console2.log("Starting upgrade script...");

    // ITransparentUpgradeableProxy proxy = ITransparentUpgradeableProxy(0x0000000000000000000000000000000000000000);
    // ProxyAdmin admin = ProxyAdmin(0x0000000000000000000000000000000000000000);

    uint256 private_key = vm.envUint("PRIVATE_KEY");
    address deployer = vm.rememberKey(private_key);

    vm.startBroadcast(deployer);

    // CODE GOES HERE ...

    vm.stopBroadcast();

    return true;
  }
}
