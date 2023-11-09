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

    StoreV1 implementation = new StoreV1();
    console2.log("Implementation address = %s", address(implementation));

    ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");
    console2.log("Proxy address = %s", address(proxy));

    StoreV1 store = StoreV1(address(proxy)); // wrap Contract ABI around proxy

    store.initialize(100);

    console2.log("x = %s", store.x());

    vm.stopBroadcast();

    return true;
  }
}

// TODO: talk about security concerns

// `forge script script/Script.s.sol:UpgradeScript --fork-url https://eth-sepolia.g.alchemy.com/v2/S00djRx86FNvDonBPp8LjoSJe4t1ZFf1 --broadcast --verify`
contract UpgradeScript is Script {
  function run() public returns (bool) {
    console2.log("Starting upgrade script...");

    address proxy = 0x78736fC4C283B5816fa60ac6a086887e36AfD30f; // TODO - fill with proxy address

    uint256 private_key = vm.envUint("PRIVATE_KEY");
    address deployer = vm.rememberKey(private_key);

    vm.startBroadcast(deployer);

    StoreV2 new_implementation = new StoreV2();
    console2.log("New implementation address = %s", address(new_implementation));

    StoreV2 store2 = StoreV2(proxy); // wrap Contract ABI around proxy
    store2.upgradeToAndCall(address(new_implementation), "");

    store2.setY(200);

    console2.log("x = %s", store2.x());
    console2.log("y = %s", store2.y());

    vm.stopBroadcast();

    return true;
  }
}

// TODO: https://sepolia.etherscan.io/address/...