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

  constructor(WETH _weth) {
    weth = _weth;
  }

  modifier prank(address actor) {
    vm.startPrank(actor);
    _;
    vm.stopPrank();
  }

  function deposit(uint256 amount) public prank(msg.sender) {
    amount = bound(amount, 0, msg.sender.balance);
    wethBalance += amount;

    weth.deposit{value: amount}();
  }

  function withdraw(uint256 amount) public prank(msg.sender) {
    amount = bound(amount, 0, weth.balanceOf(msg.sender));
    wethBalance -= amount;

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

    targetContract(address(handler));
    
    bytes4[] memory selectors = new bytes4[](2);
    selectors[0] = Handler.deposit.selector;
    selectors[1] = Handler.withdraw.selector;
    targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));

    for (uint256 i = 1337; i < 1337 + 3; i++) {
      targetSender(address(uint160(i)));
      deal(address(uint160(i)), 100 ether);
    }
  }

  // run with `forge test --match-test invariant_actor_management`
  function invariant_actor_management() public {
    uint256 total = 0;
    for (uint256 i = 1337; i < 1337 + 3; i++) {
      total += weth.balanceOf(address(uint160(i)));
    }
    assertEq(address(weth).balance, total);
  }
}
