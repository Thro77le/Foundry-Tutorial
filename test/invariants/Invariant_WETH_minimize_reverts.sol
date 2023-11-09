// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {WETH} from "../../src/invariants/WETH.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
  WETH private weth;
  uint256 public wethBalance;
  uint256 public numCalls;

  constructor(WETH _weth) {
    weth = _weth;
  }

  function deposit(uint256 amount) public {
    amount = bound(amount, 0, address(this).balance);
    wethBalance += amount;
    numCalls += 1;

    weth.deposit{value: amount}();
  }

  function withdraw(uint256 amount) public {
    amount = bound(amount, 0, weth.balanceOf(address(this)));
    wethBalance -= amount;
    numCalls += 1;

    weth.withdraw(amount);
  }

  receive() external payable {}
}

contract WETH_Handler_Based_Invariant_Tests is Test {
  WETH public weth;
  Handler public handler;

  function setUp() public {
    weth = new WETH();
    handler = new Handler(weth);

    deal(address(handler), 100 * 1e18);

    targetContract(address(handler));

    bytes4[] memory selectors = new bytes4[](2);
    selectors[0] = Handler.deposit.selector;
    selectors[1] = Handler.withdraw.selector;

    targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
  }

  // run with `forge test --match-test invariant_eth_balance`
  function invariant_eth_balance() public {
    assertGe(address(weth).balance, handler.wethBalance());
    console2.log("handler num calls", handler.numCalls());
  }
}