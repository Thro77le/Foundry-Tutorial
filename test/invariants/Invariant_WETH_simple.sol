// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {WETH} from "../../src/invariants/WETH.sol";

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}

// explain: [PASS] invariant_totalSupply_is_always_zero() (runs: 256, calls: 3840, reverts: 2212)
