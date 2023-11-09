// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../../src/basics/Counter.sol";
import {Nice} from "Nice/Nice.sol";

contract CounterTest is Test {
    Counter public counter;
    using Nice for uint256;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_console() public {
        uint256 a = 1.234e18; // 1.234
        uint256 b = 0.89e18;  // 0.89
        console2.log("a = %s", a);
        console2.log("b = %s", b);
        console2.log("a * b = %s", a * b / 1e18);
    }

    function test_nice() public {
        uint a = 1.234e18; // 1.234
        uint b = 0.89e18;  // 0.89
        console2.log("b = %s", b.format());
        console2.log("a * b = %s", (a * b / 1e18).format());
    }
}
