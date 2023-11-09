// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {Nice} from "Nice/Nice.sol";

contract SendFundsScript is Script {
  using Nice for uint256;

  bool internal success = true;
  uint256 internal private_key = vm.envUint("PRIVATE_KEY");
  address internal deployer = vm.rememberKey(private_key);

  function send_funds_to(string memory prive_key_env, uint256 amount) internal returns (bool success) {
    uint256 private_key = vm.envUint(prive_key_env);
    address account = vm.rememberKey(private_key);
    (success, ) = account.call{value: amount}("");
    console2.log("Prive key %s", private_key);
    console2.log("Balance of address %s = ETH", account, account.balance.format());
    console2.log("--------------------------------------------------");
  }
}

// @note: run with `forge script script/SendFunds.s.sol:SendFundsSepoliaScript --fork-url https://eth-sepolia.g.alchemy.com/v2/S00djRx86FNvDonBPp8LjoSJe4t1ZFf1 --broadcast`
contract SendFundsSepoliaScript is SendFundsScript {
  function run() public returns (bool) {

    vm.startBroadcast(deployer);

    success = success && send_funds_to("PRIVATE_KEY_1", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_2", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_3", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_4", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_5", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_6", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_7", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_8", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_9", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_10", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_11", 0.25 ether);
    success = success && send_funds_to("PRIVATE_KEY_12", 0.25 ether);

    vm.stopBroadcast();

    return success;
  }
}

// @note: run with `forge script script/SendFunds.s.sol:SendFundsArbitrumGoerliScript --fork-url https://arb-goerli.g.alchemy.com/v2/Dml0kwE0lwgjJqqZzOiTjn1HMcRGGqQM --broadcast`
contract SendFundsArbitrumGoerliScript is SendFundsScript {
  function run() public returns (bool) {

    vm.startBroadcast(deployer);

    success = success && send_funds_to("PRIVATE_KEY_13", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_14", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_15", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_16", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_17", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_18", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_19", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_20", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_21", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_22", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_23", 0.15 ether);
    success = success && send_funds_to("PRIVATE_KEY_24", 0.15 ether);

    vm.stopBroadcast();

    return success;
  }
}
