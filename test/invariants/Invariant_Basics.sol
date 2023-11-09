// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract A {
  bool public flag;

  function func_1() external {}
  function func_2() external {}
  function func_3() external {}
  function func_4() external {}
  function func_5() external { flag = true; }
}

contract MyInvariantTest is Test {
  A private target;

  function setUp() public {
    target = new A();
  }

  // run with `forge test --match-test invariant_flag_is_always_false
  function invariant_flag_is_always_false() public {
    assertEq(target.flag(), false);
  }
}

// defualt invariant params:
// runs = 256
// depth = 15
